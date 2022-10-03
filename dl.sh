dl () {
  local num=$(printf "%03d" $1)
  local url=$(wget -q -O - $3 | grep -oPi -m 1 'src="\Khttps://[^"]*.jpg')
  wget -q -O dl/$2/$num.jpg $url
  echo "Downloaded $PWD/dl/$2/$num.jpg"
}

read -p "Directory name: " dir
mkdir dl/$dir
echo "Paste thumbnails (then CTRL+D): "

echo $(</dev/stdin) | grep -oPi "[^\ ]*.jpg( |$)" | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net\//' > links
i=0
cat links | while read link
do
  i=$(($i+1))
  dl $i $dir $link &
done

#find $PWD/dl/$dir -type f -size -100k -delete