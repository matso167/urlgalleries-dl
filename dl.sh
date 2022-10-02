read -p "Directory name: " dir
mkdir dl/$dir
read -p "Paste thumbnails: " input
wget --level 2 -o - -nd -r -P dl/$dir -A jpg --follow-tags=img --span-hosts $(echo $input | grep -oP '[^\ ]*.jpg' | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net\//')
read -p "Press any key to delete unecessary files from: $PWD/dl/$dir or CTRL+C to cancel" -n 1 -r
find $PWD/dl/$dir -type f -size -100k -delete
