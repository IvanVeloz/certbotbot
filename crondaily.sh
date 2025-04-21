#!/bin/ash

echo "Triggered certbotbot cron job, starting..."
# Sleep for a random time between 0 and 14400 seconds (4 hours)
SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(14400+1))}')
sleep $SLEEPTIME
# Run the renewal script
echo "Calling renewcert at $(date)"
/usr/local/bin/renewcert
