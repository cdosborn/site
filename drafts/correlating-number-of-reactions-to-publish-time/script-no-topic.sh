#!/bin/bash
# set -x
set -e

time curl -s -G 'https://recurse.zulipchat.com/api/v1/messages' \
    -u cdosborn@email.arizona.edu:typKXxzqYik20zhdHSmFY85xH7wbTmnw \
    --data-urlencode 'narrow=[{"operator":"stream", "operand":"blogging"}]' \
    --data-urlencode 'num_before=35000' \
    --data-urlencode 'num_after=35000' \
    --data-urlencode 'use_first_unread_anchor=true' \
    --data-urlencode client_gravatar=false \
    --data-urlencode apply_markdown=false | \
    jq -r '.messages[] | [.timestamp, 1] | map(tostring) | join(" ")' | \

while read timestamp num_senders; do
    if [ $timestamp = "None" ]; then
        continue;
    fi
    # hours_since_sunday=$(date +"%k" --date=@$timestamp);
    hours_since_sunday=$(TZ=MST date +"(%w * 24) + %k" --date=@$timestamp | bc);
    echo "$hours_since_sunday $num_senders";
done |

awk '
{
    cum_unique_senders[$1] += $2
}

END {
    for (timestamp in cum_unique_senders) {
        print timestamp " " cum_unique_senders[timestamp];
    }
}
'
