function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

img () {
  local num=$(printf "%03d" $1)
  touch dl/$2/$num.jpg.tmp
  wget -q -O dl/$2/$num.jpg "$3"
  rm dl/$2/$num.jpg.tmp
}

dl () {
  local i=$1
  local urls=$(wget -q -O - "$3" | grep -Pzo "(.|\n)*bottom-articles" | grep -oPi " src=(\"|')\Khttps://[^(\"|')]*.(jpg|jpeg|webp)")
  
  for url in $urls
  do 
    i=$(($i+1))
    img $i $2 $url &
  done
  
  echo $i
}

url=$(xsel)
#read -p "Gallery URL: " url
name=$(urldecode $(echo $url | grep -oP ".*?\K[^\/]+$"))
dir="$name-$(date +%s)"
echo "dir: $dir"
mkdir dl/$dir

input=$(curl "$url&a=10000" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105.0')
echo $input | grep -oPi " href=(\"|')\K[^(\"|\')]*\.(jpg|jpeg)" | tr -d " " | sed -r 's/#/%23/g' | sed -e 's/^/https:\/\/xarchivesx.urlgalleries.net/' > links
echo "$input" | grep -F /$name | grep -oPi " href=\"\K/[^ \"]*" | sort -u | sed -e 's/^/https:\/\/buondua.com/' > links

i=0
cat links | while read link
do
  i=$(dl $i $dir $link)
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