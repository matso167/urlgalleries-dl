read -p "Directory name: " dir
mkdir dl/$dir
echo "Paste thumbnails (then CTRL+D): "
input=$(</dev/stdin)

echo ""
echo "Downloading html documents"

wget -q --level 1 -nd -r -P dl/$dir -A jpg $(echo $input | grep -oP '[^\ ]*.jpg' | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net\//')
jpgs=$(cat $(find "$PWD/dl/$dir" -type f -printf "%T@ %Tc %p\n" | sort -n | grep -oP ' \K/.*') | grep -oP 'src="\Khttps://[^"]*.jpg')
rm dl/$dir/*.jpg

echo "Downloading images"

i=0
for jpg in $jpgs
do
  i=$(($i+1))
  wget -q -O $PWD/dl/$dir/$i.jpg $jpg &
  echo "Downloaded $PWD/dl/$dir/$i.jpg"
done