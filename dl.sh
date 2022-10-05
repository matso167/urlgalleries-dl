dl () {
  local num=$(printf "%03d" $1)
  touch dl/$2/$num.jpg.tmp
  local html=$(wget -q -O - $3)
  local url=$(echo $html | grep -oPi -m 1 "src=(\"|')\Khttps://[^(\"|')]*.(jpg|jpeg)")
  #echo "$url --> $PWD/dl/$2/$num.jpg"
  wget -q -O dl/$2/$num.jpg $url
  #echo "Downloaded $PWD/dl/$2/$num.jpg"
  rm dl/$2/$num.jpg.tmp
}

read -p "Directory name: " dir
mkdir dl/$dir
read -p "Paste gallery URL: " url
input=$(curl "$url&a=10000" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105.0')
echo $input | grep -oPi " href=(\"|')\K[^(\"|\')]*\.(jpg|jpeg)" | tr -d " " | sed -r 's/#/%23/g' | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net/' > links

i=0
cat links | while read link
do
  i=$(($i+1))
  dl $i $dir $link &
done

rm links
sleep 5

while [ $(ls $PWD/dl/$dir/*.tmp | wc -l) -gt 0 ]
do
  echo "Downloads in progress: $(ls $PWD/dl/$dir/*.tmp | wc -l)"
  sleep 1
done

find $PWD/dl/$dir -type f -size -20k -delete
echo "ok"