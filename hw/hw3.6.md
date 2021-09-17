# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?
  
   #### Ответ:
   ```  
    vagrant@vagrant:~$ telnet stackoverflow.com 80
    Trying 151.101.65.69...
    Connected to stackoverflow.com.
    Escape character is '^]'.
    GET /questions HTTP/1.0
    HOST: stackoverflow.com
    
    HTTP/1.1 301 Moved Permanently
    cache-control: no-cache, no-store, must-revalidate
    location: https://stackoverflow.com/questions
    x-request-guid: 27af7b61-cb79-4954-b251-4131d8ce7a61
    feature-policy: microphone 'none'; speaker 'none'
    content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
    Accept-Ranges: bytes
    Date: Fri, 17 Sep 2021 09:47:37 GMT
    Via: 1.1 varnish
    Connection: close
    X-Served-By: cache-hel6825-HEL
    X-Cache: MISS
    X-Cache-Hits: 0
    X-Timer: S1631872057.320223,VS0,VE201
    Vary: Fastly-SSL
    X-DNS-Prefetch-Control: off
    Set-Cookie: prov=8f77db8f-84f6-577f-a8f9-fdd7fde85fad; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly
    
    Connection closed by foreign host.
  
    P.s. HTTP/1.1 301 Moved Permanently - означает редирект на https://stackoverflow.com/questions 
   ```
   
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.
  
    ```
   Не свовсем понял что какой код надо в ответ вставить. Статус код или все заголовки. Прикрепил все.
  
   Первый запрос обрабатывается дольше всего.
  
   [Ссылка на скрин](https://cloud.mail.ru/public/fixy/DxSbx1Xpx)
   ```
   #### Ответ:
   ```
    uest URL: https://stackoverflow.com/
    Request Method: GET
    Status Code: 200 
    Remote Address: 151.101.1.69:443
    Referrer Policy: strict-origin-when-cross-origin
    accept-ranges: bytes
    cache-control: private
    content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
    content-type: text/html; charset=utf-8
    date: Fri, 17 Sep 2021 09:49:47 GMT
    feature-policy: microphone 'none'; speaker 'none'
    strict-transport-security: max-age=15552000
    vary: Accept-Encoding,Fastly-SSL
    via: 1.1 varnish
    x-cache: MISS
    x-cache-hits: 0
    x-dns-prefetch-control: off
    x-frame-options: SAMEORIGIN
    x-request-guid: a8776cc4-0bea-4c45-a0b7-ae6e8437d9ea
    x-served-by: cache-hel6827-HEL
    x-timer: S1631872188.725059,VS0,VE104
    :authority: stackoverflow.com
    :method: GET
    :path: /
    :scheme: https
    accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
    accept-encoding: gzip, deflate, br
    accept-language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7
    cookie: prov=1451ec54-cc25-be19-9651-3ed11ddaa4ca; _ga=GA1.2.350702573.1631700952; _gid=GA1.2.1757935383.1631869199; _gat=1
    sec-ch-ua: "Google Chrome";v="93", " Not;A Brand";v="99", "Chromium";v="93"
    sec-ch-ua-mobile: ?1
    sec-ch-ua-platform: "Android"
    sec-fetch-dest: document
    sec-fetch-mode: navigate
    sec-fetch-site: none
    sec-fetch-user: ?1
    upgrade-insecure-requests: 1
    user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.45
   ```
   
