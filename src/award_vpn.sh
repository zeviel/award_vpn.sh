#!/bin/bash

api="https://api.award-vpn.com/v2"
user_agent="okhttp/3.12.1"
device_id=$(cat /dev/urandom | tr -dc "a-z0-9" | fold -w 24 | head -n 1)

function get_token() {
	response=$(curl --request POST \
		--url "$api/token" \
		--user-agent "$user_agent" \
		--header "content-type: application/x-www-form-urlencoded" \
		--header "authorization: Basic YXBpLXVzZXI6Li5Bc2RmQDEyMzRqa2w7" \
		--data "device=$device_id")
	if [ -n $(jq -r ".token" <<< "$response") ]; then
		token=$(jq -r ".token" <<< "$response")
	fi
	echo $response
}

function get_notifications() {
	curl --request GET \
		--url "$api/app/notifications" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function get_servers() {
	curl --request GET \
		--url "$api/servers" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}
