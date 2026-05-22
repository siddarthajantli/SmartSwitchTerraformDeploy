
# Create the codepipeline.
resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_name}-${var.env}-codepipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.cert_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHubSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = "siddarthajantli/SmartSwitchDWROTADeploy"
        BranchName       = var.github_branch
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "CodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }
}


# CodeBuild project creation.
resource "aws_codebuild_project" "codebuild_project" {
  name         = "${var.project_name}-${var.env}-codebuild-project"
  description  = "gets_source_from_github_via_the_github_app"
  service_role = var.codebuild_role_arn
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
    #location        = "https://github.com/siddarthajantli/SmartSwitchTerraformDeploy.git"
    #git_clone_depth = 1
    buildspec = "buildspec.yml"
  }
}


