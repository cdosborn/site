#!/bin/bash
# set -x
set -e

if [ ! -e /tmp/$0-messages ]; then
curl -s -G 'https://recurse.zulipchat.com/api/v1/messages' \
    -u cdosborn@email.arizona.edu:typKXxzqYik20zhdHSmFY85xH7wbTmnw \
    --data-urlencode 'narrow=[{"operator":"stream", "operand":"blogging"}]' \
    --data-urlencode 'num_before=35000' \
    --data-urlencode 'num_after=35000' \
    --data-urlencode 'use_first_unread_anchor=true' \
    --data-urlencode client_gravatar=false \
    --data-urlencode apply_markdown=false | \
    jq -r '.messages[] | [.sender_id, .timestamp, .subject] | map(tostring) | join(",")' > /tmp/$0-messages
fi

python < /tmp/$0-messages <(
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
    if num_unique_senders > 8:
        continue
    print timestamp, num_unique_senders
PY
) | \

while read timestamp num_senders; do
    if [ $timestamp = "None" ]; then
        continue;
    fi
    # hours_since_sunday=$(echo $(date +"%k" --date=@$timestamp));
    hours_since_sunday=$(TZ=MST date +"(%w * 24) + %k" --date=@$timestamp | bc);
    echo "$hours_since_sunday $num_senders";
done |

awk '
{
    cum_unique_senders[$1] += $2
    samples_per_timestamp[$1] += 1
}

END {
    for (timestamp in samples_per_timestamp) {
        print timestamp " " cum_unique_senders[timestamp] / samples_per_timestamp[timestamp];
    }
}

'

# # if [ ! -e /tmp/blogging-stream-messages.json ]; then
# # #     curl -s -G 'https://recurse.zulipchat.com/api/v1/messages' \
# # #         -u cdosborn@email.arizona.edu:typKXxzqYik20zhdHSmFY85xH7wbTmnw \
# # #         -d 'narrow=[{"operator":"stream", "operand":"blogging"}]' \
# # #         -d 'num_before=1000' \
# # #         -d 'num_after=1000' \
# # #         -d 'use_first_unread_anchor=true' \
# # #         -d client_gravatar=false \
# # #         -d apply_markdown=false > /tmp/blogging-stream-messages.json
# # # fi

# # # jq -r '.messages[] | ( .sender_id | tostring ) + " " + ( .timestamp | tostring ) ' < /tmp/blogging-stream-messages.json | \
# # # awk '{

# # # }
# # # '
