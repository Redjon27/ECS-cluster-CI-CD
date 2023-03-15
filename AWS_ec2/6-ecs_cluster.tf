#######################################################################################
# Create task definition for Fargate app
#######################################################################################

resource "aws_ecs_task_definition" "hello-world-app1" {
  family                   = "hello-world-app1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 4096
  memory                   = 9216
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "hello-world-app1"
      image     = "${aws_ecr_repository.docker.repository_url}"
      essential = true
      cpu       = 2048
      memory    = 4096

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "HTTP"
        }
      ]

      ulimits = [
        {
          name      = "nofile",
          softLimit = 1024000,
          hardLimit = 1024000
        }
      ]

      /* healthCheck = {
        retries  = 5
        command  = ["aws_lb.application_load_balancer.dns_name || exit 1"]
        timeout  = 5
        interval = 5
      } */

      logConfiguration = {
        logDriver     = "awslogs",
        secretOptions = [],
        options = {
          "awslogs-group"         = "example_container",
          "awslogs-region"        = "eu-central-1",
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "ecs/hello-world-app1",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

#######################################################################################
# Provides a CloudWatch Log Group resource.
#######################################################################################

resource "aws_cloudwatch_log_group" "example_container" {
  name = "ecs/hello-world-app1"

  tags = {
    Environment = "Dev"
    Application = "hello-world-app1"
  }
}

#######################################################################################
# Provides a resource to manage a CloudWatch log resource policy.
#######################################################################################

data "aws_iam_policy_document" "elasticsearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

#######################################################################################
# Create policy for cloudwatch log
#######################################################################################

resource "aws_cloudwatch_log_resource_policy" "elasticsearch-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json
  policy_name     = "elasticsearch-log-publishing-policy"
}

#######################################################################################
# Create the cluster
#######################################################################################

resource "aws_ecs_cluster" "main" {
  name = "test-cluster"
}

#######################################################################################
# Create the ecs service
#######################################################################################

resource "aws_ecs_service" "hello-world1" {
  name                               = "hello-world1-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.hello-world-app1.arn
  platform_version                   = "1.4.0"
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  force_new_deployment               = true
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  # Attach Network Configuration to ECS service 
  network_configuration {
    subnets          = ["subnet-09f6ccee580256269", "subnet-0c0e02906cf61332c"]
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  # Attach load balancing to ECS service
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "hello-world-app1"
    container_port   = 80
  }
  depends_on = [aws_lb_target_group.alb_target_group]
}

#######################################################################################
# Create an auto scaling group for the ecs service
#######################################################################################
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/test-cluster/hello-world1-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#######################################################################################
#Create an auto scaling policy for the ecs service
#######################################################################################

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}