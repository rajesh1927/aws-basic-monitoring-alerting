#!/bin/bash

# AWS Basic Monitoring Cleanup Script
#
# Purpose:
#   Remove the CloudWatch monitoring resources created specifically
#   for this project.
#
# IMPORTANT:
#   Review the resource names and AWS region before running.
#   Do NOT use this script against shared or production resources.
#
# This script removes:
#   - CloudWatch alarm
#   - CloudWatch dashboard
#
# SNS resources are intentionally NOT deleted automatically.

set -e

ALARM_NAME="EC2-High-CPU-Alarm"
DASHBOARD_NAME="EC2-Basic-Monitoring"

echo "=========================================="
echo " AWS Monitoring Cleanup"
echo "=========================================="
echo ""
echo "This script will attempt to remove:"
echo ""
echo "CloudWatch Alarm:"
echo "  ${ALARM_NAME}"
echo ""
echo "CloudWatch Dashboard:"
echo "  ${DASHBOARD_NAME}"
echo ""
echo "SNS resources will NOT be deleted automatically."
echo ""

read -r -p "Continue? Type 'yes' to continue: " CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
    echo ""
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Checking AWS identity..."

aws sts get-caller-identity

echo ""
echo "Disabling CloudWatch alarm actions..."

aws cloudwatch disable-alarm-actions     --alarm-names "${ALARM_NAME}"     || true

echo "Deleting CloudWatch alarm..."

aws cloudwatch delete-alarms     --alarm-names "${ALARM_NAME}"     || true

echo "Deleting CloudWatch dashboard..."

aws cloudwatch delete-dashboards     --dashboard-names "${DASHBOARD_NAME}"     || true

echo ""
echo "=========================================="
echo " CloudWatch cleanup completed."
echo "=========================================="
echo ""
echo "IMPORTANT:"
echo "SNS topic and subscription were NOT deleted."
echo ""
echo "If this SNS topic was created only for this project,"
echo "review and remove it manually after verifying that"
echo "it is not used by another application."
echo ""
echo "SNS topics:"
echo "  aws sns list-topics"
echo ""
echo "SNS subscriptions:"
echo "  aws sns list-subscriptions"
echo ""
