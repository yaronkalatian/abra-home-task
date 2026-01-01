resource "aws_apigatewayv2_vpc_link" "abra" {
  name               = "alb-vpc-link"
  subnet_ids         = var.private_subnets
  security_group_ids = [aws_security_group.vpc_link.id]
}

resource "aws_apigatewayv2_api" "abra" {
  name          = "hello-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "alb" {
  api_id             = aws_apigatewayv2_api.abra.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.alb_listener_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.abra.id
}
