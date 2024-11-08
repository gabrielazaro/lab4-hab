#Redis

resource "aws_elasticache_replication_group" "redis-lab4" {
  automatic_failover_enabled  = true
  preferred_cache_cluster_azs = module.vpc.azs
  replication_group_id        = "redis-lab4"
  description                 = "Redis replication group for lab4"
  node_type                   = "cache.t4g.micro"
  engine                      = "redis"
  engine_version              = "7.1"
  parameter_group_name        = "default.redis7"
  port                        = 6379
  num_node_groups             = 1
  replicas_per_node_group     = 1
  subnet_group_name           = aws_elasticache_subnet_group.cache_subnet_group.name
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
}

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "cache-subnet-group"
  subnet_ids = [aws_subnet.cache-subnet-1.id, aws_subnet.cache-subnet-2.id]

  tags = {
    Name        = "cache-subnet-group"
    Environment = var.environment
    Owner       = "gabriela"
    Project     = "lab4"
  }
}

# Alarma para uso de memoria de Redis
resource "aws_cloudwatch_metric_alarm" "redis_memory" {
  alarm_name          = "redis-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  
  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.redis-lab4.id
  }
}
