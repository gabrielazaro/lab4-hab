/*resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  # ...otras configuraciones de EC2...
}

*/

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_s3_access_role.name
  #role de SSM
}

resource "aws_launch_template" "lt-lab4" {
  image_id      = "ami-0866a3c8686eaeeba"  # Reemplaza con un AMI válido en tu región
  instance_type = "t2.micro"
  
   user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    echo "<html><h1>Hola Mundo desde Nginx!</h1></html>" > /var/www/html/index.html
    systemctl start nginx
    systemctl enable nginx
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

resource "aws_autoscaling_group" "asg-lab4" {
  name = "asg-lab-4"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 2
  launch_template {
    id = aws_launch_template.lt-lab4.id
    version = "$Latest"
  }
#falta activar el monitoring
  
  vpc_zone_identifier = module.vpc.private_subnets


  target_group_arns = [aws_lb_target_group.internal_alb_target_group.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
      key                 = "Name"
      value               = "asg-lab4"
      propagate_at_launch = true
     
    }
}
