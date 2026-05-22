output "iot_policy_name" {
  value = aws_iot_policy.iot_policy.name
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "github_connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}

output "codebuild_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.codebuild_attach.id
}