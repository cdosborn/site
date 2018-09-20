. variables
. functions

function items {
    for post in $(find posts -maxdepth 1 -mindepth 1 -type d); do
        ( . "${post}/variables";
          if [ -z "$public" -o "$public" != "false"  ]; then
              echo "
                <item>
                    <title>$title</title>
                    <link>https://$domain/posts/$(slugify "$title").html</link>
                    <description>$description</description>
                </item>";
          fi
        )
    done;
}

cat <<TEMPLATE
<?xml version="1.0"?>
<rss version="0.92">
<channel>
    <title>${title}</title>
    <link>https://www.cdosborn.com</link>
    <language>en-us</language>
    <description>${description}</description>
    $(items)
</channel>
</rss>
TEMPLATE
