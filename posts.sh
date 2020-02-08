. variables

stylesheet="site.css"

function formatDate {
  date +"%Y" --date "$1";
}

set -x

# renderRow(path,date,prev_date)
function renderRow {
    local path="$1";
    local date="$2";
    local prev_date="$3";
    local title="$4";
    local print_year=1

    if [ -n "$prev_date" ]
    then
      # Only print the year if it's different than the previous
      if [ $(date +%Y --date "$prev_date") = $(date +%Y --date "$date") ]
      then
        print_year=0
      fi
    fi
    echo "
    <div style='margin-bottom: 0.5em; display: flex'>
       <div style='flex: 1'>
        <a class='no-decoration serif' href='${path}'>${title}</a>
       </div>
       $(
         if [ "$print_year" = 1 ]
         then
           echo "
           <div>
             <span class='monospace' style='margin-left:1em'>$(date +%Y --date "$date")</span>
           </div>
           "
         fi
       )
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
             {
               prev_date="";
               while read sort_key path date title; do
                  renderRow "$path" "$date" "$prev_date" "$title";
                  prev_date="$date"
               done;
             }
             )
        </div>
    </div>
    </body>
</html>
TEMPLATE
