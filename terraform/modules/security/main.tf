# IoT Policy Creation
resource "aws_iot_policy" "iot_policy" {
  name = "${var.project_name}-${var.env}-iot-policy"

  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive"
        ]
        Resource = "*"
      }
    ]
  })
}

# CodeBuild Policy Creation
resource "aws_iam_policy" "codebuild_policy" {
  name = "${var.project_name}-${var.env}-iam-codebuild-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "CloudWatchGroupAccess",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:ap-south-1:160885282586:log-group:/aws/codebuild/${var.project_name}-${var.env}-cw",
          "arn:aws:logs:ap-south-1:160885282586:log-group:/aws/codebuild/${var.project_name}-${var.env}-cw:*"
        ]
      },
      {
        "Sid" : "S3Access",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.project_name}-${var.env}-Swps-firmware/PumpNode-firmware/*",
          "arn:aws:s3:::${var.project_name}-${var.env}-codepipeline/attributes/*"
        ]
      },
      {
        "Sid" : "CodebuildAccess",
        "Effect" : "Allow",
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        "Resource" : [
          "arn:aws:codebuild:ap-south-1:160885282586:report-group/${var.project_name}-${var.env}-*"
        ]
      },
      {
        "Sid" : "SSMReadAccess",
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:ssm:ap-south-1:160885282586:parameter/${var.project_name}-${var.env}-ssm-parameter/*"
        ]
      },
      {
        "Sid" : "AllowPublishOtaMessage",
        "Effect" : "Allow",
        "Action" : [
          "iot:Publish"
        ],
        "Resource" : [
          "arn:aws:iot:ap-south-1:160885282586:topic/devices/${var.project_name}-${var.env}-iot-topic/ota"
        ]
      },
      {
        Sid    = "AllowGitHubCodeConnection"
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection",
          "codeconnections:UseConnection"
        ]
        Resource = "arn:aws:codestar-connections:ap-south-1:160885282586:connection/*"
      }
    ]
  })
}

# Code Build Role Creation and policy attachment.
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-${var.env}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

# CodePipeline Policy Creation
resource "aws_iam_policy" "codepipeline_policy" {
  name = "${var.project_name}-${var.env}-iam-codepipeline-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3BucketAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.project_name}-${var.env}-codepipeline"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceAccount" : "160885282586"
          }
        }
      },
      {
        "Sid" : "AllowS3ObjectAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.project_name}-${var.env}-codepipeline/attributes/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceAccount" : "160885282586"
          }
        }
      }
    ]
  })
}


# Code Build Role Creation and policy attachment.
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-${var.env}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# Creating the Codeconnections
resource "aws_codestarconnections_connection" "github" {
  name          = "swps-${var.env}-github"
  provider_type = "GitHub"
}