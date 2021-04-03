provider "aws" {
  version = "~> 2.43"
	region     = var.region
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
}


data "aws_ami" "my_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-${var.project_name}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.aws_account_num}"]
}

locals {
  timestamp = "${timestamp()}"
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"
}

resource "aws_launch_template" "my_lt" {
  name                    = "terraform-lt-${local.timestamp_sanitized}"
  image_id                = "${data.aws_ami.my_ami.id}"
  instance_type           = "${var.new_instance_type}"
  vpc_security_group_ids  = ["${var.security_group_ids}"]
  key_name                = "${var.key_pair_name}"

  # extra volumne if needed
  # block_device_mappings {
  #   device_name = "/dev/xvdz"

  #   ebs {
  #     volume_size = "8"
  #     volume_type = "gp2"
  #   }
  # }

  tags = {
    Env = "${var.env}"
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name    = "volume-${var.project_name}"
      Env     = "${var.env}"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  name                 = "terraform-asg-${aws_launch_template.my_lt.name}"
  health_check_type    = "ELB"
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier  = ["${var.subnet_id}", "${var.subnet_id2}"]

  launch_template {
    id      = "${aws_launch_template.my_lt.id}"
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "ENV"
      value               = var.env
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "asg-${var.project_name}"
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_attachment" "aws_asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.bar.id}"
  alb_target_group_arn   = "${aws_lb_target_group.my_tg.arn}"
}

resource "aws_lb" "my_lb" {
  name                       = "terraform-lb-${var.project_name}-${var.env}"
  internal                   = true
  load_balancer_type         = "application"
  subnets                    = ["${var.subnet_id}", "${var.subnet_id2}"]
  security_groups            = ["${var.security_group_ids}"]

  tags = {
    Service = "yoyo"
    Team    = "snpui"
    Env     = "${var.env}"
    Group   = "hotyhuang"
  }
}


resource "aws_lb_target_group" "my_tg" {
  name     = "terraform-tg-${var.project_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags = {
    Name    = "tg-${var.project_name}"
    Env     = "${var.env}"
  }
}

resource "aws_lb_listener" "hoty_lis" {
  load_balancer_arn = "${aws_lb.my_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  
  default_action {
    target_group_arn = "${aws_lb_target_group.my_tg.arn}"
    type             = "forward"
  }
}

resource "aws_route53_record" "aws_lb_r53" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.r53_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.my_lb.dns_name}"
    zone_id                = "${aws_lb.my_lb.zone_id}"
    evaluate_target_health = true
  }
}
