# resource "aws_ssm_parameter" "wifi_ssid" {
#   name  = "/${var.project_name}/${var.env}/wifi/ssid"
#   type  = "String"
#   value = var.wifi_ssid
# }

# resource "aws_ssm_parameter" "wifi_password" {
#   name  = "/${var.project_name}/${var.env}/wifi/password"
#   type  = "SecureString"
#   value = var.wifi_password
# }

resource "aws_ssm_parameter" "iot_endpoint" {
  name  = "/${var.project_name}/${var.env}/iot/endpoint"
  type  = "String"
  value = var.iot_endpoint
}

resource "aws_ssm_parameter" "device_certificate" {
  name  = "/${var.project_name}/${var.env}/iot/certificate_pem"
  type  = "SecureString"
  value = var.certificate_pem
}

resource "aws_ssm_parameter" "private_key" {
  name  = "/${var.project_name}/${var.env}/iot/private_key"
  type  = "SecureString"
  value = var.private_key
}

resource "aws_ssm_parameter" "root_ca" {
  name  = "/${var.project_name}/${var.env}/iot/root_ca"
  type  = "SecureString"
  value = sensitive(var.root_ca)
}