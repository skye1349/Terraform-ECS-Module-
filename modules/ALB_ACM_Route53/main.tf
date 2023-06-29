// create Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.aws_security_group_alb]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = true

  tags = {
    Environment = "uat"
  }
}

// data source to fetch hosted zone info from domain name
data "aws_route53_zone" "hosted_zone" {
  name = var.domain
  private_zone = false
}
// create acm_certificate
resource "aws_acm_certificate" "my_cert" {
    domain_name = var.domain
    subject_alternative_names = var.sub_domain
    validation_method = "DNS"
    lifecycle {
      create_before_destroy = true
    }
    tags = {
      Name = var.domain
    }   
}
//DNS validation create CNAME record in Route53
resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.my_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.my_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

#Create A record towards ALB from Route53
resource "aws_route53_record" "alias_record" {
  name = "Aname"
  zone_id = data.aws_route53_zone.hosted_zone.id
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
//create IP type target group
resource "aws_lb_target_group" "ip-example" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = var.health_check_path
    matcher = "200,202"
  }
}
// create listener 80 and redirected to 443
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
}
}
//443 forward to target group
resource "aws_alb_listener" "https" {
    load_balancer_arn = aws_lb.alb.arn
    port              = 443
    protocol          = "HTTPS"

    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = "${aws_acm_certificate.my_cert.arn}"

    default_action {
        target_group_arn = aws_lb_target_group.ip-example.id
        type             = "forward"
    }
}