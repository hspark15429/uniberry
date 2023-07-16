#!/bin/bash

for i in {0..29}
do
  start=$((i*50+1))
  sleep 2
  echo "Start: $start"

  curl 'https://ct.ritsumei.ac.jp/ct/syllabus__search' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Cookie: _gcl_au=1.1.778170085.1688563759; _ga_ZM07YZZRDX=GS1.1.1688563759.1.0.1688563759.60.0.0; _ga=GA1.1.458452997.1688563759; _ga_5VG6G31KPD=GS1.1.1688563759.1.0.1688563759.60.0.0; _opensaml_req_ss%3Amem%3Ae9ea9862ebc694162e03f5ffc0ec35b7fd70a34e539b6dae13aa59954803fbeb=_cec351759cab47356897a2ea27ed37d5; TS013943fe=01f6baab7bef0ca6e922678285f660f5ec984432c4c3c4143a944ddbaa180acd7c565a3b64b9cde304538ad16aa5677ceb9710a14d; SMSESSION=Sm1KNy5Dr9q++2QnbNTGT/za/FY0fXzNNls46SaziLefkUwWBdqwnIXg6fS63fqxolifN+0EfZjfyibp0wDajwKH97HO+1aeX8/s0cLV2tctoHfMbvKiVA5dVf07V7EiWrXQb6CVZdpbhO6yrs4lKciQmmf15AC13SFIPBWoTVpQyVBO291T+LinGlh1wpG8kV5yZI2iYgbVMNlh7SUp/RdjwrNMHPxiixQnZxGkuOFhLRoCT6xujFRH2yvc6q//A1rqYBfVkCyPh4/r+yOC9z4ix2Jm+r+j2Z1WVXYm714jUjlTWkHksXvkw7e+h+TFtyJsDnJbeiebKCPjNhnOnUaHn5EgVRWHhXt4ZmPXRlAvbtZJIS5NTGOrP/4NRlz674+DyafPXj8ln72NoD0v7S34CFcAvAykXrkPOFb6tNGW9ciCdHrIH4hNS1xi2WtvCxdPw2V8/rnllmiNJqML4Xv/QZbLgFZaAudXkdCt+6Myv/qaI3yKASE2YsRW6XJ8k93GJwEK6Wr2CmpczjkeFF95zIRR3HUbnHiZSdQjXNAgUoOIq7ik9/mDJexS51gd43ZSZwoeLuSNxKSotGeAem08RlsskGkpDCtwyGhMrjMMMEHG+nGlP3xonm41ZM4qRBlT9ZjFOob8DWHi8ZAwBirg1ahYBFixijy3uPwuxPsPvc7mOSuDxV1lTI+qYgqnamY+9TAqvr7lrIhMRc2GKO8GYS5cqGrkgi9fBajjUREX9rFWos1BYnj8MX+ZLyBXZSgKAi9n2bpSYmd25MWIXqlQPWi7UqBrsZtimMXa1CumwQzlhKYbiziOdQUnRHq1AHnXUh3jvBQ+PQq+0b75OCWNXsz10HfDndFRyw8EOLu35cj7B7ZJqYEql97qKZcRwfJAI7ThneAchhqkXj3VfqfsWIq0K8zCAyVwC8G+OR8EEMHbVy2L47973KlSaXglaG6ILxVwpRkMw4eQ/VBDhQYYldX+G9EIbwMVKqpXMRAFxbBGsTAqkXU7DfPKon9OO0lKIyZ1YApMegaO4/F+hg/QxrIhNtKM6dnzQu28lPV9yivj/nMAC1NhVptU8j8QyCKwqof/O4Nvo1hf85pAKgRgD4VUcLXaUZlozHOzxde2owTLZcRS5gDuNuL+s4cP; TS0196071f=01f6baab7b42cb1f3d5c275ff60e9b8f395d6689d2944ffc7d123832b4ffbedbc31c05ff4eee3252450b1fe43ab74e4d980f8d5d8a; _shibsession_64656661756c7468747470733a2f2f63742e72697473756d65692e61632e6a702f73686962626f6c657468=_4ae69dc2e6b9a7a9ec5d8ddd998701a3; sessionid=9cfc3a262c10cdf9850db1f9e1441990; _opensaml_req_ss%3Amem%3Aea91fe886e0e8ece48d63a9c346ab4fd49b625c64dde3ad5b2b383e871232467=_48020aa2d5f238d80e257bf9247f1be4; _opensaml_req_ss%3Amem%3Aafceb0dcf5919b267f8a79e68844c53c22d87e9733e6557b0af01efc0d5839ce=_0e54e9d3b39e95fc6a046f4b64b9054a; _opensaml_req_ss%3Amem%3A02a67a1787d6d7210dddb5460bbb1c8f6a26f27e466bd69f2f9ac7d4bbec6f5e=_1ad3851ab74f095abc569da89f572877; _opensaml_req_ss%3Amem%3Aab198257703857c468a4a2cbdc4ed0cb48ad7253ac1e14114b94ee13d46c5815=_c213b0bb2cbc32a2799cb77b002d589c; _opensaml_req_ss%3Amem%3Af654c7d7f9f3ef560e4b47a8ba67a30d3dca02dbb00e032f1e06e7a18c245a6f=_c4eb35d5a2334cb933319b3350d58e10; _opensaml_req_ss%3Amem%3A021dfb41f191bc2c849273ab25eae49df8bb29fe6288a8a3f1ee314229420719=_db89281a1d8ed6e2c6d3d3848114dfb3; _opensaml_req_ss%3Amem%3Aad91c699568d37142defdc66312e49bce35ad4902e74494c1f1c9a94f100750f=_c54f45e1e608f64531564ed296b5c50c; _opensaml_req_ss%3Amem%3A9e44acb00cfd0e0e82f4c76366b151705e8d3aa87ba02a6abc2a478a3c218385=_2c3c46bd9c1a5706e4b27e3e91720029' \
  -H 'Origin: https://ct.ritsumei.ac.jp' \
  -H 'Referer: https://ct.ritsumei.ac.jp/ct/syllabus__search' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (iPad; CPU OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/87.0.4280.77 Mobile/15E148 Safari/604.1' \
  --data-raw "search=&prevsearch=&pagelen=50&detail=&org=021300&year=2023&termgroup=&manaba-form=1&SessionValue1=H4sIAAAAAAAA%2F2Ph5DA0MjYxNTO3YOHg4GBmYWBg4GItLkksKpEAMoGM9NT44MqcnMSk0uLgjPzy%0D%0A4JLEktJiqBJWmBIuBcvktGTjRCMzo2RDg%2BSUNEsLU4OUJMM0y1RDExNDS0sDTqDS4NTi4sz8PM8U%0D%0AqHYRTBtSE4uSMwBrrLIJlQAAAA%3D%3D%0D%0A&SessionValue=%401&start=$start" \
  --compressed >> output2.html
done