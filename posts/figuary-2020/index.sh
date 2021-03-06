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
            #title_a {
		font-family: 'Fira Mono';
		white-space: nowrap;
		word-spacing: -5px;
		font-size: 0.6em;
		margin-bottom: 0.3em;
		display: block;
            }
            #title_b {
		display: block;
 		font-family: 'Fira Mono';
		font-style: italic;
		word-spacing: -5px;
            }
        </style>
    </head>
    <body>
    <div class="horizontalContainer">
        <div class="verticalContainer">
            <div class="header">
                <h1>${title}</h1>
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

