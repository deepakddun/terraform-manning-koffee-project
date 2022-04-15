#resource "aws_ecr_repository" "manning_project_repo" {
#  name = var.repo-name
#  tags = {
#    For = "Manning-project-${var.namespace}"
#  }
#}

resource "aws_ecs_cluster" "sample_cluster" {
  name = "sample_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "sample_cluster_task_definition" {
  container_definitions = file("${path.module}/templates/container_definition.json")
  family                = "sample_terraform_task_definition"
  cpu                   = 256
  memory                = 512
  execution_role_arn    = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode          = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  requires_compatibilities = ["FARGATE"]
}

#data "aws_subnets" "private" {
#  filter {
#    name   = "vpc-id"
#    values = ["vpc-ac6d734yrbfjd7ebc7"]
#  }
#
#}




resource "aws_ecs_service" "sample_service" {
  name            = "sample_ecs_service"
  cluster         = aws_ecs_cluster.sample_cluster.arn
  task_definition = aws_ecs_task_definition.sample_cluster_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = var.vpc.subnet_id_private_app
    security_groups  = [var.sg.ecs_sg]
    assign_public_ip = "true"
  }
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_ecs_target_group.arn
    container_name   = "sample-container-image"
    container_port   = 5000
  }
  depends_on = [aws_ecs_task_definition.sample_cluster_task_definition, aws_ecs_cluster.sample_cluster, aws_lb.aws_ecs_lb]
}

#############################  LOAD BALANCHER ############################################
resource "aws_lb" "aws_ecs_lb" {
  name               = "ecs-lb"
  internal           = "false"
  load_balancer_type = "application"
  security_groups    = [var.sg.lb_sg]
  subnets            = var.vpc.subnet_id_public
}

resource "aws_lb_listener" "aws_ecs_lb_listener" {
  load_balancer_arn = aws_lb.aws_ecs_lb.arn
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_ecs_target_group.arn
  }
  port = 80
}

#resource "aws_lb_listener_rule" "aws_ecs_lb_listener_rule" {
#  listener_arn = aws_lb_listener.aws_ecs_lb_listener.arn
#  action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.aws_ecs_target_group.arn
#  }
#  condition {
#
#  }
#}

resource "aws_lb_target_group" "aws_ecs_target_group" {
  name        = "aws-ecs-target-group"
  target_type = "ip"
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc.vpc_id
}