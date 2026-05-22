variable "aws_region" {}
#variable "thing_name" {}
variable "firmware_bucket" {}
variable "env" {}
variable "project_name" {}
variable "cert_bucket_name" {
  type = string
}
variable "github_branch" {
  type = string
}
variable "codebuild_project_name" {
  type = string
}