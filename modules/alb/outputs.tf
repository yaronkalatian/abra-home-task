output "alb_arn" {
  value = aws_lb.abra.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}
