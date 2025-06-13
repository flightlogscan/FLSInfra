# IAM user for GitHub Actions to access AWS
resource "aws_iam_user" "github_actions" {
  name = "github-actions"

  tags = {
    Purpose = "CI/CD GitHub Actions"
  }
}

resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name

  depends_on = [aws_iam_user.github_actions]
}

resource "aws_iam_user_policy" "github_actions_policy" {
  name = "github-actions-policy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        Resource = data.aws_route53_zone.main.arn
      }
    ]
  })
}

# Route 53 zone reference (replace with your actual domain name)
data "aws_route53_zone" "main" {
  name         = "flightlogscan.com."
  private_zone = false
}

resource "aws_route53_record" "prod_api" {
  zone_id         = data.aws_route53_zone.main.zone_id
  name            = "api.flightlogscan.com"
  type            = "A"
  ttl             = 300
  allow_overwrite = true
  records         = var.hetzner_server_ip_list

  lifecycle {
    create_before_destroy = true
  }
}