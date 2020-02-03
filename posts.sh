. variables

stylesheet="site.css"

# renderRow(path,date,desc)
function renderRow {
    local path="$1";
    local date="$2";
    local desc="$3";
    echo "
    <div style='margin-bottom: 0.5em'>
        <a class='no-decoration serif' href=${path}>${desc}</a>&nbsp;<span class='monospace' style='margin-left:1em'>${date}</span>
    </div>
    ";
}

cat <<TEMPLATE
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>${title}</title>
        <meta name="description" content="${description}">
        <link rel="stylesheet" type="text/css" href="${stylesheet}" />
	$(< fragments/fonts.html)
    </head>
    <body>
    <div class="horizontalContainer">
        <div class="verticalContainer">
            $(
             while read path date title; do
                  echo "$(date +%s --date="$date")" "$path" "$date" "$title"
             done |
             sort -rn |
             while read sort_key path date desc; do
                renderRow "$path" "$date" "$desc";
             done;
             )
        </div>
    </div>
    </body>
</html>
TEMPLATE
