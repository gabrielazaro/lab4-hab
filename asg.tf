resource "aws_launch_template" "lt-lab4" {
  image_id      = "ami-0814e461d7d908d17"  # Reemplaza con un AMI válido en tu región
  instance_type = "t2.micro"
  
 user_data = base64encode(<<-EOF
    #!/bin/bash -xe

    sed -i "s/define('DB_HOST',.*/define('DB_HOST', '${aws_db_instance.rds-lab4.address}');/" /var/www/html/wp-config.php

    # Montar EFS
    mkdir -p /var/www/html/wp-content/uploads
    mount -t efs -o tls ${aws_efs_file_system.efs-lab4.id}:/ /var/www/html/wp-content/uploads
    echo "${aws_efs_file_system.efs-lab4.id}:/ /var/www/html/wp-content/uploads efs _netdev,tls 0 0" >> /etc/fstab

    # Configurar Redis
    echo "define('WP_REDIS_HOST', '${aws_elasticache_replication_group.redis-lab4.primary_endpoint_address}');" >> /var/www/html/wp-config.php
    echo "define('WP_REDIS_PORT', '6379');" >> /var/www/html/wp-config.php

    # Reiniciar servicios
    systemctl restart httpd
  EOF
  )

  # Perfil de instancia IAM que tiene permisos para S3 y SSM
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false  
    security_groups             = [aws_security_group.ec2-sg-lab4.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "lt-lab4"
      Environment = var.environment
      Owner       = "gabriela"
      Project     = "lab4"
    }
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2-access-role.name
}

resource "aws_autoscaling_group" "asg-lab4" {
  name = "asg-lab-4"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 2
  launch_template {
    id = aws_launch_template.lt-lab4.id
    version = "$Latest"
  }
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
  
  vpc_zone_identifier = module.vpc.private_subnets


  target_group_arns = [aws_lb_target_group.alb-target-group.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
      key                 = "Name"
      value               = "asg-lab4"
      propagate_at_launch = true
     
    }
}
