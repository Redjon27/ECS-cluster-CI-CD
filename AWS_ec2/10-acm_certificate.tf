#######################################################################################
# Create a ACM Certificate
#######################################################################################

resource "aws_acm_certificate" "acm_certificate" {
  domain_name = var.domain_name
  /* subject_alternative_names = [var.alternative_name] */
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

#######################################################################################
# Get details about a route 53 hosted zone
#######################################################################################

data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = true
}

#######################################################################################
# Create a record set in route 53 for domain validation
#######################################################################################

resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}

#######################################################################################
# Validate acm certificates
#######################################################################################

resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
} 