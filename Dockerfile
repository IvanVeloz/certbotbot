FROM certbot/dns-linode:latest AS base

COPY --chmod=+x ./crondaily.sh /etc/periodic/daily/certbotbot
COPY --chmod=+x ./certbotbot.sh /usr/local/bin/certbotbot
COPY --chmod=+x ./entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/sbin/crond", "-f", "-S", "-l1"]
