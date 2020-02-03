#!/bin/bash
# set -x
set -e

curl -s -G 'https://recurse.zulipchat.com/api/v1/messages' \
    -u cdosborn@email.arizona.edu:typKXxzqYik20zhdHSmFY85xH7wbTmnw \
    --data-urlencode 'narrow=[{"operator":"stream", "operand":"blogging"}]' \
    --data-urlencode 'num_before=35000' \
    --data-urlencode 'num_after=35000' \
    --data-urlencode 'use_first_unread_anchor=true' \
    --data-urlencode client_gravatar=false \
    --data-urlencode apply_markdown=false | \
    jq -r '.messages[] | [.sender_id, .timestamp, .subject] | map(tostring) | join(",")' | \

python <(
cat <<PY
import sys
topics = {}
for line in sys.stdin.read().splitlines():
    (sender_id, timestamp, topic) = line.split(",", 2)
    topics[topic] = topics.get(topic, { "sender_set": set(), "timestamp": None })
    if sender_id == "100053" or sender_id == "1921":
        topics[topic]["timestamp"] = timestamp
    else:
        topics[topic]["sender_set"].add(sender_id)
for topic in topics.keys():
    num_unique_senders = len(topics[topic]["sender_set"])
    timestamp = topics[topic]["timestamp"]
    print timestamp, num_unique_senders, topic
PY
) | \

while read timestamp num_senders topic; do
    if [ $timestamp = "None" ]; then
        continue;
    fi
    # hours_since_sunday=$(echo $(date +"%k" --date=@$timestamp));
    hours_since_sunday=$(TZ=MST date +"(%w * 24) + %k" --date=@$timestamp | bc);
    if [ $hours_since_sunday -eq 27 -o $hours_since_sunday -eq 28 ]; then
        echo "$num_senders $topic $timestamp";
    fi;
done
