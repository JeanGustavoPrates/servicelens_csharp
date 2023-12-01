resource "aws_ecr_repository" "repositorio_csharp" {
  name                 = "repositorio-csharp"
  image_tag_mutability = "MUTABLE"
}