# Security Module to create AWS/IoT Policy and Roles
module "security" {
  source = "./modules/security"

  env          = var.env
  project_name = var.project_name
}

# Create the IoT Thing, Certificate and attache necessary policy.
module "iot" {
  source = "./modules/iot"

  env              = var.env
  project_name     = var.project_name
  iot_policy_name  = module.security.iot_policy_name
  cert_bucket_name = var.cert_bucket_name
}

# Create the CodeBuild & CodePipeline.
module "cicd" {
  source = "./modules/cicd"

  env                            = var.env
  project_name                   = var.project_name
  codebuild_role_arn             = module.security.codebuild_role_arn
  codepipeline_role_arn          = module.security.codepipeline_role_arn
  cert_bucket_name               = var.cert_bucket_name
  github_branch                  = var.github_branch
  github_connection_arn          = module.security.github_connection_arn
  codebuild_project_name         = var.codebuild_project_name
  codebuild_policy_attachment_id = module.security.codebuild_policy_attachment_id
  depends_on = [
    module.security
  ]
}

# Create SSM Parameter.
module "ssm-parm" {
  source = "./modules/ssm-parm"

  env             = var.env
  project_name    = var.project_name
  certificate_pem = module.iot.certificate_pem
  private_key     = module.iot.private_key
  root_ca         = module.iot.root_ca
  iot_endpoint    = module.iot.iot_endpoint
}

