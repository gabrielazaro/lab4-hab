# Memcached
resource "aws_elasticache_cluster" "memcached-lab4" {
  cluster_id           = "memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t2.micro" # Ajusta según tus necesidades
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6" # Asegúrate de que sea compatible con la versión

  security_group_ids = [aws_security_group.cache-sg-lab4.id]
  subnet_group_name  = aws_elasticache_subnet_group.cache_subnet_group.name

  tags = {
    Name        = "session-memcached-cache"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

#Redis


resource "aws_elasticache_cluster" "redis-lab4" {
  cluster_id           = "redis-lab4"
  engine               = "redis"
  node_type            = "cache.t2.micro" 
  num_cache_nodes      = 1                
  parameter_group_name = "default.redis7.cluster.on" 

  security_group_ids = [aws_security_group.cache-sg-lab4.id]
  subnet_group_name  = aws_elasticache_subnet_group.cache_subnet_group.name

  tags = {
    Name        = "redis-lab4"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}


resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "cache-subnet-group"
  subnet_ids = [ aws_subnet.cache-subnet-1.id, aws_subnet.cache-subnet-2.id]

  tags = {
    Name        = "cache-subnet-group"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}
