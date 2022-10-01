wget --level 2 -o - -nd -r -P dl1 -A jpg --follow-tags=img --span-hosts $(cat input | grep -oP '[^\ ]*.jpg' | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net\//')
#find . -type f -size -100k -delete