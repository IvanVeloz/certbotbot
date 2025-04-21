#!/bin/ash

echo "${0}"

DOMAINFILE="/root/.secrets/certbot/domains.txt"
SECRETSFILE="/root/.secrets/certbot/linode.ini"
EMAILFILE="/root/.secrets/certbot/email.txt"

# Check environment variables and file validity

if [ ! -f "${DOMAINFILE}" ]; then
    logger -s -p user.error "Domain file ${DOMAINFILE} not found"
    exit 1
fi
if [ ! -s "${DOMAINFILE}" ]; then
    logger -s -p user.error "Domain file ${DOMAINFILE} is empty"
    exit 1
fi

if [ ! -f "${SECRETSFILE}" ]; then
    logger -s -p user.error "Linode credentials file "${SECRETSFILE}" not found"
    exit 1
fi
if [ ! -s "${SECRETSFILE}" ]; then
    logger -s -p user.error "Linode credentials file "${SECRETSFILE}" is empty"
    exit 1
fi
if [ ! -f "${EMAILFILE}" ]; then
    logger -s -p user.error "Email file ${EMAILFILE} not found"
    exit 1
fi
if [ ! -s "${EMAILFILE}" ]; then
    logger -s -p user.error "Email file ${EMAILFILE} is empty"
    exit 1
fi
if [ -f "${EMAILFILE}" ]; then
    EMAIL=$(cat ${EMAILFILE})
else
    EMAIL="certbotbot@localhost"
fi

CERTBOT="certbot"
CERTBOTARGS="certonly \
    --dns-linode \
    --dns-linode-credentials /root/.secrets/certbot/linode.ini \
    --dns-linode-propagation-seconds 120 \
    --non-interactive \
    --agree-tos \
    --email ${EMAIL} \
    "

while IFS= read -r DOMAIN; do
    ${CERTBOT} ${CERTBOTARGS} -d ${DOMAIN}
    if [ $? -ne 0 ]; then
        logger -s -p user.error "Error processing certificate for ${DOMAIN}"
    fi
    logger -s -p user.notice "Certificate for ${DOMAIN} processed successfully"
done < ${DOMAINFILE}
