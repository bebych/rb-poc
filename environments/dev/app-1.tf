variable "prefix" { type = string }

resource "aws_security_group" "lambda_sg" {
  name        = "${var.prefix}-app-1-sg"
  description = "Security group for app1"
  vpc_id      = data.terraform_remote_state.shared.outputs.vpc.id
}

module "app-1" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.prefix}-app-1"
  description   = "Lambda for app1"
  handler       = "main.lambda_handler"
  runtime       = "python3.9"

  source_path = "../../src/app-1/"

  vpc_subnet_ids         = data.terraform_remote_state.shared.outputs.priv_subnets
  vpc_security_group_ids = [aws_security_group.lambda_sg.id]
  attach_network_policy = true
}