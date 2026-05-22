output "root_ca" {
  value     = data.http.amazon_root_ca.response_body
  sensitive = true
}

output "thing_name" {
  value = aws_iot_thing.iot-thing.name
}

output "certificate_pem" {
  value     = aws_iot_certificate.iot_cert.certificate_pem
  sensitive = true
}

output "private_key" {
  value     = aws_iot_certificate.iot_cert.private_key
  sensitive = true
}

output "iot_endpoint" {
  value = data.aws_iot_endpoint.iot.endpoint_address
}