provider "aws" {
    access_key = "Your access kry"
    secret_key = "Your secret key"
    region = "ap-southeast-1"
}

resource "aws_elb" "asgn2_load" {
	name = "asgn2-load"
	availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
	security_groups = ["sg-65d67b03"]

	listener {
		lb_protocol = "http"
		lb_port = 80
		instance_protocol = "http"
		instance_port = 80
	}

	health_check {
		target = "HTTP:80/login.php"
		timeout = 5
		interval = 30
		unhealthy_threshold = 3
		healthy_threshold = 5
	}
}

resource "aws_launch_configuration" "asgn2_conf" {
    name = "asgn2-launch"
    image_id = "ami-57460e34"
    instance_type = "t2.micro"
    security_groups = ["sg-65d67b03"]
    key_name = "asgn1-key"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asgn2_scaling" {
	launch_configuration = "${aws_launch_configuration.asgn2_conf.name}"
	name = "asgn2-scaling"
	availability_zones = ["ap-southeast-1b"]
	min_size = 2
	max_size = 10
	enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
	metrics_granularity = "1Minute"
	load_balancers = ["${aws_elb.asgn2_load.id}"]
	health_check_grace_period = 300
	health_check_type = "ELB"
}

resource "aws_autoscaling_policy" "asgn2_cpu_up" {
	policy_type = "StepScaling"
    name = "cpu_up"
	adjustment_type = "ChangeInCapacity"
    metric_aggregation_type = "Average"
	estimated_instance_warmup = 60
    autoscaling_group_name = "${aws_autoscaling_group.asgn2_scaling.name}"

    step_adjustment {
        metric_interval_lower_bound = 1.0
        scaling_adjustment = 1
    }
}

resource "aws_cloudwatch_metric_alarm" "asgn2_cpu_alarm_up" {
    alarm_name = "cpu-alarm-up"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "60"
    statistic = "Average"
    threshold = "70"

    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.asgn2_scaling.name}"
    }

    alarm_description = "asgn2 average cpu utilization >= 70%"
    alarm_actions = ["${aws_autoscaling_policy.asgn2_cpu_up.arn}"]
}

resource "aws_autoscaling_policy" "asgn2_cpu_down" {
	policy_type = "StepScaling"
    name = "cpu_down"
	adjustment_type = "ChangeInCapacity"
    metric_aggregation_type = "Average"
	estimated_instance_warmup = 60
    autoscaling_group_name = "${aws_autoscaling_group.asgn2_scaling.name}"

    step_adjustment {
        metric_interval_lower_bound = 1.0
        scaling_adjustment = -1
    }
}

resource "aws_cloudwatch_metric_alarm" "asgn2_cpu_alarm_down" {
    alarm_name = "cpu-alarm-down"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "60"
    statistic = "Average"
    threshold = "20"

    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.asgn2_scaling.name}"
    }

    alarm_description = "asgn2 average cpu utilization <= 20%"
    alarm_actions = ["${aws_autoscaling_policy.asgn2_cpu_up.arn}"]
}

