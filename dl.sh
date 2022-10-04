dl () {
  local num=$(printf "%03d" $1)
  #echo "get $3"
  local html=$(wget -q -O - $3)
  #echo $html > debug/$num.html
  local url=$(echo $html | grep -oPi -m 1 "src=(\"|')\Khttps://[^(\"|')]*.(jpg|jpeg)")
  echo "$url --> $PWD/dl/$2/$num.jpg"
  wget -q -O dl/$2/$num.jpg $url
  echo "Downloaded $PWD/dl/$2/$num.jpg"
}

read -p "Directory name: " dir
mkdir dl/$dir
echo "Paste thumbnails (then CTRL+D): "

input=$(</dev/stdin)
#echo $input > debug/input.txt
echo $input | grep -oPi ".*?.(jpg|jpeg)( |$)" | tr -d " " | sed -r 's/#/%23/g' | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net\//' > links
i=0
cat links | while read link
do
  i=$(($i+1))
  dl $i $dir $link &
done

#find $PWD/dl/$dir -type f -size -100k -delete