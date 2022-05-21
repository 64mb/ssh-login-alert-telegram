#!/usr/bin/env bash
 
# import credentials form config file
. /opt/slat/credentials.config
for i in "${TG_CHAT_ID[@]}"
do
URL="https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage"
DATE="$(date "+%d.%m.%Y %H:%M")"

if [ -n "$SSH_CLIENT" ]; then
	CLIENT_IP=$(echo $SSH_CLIENT | awk '{print $1}')

	SRV_HOSTNAME=$(hostname -f)
	SRV_IP=$(hostname -I | awk '{print $1}')
	SRV_DOMAIN=$(curl -s 'https://reverseip.domaintools.com/search/?q='$SRV_IP \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36' \
  --compressed | grep -ioP '<td class="ip-domain-col"><span title=".*?">\K.*?<' | sed 's/<//g' | head -n1)

	IPINFO="https://ipinfo.io/${CLIENT_IP}"

	TEXT="ssh connection 
	from: *${CLIENT_IP}*
	user: *${USER}*
	server: *${SRV_DOMAIN}* (*${SRV_IP}*)
	hostname: *${SRV_HOSTNAME}*
	date: ${DATE}
	ip info: [${IPINFO}](${IPINFO})"

	curl -s -d "chat_id=$i&text=${TEXT}&disable_web_page_preview=true&parse_mode=markdown" $URL > /dev/null
fi
done
