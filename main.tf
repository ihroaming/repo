# Provider Section
##################
provider "aws" { 
	region = "us-east-1"
}

# Variable Section
##################
variable "server_port" {
	description = "The port the server will use for HTTP requests"
	default = 8080
}

#IAC Section
############
resource "aws_instance" "example" {
	ami = "ami-40d28157"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.instance.id}"]
	user_data = <<-EOF
		    #!/bin/bash
		    echo "Hello, World" > index.html 
		    nohup busybox httpd -f -p "${var.server_port}" &
		    EOF
	tags  = {
		Name = "terraform-example"
	}
}
resource "aws_security_group" "instance" {
	name = "terraform-example-instance"
	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# Output Section
################
output "public_ip" {
	value = "${aws_instance.example.public_ip}"
}

