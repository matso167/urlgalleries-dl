dl () {
  local num=$(printf "%03d" $1)
  touch dl/$2/$num.jpg.tmp
  local url=$(wget -q -O - $3 | grep -oPi -m 1 "src=(\"|')\Khttps://[^(\"|')]*.(jpg|jpeg)")
  wget -q -O dl/$2/$num.jpg $url
  rm dl/$2/$num.jpg.tmp
}

read -p "Gallery URL: " url
dir="$(echo $url | grep -oP ".*?\K[^\/]+$")-$(date +%s)"
mkdir dl/$dir

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
while [ $(find $PWD/dl/$dir/ -type f -iname *.tmp | wc -l) -gt 0 ]
do
  echo -ne "Downloads in progress: $(find $PWD/dl/$dir/ -type f -iname *.tmp | wc -l) \r"
  sleep 1
done

echo -e '\nDownloads completed'

find $PWD/dl/$dir -type f -size -20k -delete
gpicview $PWD/dl/$dir/$(ls $PWD/dl/$dir | head -n 1)