3. Какой IP адрес у вас в интернете?
  
   #### Ответ:
   ```
   92.255.175.115
   ```
   
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
  
   #### Ответ:
   ```
   "Company "ER-Telecom" Tyumen'
   AS41682
   ```
   
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
  
   #### Ответ:
   ```
   traceroute через стандартный(созданый по умолчанию в VirtualBox) NAT показывает всего 2 хопа через дефолтовый шлюз.
   Я добавил еще один интерфейс в режиме моста, далее вывод команды.
   
   P.s. выяснил почему по умолчанию traceroute так работает, с ключом -I команда отрабатывает как надо.
   
    vagrant@vagrant:~$ sudo traceroute -nA 8.8.8.8 -i eth1
    traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
     1  192.168.1.1 [*]  0.560 ms  0.708 ms  0.906 ms
     2  * * *
     3  109.194.168.18 [AS41682]  3.651 ms  3.716 ms  3.690 ms
     4  72.14.215.165 [AS15169]  29.143 ms  29.115 ms  29.279 ms
     5  72.14.215.166 [AS15169]  33.169 ms  33.123 ms  33.289 ms
     6  10.23.175.190 [*]  30.035 ms 10.23.140.62 [*]  31.294 ms 10.252.173.190 [*]  31.311 ms
     7  108.170.227.120 [AS15169]  28.261 ms 108.170.227.82 [AS15169]  28.139 ms 72.14.233.94 [AS15169]  28.258 ms
     8  108.170.250.99 [AS15169]  34.792 ms 108.170.250.51 [AS15169]  32.138 ms 108.170.250.146 [AS15169]  38.807 ms
     9  * * *
    10  74.125.253.94 [AS15169]  63.139 ms 172.253.66.110 [AS15169]  39.562 ms 74.125.253.94 [AS15169]  63.020 ms
    11  216.239.56.101 [AS15169]  57.222 ms  62.959 ms 142.250.233.27 [AS15169]  42.549 ms
    12  * * *
    13  * * *
    14  * * *
    15  * * *
    16  * * *
    17  * * *
    18  * * *
    19  * * *
    20  * * 8.8.8.8 [AS15169]  41.724 ms
   ```
   
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
  
   #### Ответ:
   ```
                                           My traceroute  [v0.93]
    vagrant (10.0.2.15)                                                          2021-09-17T10:44:34+0000
    Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                             Packets               Pings
    Host                                                      Loss%   Snt   Last   Avg  Best  Wrst StDev
    1. AS???    10.0.2.2                                       0.0%   113    0.2   6.8   0.1 190.4  29.5
    1. AS???    192.168.1.1                                    0.0%   112    2.1   1.2   0.8   8.4   0.7
    2. AS41682  188.186.75.252                                 0.0%   112    1.6   1.8   1.3  14.9   1.5
    3. AS41682  109.194.168.18                                 0.0%   112    1.8   2.5   1.5  40.3   4.1
    4. AS15169  72.14.215.165                                  0.0%   112   28.2  28.7  28.0  33.8   1.0
    5. AS15169  72.14.215.166                                  0.0%   112   32.2  32.6  31.9  42.8   1.5
    6. AS15169  108.170.250.129                                0.0%   112   29.4  29.7  29.3  32.7   0.4
    7. AS15169  108.170.250.146                                8.9%   112   31.2  34.3  31.1  78.7   8.3
    8. AS15169  142.251.71.194                                58.6%   112   56.2  57.5  56.0  72.4   3.2
    9. AS15169  74.125.253.109                                11.7%   112   38.4  40.2  38.0  87.8   6.8
    10. AS15169  172.253.64.55                                  0.0%   112   40.1  40.4  39.8  49.0   1.1
    11. (waiting for reply)
    12. (waiting for reply)
    13. (waiting for reply)
    14. (waiting for reply)
    15. (waiting for reply)
    16. (waiting for reply)
    17. (waiting for reply)
    18. (waiting for reply)
    19. (waiting for reply)
    20. AS15169  8.8.8.8                                        0.0%   112   41.4  38.5  37.8  47.7   1.5
   
   Наибольшая задержка на участке "AS15169  142.251.71.194"
   Наблюдаются большие потери с 7 по 9 хопы
   ```
   
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
  
   #### Ответ:
   ```
    dns.google.             10800   IN      NS      ns1.zdns.google.
    dns.google.             10800   IN      NS      ns4.zdns.google.
    dns.google.             10800   IN      NS      ns3.zdns.google.
    dns.google.             10800   IN      NS      ns2.zdns.google.
    
    dns.google.             192     IN      A       8.8.4.4
    dns.google.             192     IN      A       8.8.8.8
   ```
   
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`
  
   #### Ответ:
   ```
    8.8.8.8.in-addr.arpa.   72596   IN      PTR     dns.google.
    4.4.8.8.in-addr.arpa.   77763   IN      PTR     dns.google.
   
   dns.google - имя привзяанное к IP 8.8.8.8 и 8.8.4.4
   ```