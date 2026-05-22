variable "env" {}
variable "project_name" {}
variable "codebuild_role_arn" {
  type = string
}
variable "github_connection_arn" {
  type = string
}
variable "github_branch" {
  type = string
}
variable "codebuild_project_name" {
  type = string
}
variable "cert_bucket_name" {
  type = string
}
variable "codepipeline_role_arn" {
  type = string
}

variable "codebuild_policy_attachment_id" {
  type = string
}