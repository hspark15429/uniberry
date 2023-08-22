#!/bin/bash

# prev_result=""
string_list=(
"021100"
"021200"
"021300"
"021400"
"021500"
"021800"
"021600"
"021900"
"025100"
"022000"
"025300"
"025200"
"022601"
"022700"
"022800"
"025000"
"021102"
"021202"
"021302"
"021402"
"021502"
"021802"
"021602"
"021902"
"022001"
"022603"
"022702"
"022802"
"025002"
"026718"
"026719"
"026720"
"026721"
"026722"
"026723"
"026724"
"026725"
"026726"
"025202"
)
for string in "${string_list[@]}"; do
  echo "Processing string: $string"

for i in {0..50}
do
  start=$((i*50+1))
  sleep 2
  echo "Start: $start"
current_result=$(curl 'https://ct.ritsumei.ac.jp/syllabussearch/?lang=ja' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Cookie: sessionid=aeed2840c86937d6c936c0db6cbb2aa3; _gcl_au=1.1.778170085.1688563759; _opensaml_req_ss%3Amem%3Ae9ea9862ebc694162e03f5ffc0ec35b7fd70a34e539b6dae13aa59954803fbeb=_cec351759cab47356897a2ea27ed37d5; _opensaml_req_ss%3Amem%3Aea91fe886e0e8ece48d63a9c346ab4fd49b625c64dde3ad5b2b383e871232467=_48020aa2d5f238d80e257bf9247f1be4; _opensaml_req_ss%3Amem%3Aafceb0dcf5919b267f8a79e68844c53c22d87e9733e6557b0af01efc0d5839ce=_0e54e9d3b39e95fc6a046f4b64b9054a; _opensaml_req_ss%3Amem%3Aab198257703857c468a4a2cbdc4ed0cb48ad7253ac1e14114b94ee13d46c5815=_c213b0bb2cbc32a2799cb77b002d589c; _opensaml_req_ss%3Amem%3Af654c7d7f9f3ef560e4b47a8ba67a30d3dca02dbb00e032f1e06e7a18c245a6f=_c4eb35d5a2334cb933319b3350d58e10; _opensaml_req_ss%3Amem%3Aad91c699568d37142defdc66312e49bce35ad4902e74494c1f1c9a94f100750f=_c54f45e1e608f64531564ed296b5c50c; _opensaml_req_ss%3Amem%3A9e44acb00cfd0e0e82f4c76366b151705e8d3aa87ba02a6abc2a478a3c218385=_2c3c46bd9c1a5706e4b27e3e91720029; _opensaml_req_ss%3Amem%3A92adf7cd6ce24b9254fb04d5070be23ae4d3d83b267e479a67265101564ab0f9=_85148ffac4c252f3b9baef64fb6f187b; _opensaml_req_ss%3Amem%3Aa42d3250fde5d84e7b5e547a91b6405b73f5132ffea23a9689714abc633ed6a1=_3e72c42632a15eace0a46637565675e8; _opensaml_req_ss%3Amem%3A96f69824df91afeff52ace2c9895fc73b85109cc5bacdf1559069546cef7e30a=_b3d93c24987472b99a1319a6b1e0b7d0; _opensaml_req_ss%3Amem%3A5c56893666b5e397a70dc0b486dfe1e9c9c05b0858b5282984a78cb8b20f6268=_d7871d1f7fe58e2454368cd62df57ee9; _opensaml_req_ss%3Amem%3Aedeb87bcac9570dc6753f3134cc28b12eefcd3de3426f93d6d251a403b59701e=_bac1be6af339730414551087c8dba0dd; _opensaml_req_ss%3Amem%3A57cf9a02b99f03c69fbde6577227fe91fb6f67c98441f7c0db7134d58980d9c2=_4d3a67e0660b1ab8e5787e86f40e3d1e; _opensaml_req_ss%3Amem%3A684ef37fd081f9fe7e4d7a3002c526e73f6cefc814816fc82c8c88bb1e7292a3=_199cea0470610327615def51f28c2cfe; _opensaml_req_ss%3Amem%3Ab4c565fe163407731e6894a490c567e8a9602c0ccc17077867b523506a79af99=_342936f9325729762c881d0a8e837516; _opensaml_req_ss%3Amem%3Aed64bd061a3c65c41971856d7da8e0caf723eb643b523cfa18180bd5650aa8a7=_7226aac89563165ff06059f1f6969306; _opensaml_req_ss%3Amem%3A9459000c04d14ae9d3264cb7da5ee96baa8796e4cc66bae412c63260d01bb99f=_a46e33098a4e161e0a91bfc4d291c35d; _opensaml_req_ss%3Amem%3A5c563de180dfbb24c855a1ad0d0ad913db70e29023c2ea9bf2097971650dac97=_97f8cc57d10252826224e7efbc12f431; TS01182571=01f6baab7bdbb66bee70191650b3f1a3fffd0d9970bfc561b218275d93690cc2ae47f23010bf26dfe66b84ff6d1b516ca16226006e; _ga_BELMNJ6E57=GS1.3.1690771103.1.0.1690771103.0.0.0; _ga_JH95BN71Q2=GS1.3.1690771103.1.0.1690771103.0.0.0; _ga_XXQDE8KKFM=GS1.3.1690771103.1.0.1690771103.0.0.0; _ga_JW5J5FC5D6=GS1.3.1690771103.1.0.1690771103.0.0.0; _ga_37Z0GR6TZ4=GS1.3.1690771103.1.0.1690771103.0.0.0; _ga_WJTDP2HWSH=GS1.3.1690771103.1.0.1690771103.0.0.0; _ga_WJSR9DWRWD=GS1.3.1690771103.1.0.1690771104.0.0.0; _ga_LYG9EVTT1J=GS1.3.1690771103.1.0.1690771104.0.0.0; _ga_LZ2VNTNZEN=GS1.3.1690771103.1.0.1690771104.0.0.0; _ga_SLGJKCX6MB=GS1.3.1690771103.1.0.1690771104.0.0.0; _opensaml_req_ss%3Amem%3A9450a919e8cb95d03df369d634c3e47ce9719e5309b5e64191762f5d09c9781c=_76a90f11f710f306278843cfa560e579; _ga_YRV4PH7T16=GS1.1.1690771102.1.0.1690771152.10.0.0; _ga_E2TK7E0ESJ=GS1.1.1690771102.1.0.1690771152.10.0.0; _ga=GA1.1.458452997.1688563759; _ga_5VG6G31KPD=GS1.1.1691071589.5.1.1691072084.60.0.0; _ga_ZM07YZZRDX=GS1.1.1691071589.5.1.1691072084.60.0.0; TS013943fe=01f6baab7bf18e869737740c37d7c8f684c9401f87bdfe17b5bc6d1028ac003ca769e96098d9f92a15eb748d4f5c77de5a842e407e; SMSESSION=Yx2TIQl/IubOiAs84k54nLhAJy6C0oPGe/nhJ80kIMupqZ0YnLJgmtY96QKi0TVxDy4aqX8xWWpHTI+pU20xVa+74dp6xbypJh7XgzDzhSwXTKEaEdg6GvFDxJMEQyZ7SMtod4K7p3NT5zM7by+4VB3Ue41vG+ZOpai1xHTLkgPyL3UaK2t3mrHzK7ZAIO/uW39D9MUwCoMNy20q+Ww/qsC9HM53PKSrebhXnAh3Op9wHhKK3iL1OcKtj6K48+l3vT+Qf6SSzM9dk8hopj5oBWi/Ot9gfCgCH6FeVDqC9EAtvri0GNULrbD/k2sfeB8o/JQ3QzWyKAPOI26A6zhTJslUZckvjsK0DvZ98zqs2+rmm2ZGwh/Ps4uzKLo05eoclcmnVWAcKMgFSP51mBWFahgV0Rul1yzfrbrZLZaeGpWucA/D5E+YPjQLrg+wFOf/+mLRJtVisbsdSjAATjBT9jVSpmPEmKcFUEPJVrtQhPEYBnsEetfCmmV7+v74aD79jGL2J32ASBaR5rejY+N4N+2jNspQYPQnq96kDE/CkaA6D8T69bzUueSExo0XmrSZKJeoJpwYNJ58bMyRbKNFqdMUPvkYDl5MGdEEex6/9k62mnYRODhwDW6kJPWR4xBI+WzG7KZHOJMGtbrzf8IxVyUUAQ/niJezOUzy9ckcgisvCqx4E+yTrMECm7YeH5Qucp9gGftI98/Ffa2H/mk3/a0SxybgdblT1XG08m72c17P4B+KmhH7h9MFBnOwYeH09e23Ou5tbdCeEj5X17RsTRvTJiwISjXHZgstP6XVSzJ1VLVzqtwqg+gzhKO+9X2lZoklPsh8o7InrGIIezd6QoFmotwik8Bakfrz3RS85Ws6d8Hr4ya1E2sTu9xTAY8fIa5rxT8BtRHEiWOhOiV9m1TS5y9BTjefq/ddNvI8kcKJhEEmMQxUFRRMkb9uUYOJTVqVMq4EF312MalfyK2AGs1g76K1s9CoNDA9a+sZIz0/qQWy4nxZqg5fmHNuLfGl2+BxodmqnEKCPjGGbPx70TTNLYVpnOUee85ZDzy5seMej80K9f2y79SDzBxmOjetwFx5RLSdBFo5cGvL2jlL1qsFXT0U3ZafHBl0L+a/mb60Y0+5S0IdABUxBGCza3X9; TS0196071f=01f6baab7bb01535764d50ee5b7eda60779bf81383b0094ef754cdb28791f1abbde428f0532d73b8bbf05331b383ae877cccc29b2f; _shibsession_64656661756c7468747470733a2f2f63742e72697473756d65692e61632e6a702f73686962626f6c657468=_19d2ec0cd1375ae7fea564691879f422; sessionid=d4679429084296dccd88212c691e356b' \
  -H 'Origin: https://ct.ritsumei.ac.jp' \
  -H 'Referer: https://ct.ritsumei.ac.jp/syllabussearch/?lang=ja' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1' \
  --data-raw "search=&prevsearch=&pagelen=50&detail=&org=$string&year=2023&termgroup=&start=$start" \
  --compressed)
  
  # Check if the current result contains the specified message
  if [[ "$current_result" == *致する情報は見つかりませんでした* ]]; then
    echo "No information found. Exiting loop."
    break
  fi

  # prev_result="$current_result"

  echo "$current_result" >> output2.html

done

  sleep 2
done