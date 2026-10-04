# Architecture Documentation

## 1. Overview

This project implements a basic AWS infrastructure monitoring and alerting solution for an Amazon EC2 instance.

Amazon CloudWatch is used to collect and visualize EC2 metrics. A CloudWatch alarm monitors CPU utilization and Amazon SNS sends an email notification when the configured threshold is crossed.

## 2. Architecture Diagram

```text
                    AWS Cloud
                       |
                       v
                +--------------+
                |  EC2 Server  |
                +------+-------+
                       |
                       | EC2 Metrics
                       v
                +--------------+
                |  CloudWatch  |
                |    Metrics   |
                +------+-------+
                       |
              +--------+--------+
              |                 |
              v                 v
       +-------------+    +-------------+
       | CloudWatch  |    | CloudWatch  |
       |  Dashboard  |    |    Alarm    |
       +-------------+    +------+------+
                                 |
                            CPU >= 70%
                                 |
                                 v
                          +--------------+
                          |     SNS      |
                          |    Topic     |
                          +------+-------+
                                 |
                                 v
                          Email Notification
```

## 3. AWS Components

### Amazon EC2

The EC2 instance is the deployed resource being monitored.

### Amazon CloudWatch

CloudWatch collects EC2 metrics and provides dashboards and alarms.

The following metrics are monitored:

- CPUUtilization
- NetworkIn

### CloudWatch Dashboard

The dashboard provides a visual view of the monitored EC2 metrics.

### CloudWatch Alarm

The alarm monitors CPU utilization and enters the ALARM state when CPU utilization is greater than or equal to 70% for the configured evaluation period.

### Amazon SNS

SNS sends an email notification when the CloudWatch alarm enters the ALARM state.

## 4. Data Flow

```text
EC2 Instance
     |
     | Metrics
     v
CloudWatch
     |
     +----> Dashboard
     |
     +----> Alarm
              |
              | Threshold crossed
              v
             SNS
              |
              v
        Email Notification
```

## 5. Normal and Alert Conditions

### Normal Condition

```text
CPU < 70%
   |
   v
CloudWatch Alarm = OK
```

### Alert Condition

```text
CPU >= 70%
   |
   v
CloudWatch Alarm = ALARM
   |
   v
SNS Notification
   |
   v
Email Alert
```

## 6. Security Considerations

- AWS credentials must not be stored in GitHub.
- Use IAM roles or securely configured AWS CLI credentials.
- Do not publish sensitive account information.
- Replace account-specific ARNs with placeholders in public configuration files.
- Do not include passwords, access keys, or secret tokens in screenshots.

## 7. Cost Considerations

The project is designed to use simple AWS resources and avoid unnecessary infrastructure.

The project does not require:

- NAT Gateway
- Application Load Balancer
- RDS
- Multiple EC2 instances
- Other unnecessary paid infrastructure

AWS pricing and free-tier eligibility should always be checked before deployment.

## 8. Conclusion

The architecture demonstrates a simple observability workflow:

**EC2 → CloudWatch → CloudWatch Alarm → SNS → Email**

This provides a basic mechanism for detecting infrastructure problems before users report them.
