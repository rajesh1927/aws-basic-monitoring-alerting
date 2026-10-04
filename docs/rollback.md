# Rollback Documentation

## 1. Objective

The rollback procedure explains how to safely remove the monitoring configuration created for this project.

The rollback does not require deleting the EC2 instance or application.

## 2. Resources Created

The project creates or configures:

1. CloudWatch Dashboard
2. CloudWatch Alarm
3. SNS Topic
4. SNS Email Subscription

## 3. Rollback Strategy

The recommended rollback sequence is:

```text
CloudWatch Alarm
       |
       v
SNS Subscription
       |
       v
SNS Topic
       |
       v
CloudWatch Dashboard
```

The EC2 instance should remain running.

## 4. Disable Alarm Actions

Before deleting the alarm, alarm actions can be disabled:

```bash
aws cloudwatch disable-alarm-actions   --alarm-names EC2-High-CPU-Alarm
```

This stops notification actions while retaining the alarm.

## 5. Delete CloudWatch Alarm

If the alarm is no longer required:

```bash
aws cloudwatch delete-alarms   --alarm-names EC2-High-CPU-Alarm
```

Verify:

```bash
aws cloudwatch describe-alarms   --alarm-names EC2-High-CPU-Alarm
```

## 6. Remove SNS Subscription

List subscriptions:

```bash
aws sns list-subscriptions
```

Identify the subscription ARN.

Then:

```bash
aws sns unsubscribe   --subscription-arn <SUBSCRIPTION_ARN>
```

Replace `<SUBSCRIPTION_ARN>` with the actual subscription ARN.

## 7. Delete SNS Topic

Only delete the SNS topic if it was created specifically for this project and is not used by another application.

```bash
aws sns delete-topic   --topic-arn <SNS_TOPIC_ARN>
```

Replace:

```text
<SNS_TOPIC_ARN>
```

with the actual topic ARN.

## 8. Delete CloudWatch Dashboard

If the dashboard is no longer required:

```bash
aws cloudwatch delete-dashboards   --dashboard-names EC2-Basic-Monitoring
```

## 9. Rollback Verification

Check that the alarm has been removed:

```bash
aws cloudwatch describe-alarms   --alarm-names EC2-High-CPU-Alarm
```

Check dashboards:

```bash
aws cloudwatch list-dashboards
```

Check SNS topics:

```bash
aws sns list-topics
```

## 10. Rollback Evidence

Take a screenshot before rollback showing the monitoring configuration.

Save it as:

```text
screenshots/06-before-rollback.png
```

After rollback, take a screenshot showing that the alarm has been deleted or disabled.

Save it as:

```text
screenshots/07-after-rollback.png
```

## 11. Expected Result

### Before Rollback

```text
EC2
 |
CloudWatch Dashboard
 |
CloudWatch Alarm
 |
SNS
 |
Email
```

### After Rollback

```text
EC2
 |
CloudWatch Metrics

Monitoring alert configuration removed.
```

The EC2 instance and application remain unaffected.

## 12. Safety Considerations

Before deleting any AWS resource:

- Verify the resource name.
- Verify the AWS region.
- Confirm that the resource belongs to this project.
- Do not delete shared or production resources.
- Do not delete an SNS topic used by another application.

## 13. Cleanup Script

The repository also includes:

```text
scripts/cleanup.sh
```

The script can be used to remove the CloudWatch alarm and dashboard after verifying the resource names.

SNS resources are intentionally not automatically deleted by the cleanup script because they may be shared.

## 14. Conclusion

The rollback procedure provides a controlled way to remove the monitoring configuration while keeping the EC2 instance and application running.
