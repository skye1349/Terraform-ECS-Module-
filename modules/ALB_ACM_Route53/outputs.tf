output "alb_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.alb.id
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_lb.alb.zone_id
}
output "target_group_arn" {
  value = aws_lb_target_group.ip-example.arn
}
