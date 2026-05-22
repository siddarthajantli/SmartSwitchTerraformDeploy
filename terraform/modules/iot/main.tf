# IoT Thing.
resource "aws_iot_thing" "iot-thing" {
  name = "${var.project_name}-${var.env}-IoT-Thing"
}

# IoT Certificate.
resource "aws_iot_certificate" "iot_cert" {
  active = true
}

# Policy Attche to Certificate.
resource "aws_iot_policy_attachment" "policy_attach" {
  policy = var.iot_policy_name
  target = aws_iot_certificate.iot_cert.arn
}

# Attache the Certificate to IoTThing.
resource "aws_iot_thing_principal_attachment" "thing_attach" {
  principal = aws_iot_certificate.iot_cert.arn
  thing     = aws_iot_thing.iot-thing.name
}

# Push the certificate to AWS S3 Pribvate Bucket
resource "aws_s3_object" "device_cert" {
  bucket = var.cert_bucket_name
  key    = "iot-certs/${var.env}/${aws_iot_thing.iot-thing.name}/certificate.pem"

  content = aws_iot_certificate.iot_cert.certificate_pem

  server_side_encryption = "AES256"
  content_type           = "application/x-pem-file"
}

resource "aws_s3_object" "private_key" {
  bucket = var.cert_bucket_name
  key    = "iot-certs/${var.env}/${aws_iot_thing.iot-thing.name}/private.key"

  content = aws_iot_certificate.iot_cert.private_key

  server_side_encryption = "AES256"
  content_type           = "application/x-pem-file"
}

resource "aws_s3_object" "root_ca" {
  bucket = var.cert_bucket_name
  key    = "iot-certs/${var.env}/${aws_iot_thing.iot-thing.name}/AmazonRootCA1.pem"

  content = sensitive(data.http.amazon_root_ca.response_body)

  server_side_encryption = "AES256"
  content_type           = "application/x-pem-file"
}