#! /bin/bash

notify() {
	osascript -e "display notification \"$2\" with title \"$1\" subtitle \"$3\""
}

echo $(date)

jsondata=$(http https://adventofcode.com/2022/leaderboard/private/view/2685005.json Cookie:"${AOC_COOKIE}")

sqlite3 data.sqlite "CREATE TABLE IF NOT EXISTS USERS (ID INT, NAME TEXT, LAST_STAR_TS INT, LOCAL_SCORE INT, STARS INT);"

progress=false

for data in $(echo "${jsondata}" | jq -cr '.members[]'); do
	id=$(echo ${data} | jq -r '.id')
	name=$(echo ${data} | jq -r '.name')
	if [ "null" = "${name}" ]; then # Anonymous user
		name="Anon #${id}"
	fi
	last_star_ts=$(echo ${data} | jq -r '.last_star_ts')
	local_score=$(echo ${data} | jq -r '.local_score')
	stars=$(echo ${data} | jq -r '.stars')

	stored_last_star_ts=$(sqlite3 data.sqlite "SELECT LAST_STAR_TS FROM USERS WHERE ID=${id}")

	if [ -z "$stored_last_star_ts" ]; then # Not in DB yet
		sqlite3 data.sqlite "INSERT INTO USERS VALUES (${id}, \"${name}\", ${last_star_ts}, ${local_score}, ${stars});"
		notify "${name} has joined the leaderboard!" "" ""
	else
		if [ "$stored_last_star_ts" -ne "$last_star_ts" ]; then # Made progress since last refresh
			progress=true
			sqlite3 data.sqlite "UPDATE USERS SET LAST_STAR_TS=${last_star_ts}, LOCAL_SCORE=${local_score}, STARS=${stars} WHERE ID=${id};"
			notify "${name} now has ${stars} stars!" "and ${local_score} points!" ""
		fi
	fi

	echo "${name}: ${local_score} points, ${stars} stars, last seen $(date -r ${last_star_ts})"
done

if [ "$progress" = true ]; then
	top_score=$(sqlite3 data.sqlite "SELECT MAX(LOCAL_SCORE) FROM USERS")
	top_name=$(sqlite3 data.sqlite "SELECT NAME FROM USERS WHERE LOCAL_SCORE=${top_score} LIMIT 1;")
	top_stars=$(sqlite3 data.sqlite "SELECT STARS FROM USERS WHERE LOCAL_SCORE=${top_score} LIMIT 1;")
	notify "${name} is now in first place!" "with ${top_stars} stars and ${top_score} points!" ""
fi