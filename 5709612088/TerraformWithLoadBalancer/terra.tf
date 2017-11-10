provider "aws" {
	region = "YOUR_REGION"
	access_key = "YOUR_ACCESS_KEY"
  	secret_key = "YOUR_SECRET_KEY"
}

resource "aws_launch_configuration" "simpleWebApp" {
	image_id = "AMI_ID"
	instance_type = "INSTANCE_TYPE"
	security_groups = ["YOUR_SECURITY_GROUP"]
	key_name = "${aws_key_pair.keypair.key_name}"

	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_elb" "load_balancer" {
	name = "loadbalancer"
	availability_zones = ["YOUR_AVAILABILITY_ZONE"]
	security_groups = ["YOUR_SECURITY_GROUP"]

	listener {
		instance_port = 80
		instance_protocol = "http"
		lb_port = 80
		lb_protocol = "http"
	}

	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		target = "HTTP:80/"
		interval = 30
	}

	tags {
		Name = "terraform-elb"
	}
}

resource "aws_key_pair" "keypair" {
	key_name = "keypair"
	public_key = "${file("keypair.pub")}"
}

resource "aws_autoscaling_group" "scalegroup" {
	launch_configuration = "${aws_launch_configuration.simpleWebApp.name}"
	availability_zones = ["YOUR_AVAILABILITY_ZONE"]
	min_size = 2
	max_size = 10
	enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
	metrics_granularity = "1Minute"
	load_balancers = ["${aws_elb.load_balancer.id}"]
	health_check_type = "ELB"
	
	tag {
		key = "Name"
		value = "terraform-example"
		propagate_at_launch = true
	}
}

resource "aws_autoscaling_policy" "autopolicy" {
	name = "terraform-autopolicy"
	adjustment_type = "ChangeInCapacity"
	policy_type = "StepScaling"
	estimated_instance_warmup = "60"
	metric_aggregation_type = "Average"

	step_adjustment {
		scaling_adjustment = 1
		metric_interval_lower_bound = 0.0
	}

	autoscaling_group_name = "${aws_autoscaling_group.scalegroup.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
	alarm_name = "terraform-alarm"
	comparison_operator = "GreaterThanOrEqualToThreshold"
	evaluation_periods = "1"
	metric_name = "CPUUtilization"
	namespace = "AWS/EC2"
	period = "60"
	statistic = "Average"
	threshold = "70"

	dimensions {
		AutoScalingGroupName = "${aws_autoscaling_group.scalegroup.name}"
	}

	alarm_description = "CPU Utilization is overhead"
	alarm_actions = ["${aws_autoscaling_policy.autopolicy.arn}"]
}

resource "aws_autoscaling_policy" "autopolicy-down" {
	name = "terraform-autopolicy-down"
	scaling_adjustment = -1
	adjustment_type = "ChangeInCapacity"
	cooldown = 60
	autoscaling_group_name = "${aws_autoscaling_group.scalegroup.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
	alarm_name = "terraform-alarm-down"
	comparison_operator = "LessThanOrEqualToThreshold"
	evaluation_periods = "1"
	metric_name = "CPUUtilization"
	namespace = "AWS/EC2"
	period = "60"
	statistic = "Average"
	threshold = "20"

	dimensions {
		AutoScalingGroupName = "${aws_autoscaling_group.scalegroup.name}"
	}

	alarm_description = "CPU Utilization is Lower than 20%"
	alarm_actions = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
}