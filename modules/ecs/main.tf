resource "aws_ecs_cluster" "abra" {
  name = var.app_name
}

resource "aws_ecs_task_definition" "abra" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name  = "hello"
      image = "nginxdemos/hello"
      portMappings = [{
        containerPort = 80
      }]
    }
  ])
}

resource "aws_ecs_service" "abra" {
  cluster         = aws_ecs_cluster.abra.id
  task_definition = aws_ecs_task_definition.abra.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "hello"
    container_port   = 80
  }
}
