resource "aws_ecs_cluster" "cluster_csharp" {
  name = "cluster-csharp"
}

resource "aws_ecs_task_definition" "app_csharp" {
  family                   = "app-csharp"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.iam_role_arn
  

   container_definitions = jsonencode([{
    name  = "app-csharp"
    image = "${var.ecr_repository_url}:latest"
    environment = [
      {
        name = "AWS_XRAY_DAEMON_ADDRESS",
        value = "127.0.0.1:2000"
      }
  ],
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group = "true"
        awslogs-group         = "/ecs/app-csharp",
        awslogs-region        = "us-east-1",
        awslogs-stream-prefix = "ecs"
      }
    }
  },
  {
    name  = "xray-daemon"
    image = "public.ecr.aws/xray/aws-xray-daemon:latest"
    portMappings = [{
      containerPort = 2000
      hostPort      = 2000
      protocol      = "udp"
    }]
    environment = [
    {
      name  = "AWS_XRAY_LOG_LEVEL"
      value = "debug"
    }
  ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group = "true"
        awslogs-group         = "/ecs/ecs-cwagent-fargate",
        awslogs-region        = "us-east-1",
        awslogs-stream-prefix = "ecs"
      }
    }
  },
  {
    name = "cloudwatch-agent"
    image = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent:1.300026.3b189"
    # secrets = [
    #   {
    #     name = "CW_CONFIG_CONTENT",
    #     value = "{\"logs\":{\"metrics_collected\":{\"emf\":{}}}}"
    #   }
    # ],
     environment = [
      {
        name = "CW_CONFIG_CONTENT",
        value = "{\"agent\":{\"log_level\":\"INFO\"},\"logs\":{\"metrics_collected\":{\"emf\":{}}}}"
      }
  ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group = "true"
        awslogs-group         = "/ecs/cloudwatch-agent",
        awslogs-region        = "us-east-1",
        awslogs-stream-prefix = "ecs"
      }
    }
  }
  ])
}

resource "aws_ecs_service" "servico_csharp" {
  name            = "servico-csharp"
  cluster         = aws_ecs_cluster.cluster_csharp.id
  task_definition = aws_ecs_task_definition.app_csharp.arn
  launch_type     = "FARGATE"

  network_configuration {
      security_groups  = [var.security_group_id]
      subnets = [var.csharp_subnet_1.id, var.csharp_subnet_2.id]
      assign_public_ip = true
  }

  desired_count = 2 
}