provider "aws" {
    access_key = "AKIAJXELQNX3DM5UEMVQ"
    secret_key = "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"
    region = "ap-southeast-1"
}

resource "aws_launch_configuration" "as_conf" {
    name_prefix = "terraform-lc"
    image_id = "ami-8abbf2e9"
    instance_type = "t2.micro"
    security_groups = ["sg-016e0367"]
    key_name = "Ken's Mac Key"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "auto_scaling" {
    name = "terraform-asg"
    launch_configuration = "${aws_launch_configuration.as_conf.name}"
    min_size = 2
    max_size = 10
    availability_zones = ["ap-southeast-1b", "ap-southeast-1a"]
    target_group_arns =["arn:aws:elasticloadbalancing:ap-southeast-1:727390511971:targetgroup/bitcoin-tg/3cbb9e5695475860"]
}

resource "aws_autoscaling_policy" "cpu_load_policy_up" {
    name = "scale-up"
    policy_type = "StepScaling"
    estimated_instance_warmup = 60
    metric_aggregation_type = "Average"
    adjustment_type = "ChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.auto_scaling.name}"

    step_adjustment {
        metric_interval_lower_bound = 1.0
        scaling_adjustment = 1
    }
}

resource "aws_autoscaling_policy" "cpu_load_policy_down" {
    name = "scale-down"
    policy_type = "StepScaling"
    estimated_instance_warmup = 60
    metric_aggregation_type = "Average"
    adjustment_type = "ChangeInCapacity"
    autoscaling_group_name = "${aws_autoscaling_group.auto_scaling.name}"

    step_adjustment {
        metric_interval_lower_bound = 1.0
        scaling_adjustment = -1
    }
}

resource "aws_cloudwatch_metric_alarm" "cpu_load_alarm_up" {
    alarm_name = "alarm-up"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "60"
    statistic = "Average"
    threshold = "70"

    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.auto_scaling.name}"
    }

    alarm_description = "This metric monitors ec2 cpu utilization >= 70%"
    alarm_actions = ["${aws_autoscaling_policy.cpu_load_policy_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_load_alarm_down" {
    alarm_name = "alarm-down"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "60"
    statistic = "Average"
    threshold = "20"

    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.auto_scaling.name}"
    }

    alarm_description = "This metric monitors ec2 cpu utilization <= 20%"
    alarm_actions = ["${aws_autoscaling_policy.cpu_load_policy_down.arn}"]
}