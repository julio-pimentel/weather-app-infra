resource "aws_alb" "alb_01" {
  name = var.alb_name
  internal = false
  load_balancer_type = "application"
  security_groups = [var.alb_sg_id]
  subnets = [var.pub_cidr_id_1, var.pub_cidr_id_2, var.pub_cidr_id_3]

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

resource "aws_alb_target_group" "alb_tg" {
  name = var.alb_tg_name
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  tags = {
    Name = var.alb_tg_name
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb_01.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
}