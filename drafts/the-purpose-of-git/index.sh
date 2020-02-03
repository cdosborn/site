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
    </head>
    <body>
    <div class="horizontalContainer">
        <div class="verticalContainer">
            <div class="header">
                <h1>Make better git contributions</h1>
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

