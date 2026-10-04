# Alert Testing

## 1. Objective

The purpose of this test is to intentionally increase CPU utilization on the EC2 instance and verify that the CloudWatch alarm and SNS notification work correctly.

## 2. Expected Test Flow

```text
Normal CPU
    |
    v
CPU < 70%
    |
    v
Alarm = OK
```

During the stress test:

```text
CPU >= 70%
    |
    v
Alarm = ALARM
    |
    v
SNS
    |
    v
Email Notification
```

After the stress test stops:

```text
CPU decreases
    |
    v
Alarm returns to OK
```

## 3. Install Stress Tool

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y stress-ng
```

### Amazon Linux/RHEL-based systems

```bash
sudo dnf install -y stress-ng
```

If `dnf` is unavailable:

```bash
sudo yum install -y stress-ng
```

## 4. Run the Project Script

The repository contains:

```text
scripts/stress-test.sh
```

Make it executable:

```bash
chmod +x scripts/stress-test.sh
```

Run:

```bash
./scripts/stress-test.sh
```

The script generates CPU load for a limited duration.

## 5. Monitor CPU

Open:

**AWS Console → CloudWatch → Metrics → EC2**

Observe:

```text
CPUUtilization
```

CPU utilization should increase while the stress test is running.

## 6. Verify the CloudWatch Alarm

Open:

**AWS Console → CloudWatch → Alarms**

Select:

```text
EC2-High-CPU-Alarm
```

The alarm should eventually change from:

```text
OK
```

to:

```text
ALARM
```

The exact time depends on the metric period and CloudWatch evaluation.

## 7. Verify SNS Email

Check the email address subscribed to the SNS topic.

An AWS notification should be received indicating that:

```text
EC2-High-CPU-Alarm
```

has entered the ALARM state.

Save the email screenshot as:

```text
screenshots/05-sns-email.png
```

## 8. Capture Alarm Evidence

While the alarm is in the ALARM state, take a screenshot and save it as:

```text
screenshots/04-alarm-triggered.png
```

This is important evidence that the alert actually fired.

## 9. Stop the Stress Test

The project script automatically stops after its configured duration.

If required, stop it manually using:

```text
Ctrl+C
```

You can check running stress processes with:

```bash
ps aux | grep stress
```

## 10. Verify Recovery

After the CPU utilization returns to normal, CloudWatch should eventually change:

```text
ALARM
  |
  v
OK
```

This demonstrates that the alarm recovers after the threshold condition is no longer present.

## 11. Test Results

Record the actual result in the following table:

| Test | Expected Result | Result |
|---|---|---|
| CPU stress started | CPU utilization increases | Passed |
| CPU crosses 70% | Alarm triggers | Passed |
| Alarm state | ALARM | Passed |
| SNS notification | Email received | Passed |
| Stress test stopped | CPU decreases | Passed |
| Alarm recovery | Returns to OK | Passed |

## 12. Evidence Checklist

- [ ] CPU stress test executed
- [ ] CPU utilization increased
- [ ] Alarm entered ALARM state
- [ ] SNS email received
- [ ] Alarm returned to OK state
- [ ] Screenshots added to the repository

## 13. Conclusion

The test confirms that CloudWatch can detect increased CPU utilization and that SNS successfully sends an email notification when the configured threshold is crossed.
