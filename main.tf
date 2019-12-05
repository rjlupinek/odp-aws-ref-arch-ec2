provider "aws" {
  region     = "${var.aws_region}"
}

data "aws_ami" "ec2-ami-private" {
  filter {
    name   = "state"
    values = ["available"]
  }
  owners  = ["self"]
  filter {
    name   = "tag:Name"
    values = "${var.tag_for_ami_name_private}"
  }

  most_recent = true
}

data "aws_ami" "ec2-ami-jump" {
  filter {
    name   = "state"
    values = ["available"]
  }
  owners  = ["self"]
  filter {
    name   = "tag:Name"
    values = "${var.tag_for_ami_name_jump}"
  }

  most_recent = true
}

resource "aws_security_group" "web_server_sg" {
  name = "web_server_sg"
  vpc_id = "${var.vpc_id}"

  # SSH access from the VPC
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jump_host_sg" {
  name = "jump_host_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "${var.jump_host_cidr_list}"
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}


resource "aws_instance" "jump_server" {
  ami           = "${data.aws_ami.ec2-ami-jump.id}" #"${var.jump_server_ami}"
  associate_public_ip_address = "true"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.jump_server_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.jump_host_sg.id}"]
  key_name = "${var.aws_key_name}"

  tags = {
    Name = "${var.jump_server_name}"
  }
}


resource "aws_instance" "instance_1" {
  ami           = "${data.aws_ami.ec2-ami-private.id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.instance_subnet_1_id}"
  vpc_security_group_ids = ["${aws_security_group.web_server_sg.id}"]
  key_name = "${var.aws_key_name}"

  tags = {
    Name = "${var.instance_1_name}"
  }
}

resource "aws_instance" "instance_2" {
  ami           = "${data.aws_ami.ec2-ami-private.id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.instance_subnet_2_id}"
  vpc_security_group_ids = ["${aws_security_group.web_server_sg.id}"]
  key_name = "${var.aws_key_name}"

  tags = {
    Name = "${var.instance_2_name}"
  }
}

resource "aws_lb" "alb" {
  name               = "odp-ra-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets            = ["${var.lb_subnet_1_id}", "${var.lb_subnet_2_id}"] # direct to public subnets 

  # access_logs {
  #   bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_security_group" "lb_sg" {
  name = "lb_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol    = "-1"
    cidr_blocks = "${var.lb_cidr_block_list}"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.instance_subnet_1_cidr}", "${var.instance_subnet_2_cidr}"]
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "alb_attatchment_1" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id        = "${aws_instance.instance_1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "alb_attatchment_2" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id        = "${aws_instance.instance_2.id}"
  port             = 80
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }
}