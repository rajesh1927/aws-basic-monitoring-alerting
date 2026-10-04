# Monitoring Setup

## 1. Objective

The objective is to monitor an AWS EC2 instance using Amazon CloudWatch and create a dashboard containing at least two metrics.

A CPU utilization alarm is also configured to send an email notification through Amazon SNS when the threshold is crossed.

## 2. Prerequisites

Required:

- AWS account
- Running EC2 instance
- AWS Console access
- Email address for SNS notifications
- AWS CLI (optional)

## 3. Select the EC2 Instance

Open:

**AWS Console → EC2 → Instances**

Select the running EC2 instance.

Record:

```text
Instance ID:
Instance Name:
AWS Region:
Instance Type:
Operating System:
```

Do not publish sensitive information in the repository.

## 4. Open CloudWatch Metrics

Go to:

**AWS Console → CloudWatch → Metrics → EC2**

Select:

```text
Per-Instance Metrics
```

Select the target EC2 instance.

## 5. Configure CPUUtilization

Select:

```text
CPUUtilization
```

Recommended settings:

```text
Statistic: Average
Period: 5 minutes
```

CPUUtilization shows the percentage of CPU capacity being used by the EC2 instance.

## 6. Configure NetworkIn

Select:

```text
NetworkIn
```

Recommended settings:

```text
Statistic: Average
Period: 5 minutes
```

NetworkIn shows the amount of network traffic received by the EC2 instance.

## 7. Create CloudWatch Dashboard

Go to:

**CloudWatch → Dashboards → Create dashboard**

Use the dashboard name:

```text
EC2-Basic-Monitoring
```

Add these widgets:

1. EC2 CPU Utilization
2. EC2 Network Traffic

Save the dashboard.

## 8. Create SNS Topic

Go to:

**AWS Console → SNS → Topics → Create topic**

Select:

```text
Type: Standard
Name: ec2-monitoring-alerts
```

Create the topic.

## 9. Create SNS Email Subscription

Open the SNS topic and select:

**Create subscription**

Configure:

```text
Protocol: Email
Endpoint: <YOUR_EMAIL_ADDRESS>
```

AWS will send a confirmation email.

Open the email and click **Confirm subscription**.

Verify that the subscription status is:

```text
Confirmed
```

## 10. Create CloudWatch Alarm

Go to:

**CloudWatch → Alarms → Create alarm**

Select the EC2 metric:

```text
EC2 → Per-Instance Metrics → CPUUtilization
```

Select the target EC2 instance.

## 11. Alarm Configuration

Configure:

```text
Statistic: Average
Period: 5 minutes
Threshold type: Static
Condition: Greater than or equal to 70%
Evaluation: 1 out of 1 datapoint
```

Use the alarm name:

```text
EC2-High-CPU-Alarm
```

## 12. Configure Alarm Notification

Under alarm actions:

```text
Alarm state: In alarm
SNS topic: ec2-monitoring-alerts
```

Create the alarm.

## 13. Verify the Alarm

Immediately after creation, the alarm should normally show:

```text
OK
```

When CPU utilization crosses the configured threshold, it should change to:

```text
ALARM
```

## 14. CLI Verification

If AWS CLI is configured:

```bash
aws cloudwatch describe-alarms   --alarm-names EC2-High-CPU-Alarm
```

Check SNS topics:

```bash
aws sns list-topics
```

Check SNS subscriptions:

```bash
aws sns list-subscriptions
```

## 15. Evidence

Take the following screenshots:

```text
screenshots/01-ec2-instance.png
screenshots/02-cloudwatch-dashboard.png
screenshots/03-alarm-configuration.png
```

These demonstrate that the EC2 instance, dashboard, and alarm have been configured.

## 16. Expected Result

The completed monitoring setup should look like:

```text
EC2
 |
 +-- CPUUtilization
 |
 +-- NetworkIn
 |
 v
CloudWatch Dashboard

CPU >= 70%
 |
 v
CloudWatch Alarm
 |
 v
SNS
 |
 v
Email Notification
```
