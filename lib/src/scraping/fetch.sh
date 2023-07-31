#!/bin/bash

for i in {0..15}
do
  start=$((i*50+1))
  sleep 2
  echo "Start: $start"

curl 'https://ct.ritsumei.ac.jp/ct/syllabus__search' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: en-US,en;q=0.9,ko-KR;q=0.8,ko;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Cookie: TS013943fe=01f6baab7b5168d40c6cb9e5dcc562a9c442480b478deb347596ccd0298299dd89ee89306b84248ae932a386ef452ffa8963f5f52c; SMSESSION=TzWHwrdVw3cwPG+Q5uDHiQISrzofbdJ7ga0Xk30A1Q+jL8Q5N8wVgKRscan2HL0eXJCk04sq+paHJdN4dTLIQNhnkygCAnQWLx23i8TloOsrt9Mg3rme6bUOKKgg4LG7X+rxq1MGYe3N4WRqh5I8x+OG2Sf4A0or5YuvyNS6X/rOub1eXahyRlXD4DL9bIow8R9qD5QBP5Z3tPXPiOcFlg2hTdiuehA5DokXnWnOpzZ6hsc6DFGhCJgtnEn8qNPcKLU5w5aC2Z3uaUIJh6b/uFbBgGej6ZIgBqu6vzPVU8LX4kGG7npChh5bayaLCKfPXRPOr4ayscWtc6EI0lUuFwr1ZC49dwNcF6XD1B3jS9AOIzeAuLylpu+ccCzCeLX3/DxOrm4gzv1jyAUYWErJxxlbKXnwHn0JB8yrQ+mFdbPFM/d4oRhUVfoFT9KqaCH1X8S93UNftqoIbK2ZJh+uN4nMHGc31WfGr7mjFn1ikIr+S5zUI8gb1ozg2Wvx8I/2LRBAK4UYT5rzYIjgHedsg+f0mjpOBSi+haP0WxyIPwI1D2cGz06HaT8wd5kFtL6SiUTKNB0sKgjFcUWp5fbNF07XODT+kl1Q2evnEqMQQesKmaztwh4I0PDknSiSou9BoqjXEJENhJY4rZrJtf+NoPR6K8sbW7HuIEKspr2dN19fanuaBPb/UfIovCINWrFTKLWtldi8IZD4fVzQUe9GaH73PA+09/0xz+6K8fO+tZwW+A/rR9q/YHoieBwMN5Ek3ALkJaH6DwjP6U/S74sK3TuJk/8lUQ8FvUwLWIainJlVsVcRwq+cm6gvuLRM0RbW5ZZ8hYG3xqv1M6/bo/VtNyU95XRHBNpGJAKz2wXuK2Eq1YPJQ4nDyBr8FETtjkKD7n16roAvDmouzgsTNjrC8WrPalDmc/O1G/mzq78n3c+8FLuT14oSfViJEF7wZHsFBKcrc3XSMLUSjBl0Ui6bSnaYpp+ajbFNoPhz9NZl0Y8BuxEJuyKtxVZEKqexJ558NqNUQW9K8yuTYqb8TV10y7a4VVsugwWQ/RY72ai1z1p2a2Bz9Uefk5KfSC7AuEWJ5i6HHAjwneIPPWpm6VV/rDgeKERcPnVz8l7Q1ig+ciPOcNUdJ9+0O+33N7FcSMSC; TS0196071f=01f6baab7b867229758c8d88478ed74018c4de3b63ade7b84178310a615651a8f4a51f3082f47c14fd35b4658ef0454513113718d9; _shibsession_64656661756c7468747470733a2f2f63742e72697473756d65692e61632e6a702f73686962626f6c657468=_39621a7d5bdd1b65bd7a01b39da0efd6; sessionid=d11fccd8cec8a099030d2f60d4156da1; _opensaml_req_ss%3Amem%3A65eb93b3307f16024ce7591010f2482c02e8d38d59cdffded122a3a723144cba=_ceef04f6d30739c5ff3a1ab7da6cad2c; _opensaml_req_ss%3Amem%3A1202d898f0eb9e5a712ff103566ea69d1f333523be93356e0658def5c3723f9b=_d312e11b091758102ecd11ee4f87e8fe; _opensaml_req_ss%3Amem%3A87d548530c8e9e93f753e176628475732046276bd89deefd67cc55b5e70a2b70=_088073f9ebf4c22d50895717fa23ab45; _opensaml_req_ss%3Amem%3A8fe2246f55f6a373dc0b46eda43de5efdb32bc80898bc65fc22b7e12847c8b77=_a44d97f82fcc77777f8d888b4a989358; _opensaml_req_ss%3Amem%3A813de67062ad3b0e678df9b0628e181c42aae83f13833240b1f4fbb939b9788d=_0d1b3d35bff54c3f57db1a707e8d38b8; _opensaml_req_ss%3Amem%3A8ae2e6cb79692ef82750b14d2d0a8d94d3c85f681c35c7270f878960e9e24b21=_2a6f824a16868cdf0faa27d3e7ad3acd; _opensaml_req_ss%3Amem%3A1271927163ee2e8dfa806b25eeee3e4f3809a83a514594d895c32c998a36666d=_a0e6093803c1cc8639aed950bd9514cf; _opensaml_req_ss%3Amem%3A95055080cd61b967d595d7053845c1405417e3491735e61e96a77aa630c4c886=_36467ef3e628ad36bc5cf56aace10ad9; _opensaml_req_ss%3Amem%3A355827a242cc5683d5d3d8f27ed2599bf12319dca194085dae5278e7c6212269=_e554f98650bf43133234d0973326775b; _opensaml_req_ss%3Amem%3A7f1d6365977ca973b2857accf583f9b4ec1e656ecce463385d5a88c6bf087d68=_709dba586d5e97bb47389d94c06631d7; _opensaml_req_ss%3Amem%3A23f5affb1ecd4ec87361fd6e57539f013cb90bdee6d67b03abe30304d6f0e18c=_22243dfc8ebbc9c16fefb8e86d925abc; _opensaml_req_ss%3Amem%3Ac738e1fe5de096d858fba989dfacf66c3ad0ec5cadc3054ffb46ff4ad093e30b=_826c436dacd7e2975248fb8959738d3b; _opensaml_req_ss%3Amem%3Ab30a63e5e086f993908feb68868e5536fc2d2b42c5acedeb6c3bfcdadee607e8=_2ce7bedb1496399a271b44b775c1516a; _opensaml_req_ss%3Amem%3Ae3cf2f658f2200752be8c90ef2c870d04eedc05db84b25e29afc6453ec12a729=_55a59bbcab73590c6669c2fdc20ef538; _opensaml_req_ss%3Amem%3A5187bd2808a97038a512c272b852ec02d1fccabbeffa27b287362d5f7f32357e=_1b006207c9ecc379322cec857bdb65f9; _opensaml_req_ss%3Amem%3A2f9a2495da72e6ce440fe22215e103c8639272d927be33eda132487504624741=_14ff852d900ef296418f01cba6db6512; _opensaml_req_ss%3Amem%3A79ca67b4c44ba1e95a44f7c522205220b8362ca2b27cf2024626cce0a0f7b194=_88f9a0e975505301112302954bdac6f4; _opensaml_req_ss%3Amem%3Aef740c4bdfc3b796f316884973b9377b8a4a832358838ea3ebf8815d9afecb64=_3b507404e4db464061d58936465d966f' \
  -H 'Origin: https://ct.ritsumei.ac.jp' \
  -H 'Referer: https://ct.ritsumei.ac.jp/ct/syllabus__search' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Not.A/Brand";v="8", "Chromium";v="114", "Google Chrome";v="114"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  --data-raw "search=&prevsearch=&pagelen=50&detail=&org=025100&year=2023&termgroup=&manaba-form=1&SessionValue1=H4sIAAAAAAAA%2F2Ph5DA0MjYxNTO3YOHg4GBmYWBg4GItLkksKpEAMoGM9NT44MqcnMSk0uLgjPzy%0D%0A4JLEktJiqBJWmBIuhRRDw7Tk5BSL5NRki0QDS0sDY4MUozQzgxQTQ1OzlERDTqDS4NTi4sz8PM8U%0D%0AqHYRTBtSE4uSMwACs1pDlQAAAA%3D%3D%0D%0A&SessionValue=%401&start=$start" \
  --compressed >> output2.html
done

