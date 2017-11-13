provider "aws" {
	region = "ap-southeast-1"
	access_key = "AKIAIGQKWMK67Z7M2QMQ"
  	secret_key = "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"
}

resource "aws_launch_configuration" "OS2-AMI" {
	image_id = "ami-718dc312"
	instance_type = "t2.micro"
	security_groups = ["sg-ecb3ca8a"]
	key_name = "OS2-key"

	lifecycle {
		create_before_destroy = true
	}
}


resource "aws_autoscaling_group" "auto-scale" {
	launch_configuration = "${aws_launch_configuration.OS2-AMI.name}"
	availability_zones = ["ap-southeast-1b", "ap-southeast-1a"]
	min_size = 2
	max_size = 10
	enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
	metrics_granularity = "1Minute"
	target_group_arns = ["arn:aws:elasticloadbalancing:ap-southeast-1:520992034667:targetgroup/OS-targetGroup/e1783e37535dfabb"] 
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

	autoscaling_group_name = "${aws_autoscaling_group.auto-scale.name}"
}

resource "aws_cloudwatch_metric_alarm" "alarm-up" {
	alarm_name = "terraform-alarm"
	comparison_operator = "GreaterThanOrEqualToThreshold"
	evaluation_periods = "1"
	metric_name = "CPUUtilization"
	namespace = "AWS/EC2"
	period = "60"
	statistic = "Average"
	threshold = "70"

	dimensions {
		AutoScalingGroupName = "${aws_autoscaling_group.auto-scale.name}"
	}
	alarm_actions = ["${aws_autoscaling_policy.autopolicy.arn}"]
}

resource "aws_autoscaling_policy" "autopolicy2" {
	name = "terraform-autopolicy-down"
	scaling_adjustment = -1
	adjustment_type = "ChangeInCapacity"
	cooldown = 60
	autoscaling_group_name = "${aws_autoscaling_group.auto-scale.name}"
}

resource "aws_cloudwatch_metric_alarm" "alarm-down" {
	alarm_name = "terraform-alarm-down"
	comparison_operator = "LessThanOrEqualToThreshold"
	evaluation_periods = "1"
	metric_name = "CPUUtilization"
	namespace = "AWS/EC2"
	period = "60"
	statistic = "Average"
	threshold = "20"

	dimensions {
		AutoScalingGroupName = "${aws_autoscaling_group.auto-scale.name}"
	}
	alarm_actions = ["${aws_autoscaling_policy.autopolicy2.arn}"]
}