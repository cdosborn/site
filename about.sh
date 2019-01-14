. variables

stylesheet="site.css"

cat <<TEMPLATE
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>${title}</title>
        <meta name="description" content="${description}">
	$(< fragments/fonts.html)
        <link href="https://fonts.googleapis.com/css?family=Droid+Serif:400,700" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="${stylesheet}">
        <style>
            img {
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div class="horizontalContainer">
            <div class="verticalContainer">
                <img src="images/about.jpg"> </img>
                <div>
                    <p>My name is Connor Osborn. I live in Tuscon. </p>
                    <p>
                       My hope is that I can use this blog to improve my writing, and to share worthwhile ideas.
                    </p>
                    <p>
                        I have a personal motto: I want to understand a
                        few things well.
                    </p>
                    <p>
                        Reach me at connor@cdosborn.com.
                    </p>
                </div>
            </div>
        </div>
    </body>
</html>
TEMPLATE