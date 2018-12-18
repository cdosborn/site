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
        <link href="https://fonts.googleapis.com/css?family=Droid+Serif:400,700" rel="stylesheet"/>
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
                <h1>Reading Notes on <span style="font-family: 'Fira Mono';
                font-style: italic; white-space: nowrap; margin-left: 1em;
                word-spacing: -5px; ">&lsquo;${book_name}&rsquo;</span></h1>
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

