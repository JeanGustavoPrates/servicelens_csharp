resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
    }]
  })
}

resource "aws_iam_policy" "ssm_parameter_access_policy" {
  name        = "ssm_parameter_access_policy"
  description = "Policy to allow ECS tasks to access SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ssm:GetParameters",
        Resource = "arn:aws:ssm:*:*:parameter/ecs-cwagent"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_parameter_access_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ssm_parameter_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "xray-policy-attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy" "ecs_ecr_policy" {
  name        = "ecs_ecr_policy"
  description = "Permite que tarefas ECS obtenham tokens de autorização do ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "ecr:GetAuthorizationToken",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ecr_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_ecr_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_ecr_readonly_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}