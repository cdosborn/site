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
                <p>
                  <img src="images/mccarren-birds.png" />
                </p>
                <p>
                  My name is Connor. I live in <span style="text-decoration:line-through">Tuscon</span> Brooklyn.
                  I'm a freelance web developer available for hire <a
                  href="https://www.upwork.com/o/profiles/users/~01908259f8444ee40d">here</a>.
                  I occasionally post <a href="/posts.html">here.</a>
                </p>
                <p>
                    Reach me at connor@cdosborn.com.
                </p>
            </div>
        </div>
    </body>
</html>
TEMPLATE
