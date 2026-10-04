#!/bin/bash

# AWS EC2 CPU Stress Test
# Purpose: Generate temporary CPU load to test the CloudWatch alarm.
#
# Usage:
#   chmod +x stress-test.sh
#   ./stress-test.sh
#
# The script runs for 10 minutes by default and then stops automatically.

set -e

DURATION=600

echo "=========================================="
echo " AWS EC2 CPU Stress Test"
echo "=========================================="
echo "Duration: ${DURATION} seconds"
echo ""

if command -v stress-ng >/dev/null 2>&1; then

    CPU_COUNT=$(nproc)

    echo "stress-ng found."
    echo "CPU cores detected: ${CPU_COUNT}"
    echo "Starting CPU stress..."
    echo ""

    stress-ng         --cpu "${CPU_COUNT}"         --timeout "${DURATION}s"

elif command -v stress >/dev/null 2>&1; then

    CPU_COUNT=$(nproc)

    echo "stress found."
    echo "CPU cores detected: ${CPU_COUNT}"
    echo "Starting CPU stress..."
    echo ""

    stress         --cpu "${CPU_COUNT}"         --timeout "${DURATION}"

else

    echo "ERROR: No CPU stress tool was found."
    echo ""
    echo "Install stress-ng using one of the following:"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt update"
    echo "  sudo apt install -y stress-ng"
    echo ""
    echo "Amazon Linux/RHEL:"
    echo "  sudo dnf install -y stress-ng"
    echo ""
    echo "Older Amazon Linux:"
    echo "  sudo yum install -y stress-ng"
    echo ""

    exit 1
fi

echo ""
echo "=========================================="
echo " CPU stress test completed."
echo "=========================================="
echo "Check the CloudWatch alarm:"
echo "EC2-High-CPU-Alarm"
echo ""
echo "Expected:"
echo "OK -> ALARM -> OK"
echo "=========================================="
