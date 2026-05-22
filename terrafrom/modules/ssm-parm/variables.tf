variable "env" {}
variable "project_name" {}

variable "certificate_pem" {
  type = string
}
variable "private_key" {
  type = string
}
variable "root_ca" {
  type = string
}
variable "iot_endpoint" {
  type = string
}