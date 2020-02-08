. ../../variables
. ../../functions
stylesheet="../site.css"
. variables;

cat <<TEMPLATE
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>${title}</title>
        <meta name="description" content="${description}" />
	$(< ../../fragments/fonts.html)
        <link rel="stylesheet" type="text/css" href="${stylesheet}"/>
        <style>
            blockquote {
                margin: 2.5em 0em 2.5em 1em;
            }
        </style>
    </head>
    <body>
    <div class="horizontalContainer">
        <div class="verticalContainer">
            <div class="header">
                <h1>
                  <span class="reading_notes_book_title_prefix">Reading Notes on</span>
                  <span class="reading_notes_book_title">&lsquo;${book_name}&rsquo;</span>
                </h1>
                <p>$(date +"%B %-d, %Y" --date=$date)</p>
                <p>$(time_to_read < index.md) min read</p>
            </div>
            $(markdown index.md)
            $(< ../../fragments/post-footer.html)
        </div>
    </div>
    </body>
</html>
TEMPLATE

