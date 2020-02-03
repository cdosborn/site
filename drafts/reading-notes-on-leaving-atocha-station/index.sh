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
            .verticalContainer {
                margin: 2em 1em;
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
            img {
                margin: 0em;
                width: 100%;
            }
            body {
                margin: 0 auto;
                width: 40em;
            }
        </style>
    </head>
    <body>
    <img src="/images/fake_flower_hero.jpg"/>
    <div class="horizontalContainer">
        <div class="verticalContainer">
            <div class="header">
                <h1>
                <span id="title_a">Reading Notes on</span>
                <span id="title_b">${book_name}</span>
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

