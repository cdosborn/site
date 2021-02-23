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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.1.1/css/all.min.css" />
        <link rel="stylesheet" type="text/css" href="${stylesheet}"/>
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
    <script src="https://colorjs.io/dist/color.js"></script>
    <!--
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>
    -->
    <script src="https://unpkg.com/react@17/umd/react.production.min.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js" crossorigin></script>
    <script src="https://unpkg.com/lodash@4.17.20/lodash.min.js" crossorigin></script>
    <script src="https://unpkg.com/zdog@1/dist/zdog.dist.min.js" crossorigin></script>
    <script>
    $(< ./reactusegesture.umd.production.min.js)
    </script>
    <script>
    $(< ./main.js)
    </script>
</html>
TEMPLATE

