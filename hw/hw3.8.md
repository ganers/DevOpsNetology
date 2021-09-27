# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

   #### Ответ:
   ```
   route-views>show ip route 92.255.175.115
   Routing entry for 92.255.160.0/20
   Known via "bgp 6447", distance 20, metric 0
   Tag 6939, type external
   Last update from 64.71.137.241 7w0d ago
   Routing Descriptor Blocks:
   * 64.71.137.241, from 64.71.137.241, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
   
   -------------------------------------------------
   
   route-views>show bgp 92.255.175.115
   BGP routing table entry for 92.255.160.0/20, version 61445818
   Paths: (24 available, best #22, table default)
   Not advertised to any peer
   Refresh Epoch 1
   701 1299 9049 41682
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin incomplete, localpref 100, valid, external
      path 7FE149AB4598 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 1299 9049 41682
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin incomplete, localpref 100, valid, external
      Community: 3257:8095 3257:30622 3257:50001 3257:53900 3257:53904 20912:65004
      path 7FE0305B7218 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 1299 9049 41682
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin incomplete, localpref 100, valid, external
      Community: 2516:1030 7660:9003
      path 7FE0B6743D88 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 9049 41682
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin incomplete, metric 0, localpref 100, valid, external
      path 7FE125BD1110 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 174 1299 9049 41682
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin incomplete, localpref 100, valid, external
      Community: 174:21000 174:22013 53767:5000
      path 7FE0E432B360 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 9002 9002 9002 9002 9002 9049 9049 41682
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      path 7FE0FD44AD48 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 9002 9002 9002 9002 9002 9049 9049 41682
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840
      path 7FE10D61A5C8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 9049 41682
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin incomplete, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE0B8810C60 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 2914 1299 9049 41682
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin incomplete, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 2914:420 2914:1007 2914:2000 2914:3000
      Extended Community: RT:101:22100
      path 7FDFFC05F768 RPKI State not found
      rx pathid: 0, tx pathid: 0   
   ```
   
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

   #### Ответ:
   ```
   auto dummy0
   iface dummy0 inet static
        address 10.2.2.2/32
        pre-up ip link add dummy0 type dummy
        post-down ip link del dummy0
   
   Вывод команды ip a (только dummy интерфейс)
   3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether da:a0:bb:de:51:f1 brd ff:ff:ff:ff:ff:ff
    inet 10.2.2.2/32 brd 10.2.2.2 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::d8a0:bbff:fede:51f1/64 scope link
       valid_lft forever preferred_lft forever
   
   vagrant@vagrant:~$ ip route
    default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
    8.8.4.4 via 10.0.2.2 dev eth0 metric 99
    8.8.4.4 via 10.2.2.2 dev dummy0 metric 100
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
    10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
   ```
   
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

   #### Ответ:
   ```
   vagrant@vagrant:~$ ss -tlpn
    State      Recv-Q     Send-Q           Local Address:Port           Peer Address:Port     Process
    
    LISTEN     0          4096                   0.0.0.0:111                 0.0.0.0:*
    
    LISTEN     0          511                    0.0.0.0:80                  0.0.0.0:*
    
    LISTEN     0          4096             127.0.0.53%lo:53                  0.0.0.0:*
    
    LISTEN     0          128                    0.0.0.0:22                  0.0.0.0:*
    
    LISTEN     0          4096                      [::]:111                    [::]:*
    
    LISTEN     0          511                       [::]:80                     [::]:*
    
    LISTEN     0          128                       [::]:22                     [::]:*
    
    vagrant@vagrant:~$ sudo lsof -i -P | grep TCP
    systemd      1            root   35u  IPv4  15471      0t0  TCP *:111 (LISTEN)
    systemd      1            root   37u  IPv6  15475      0t0  TCP *:111 (LISTEN)
    rpcbind    586            _rpc    4u  IPv4  15471      0t0  TCP *:111 (LISTEN)
    rpcbind    586            _rpc    6u  IPv6  15475      0t0  TCP *:111 (LISTEN)
    systemd-r  587 systemd-resolve   13u  IPv4  22773      0t0  TCP localhost:53 (LISTEN)
    nginx      775            root    6u  IPv4  22977      0t0  TCP *:80 (LISTEN)
    nginx      775            root    7u  IPv6  22978      0t0  TCP *:80 (LISTEN)
    nginx      776        www-data    6u  IPv4  22977      0t0  TCP *:80 (LISTEN)
    nginx      776        www-data    7u  IPv6  22978      0t0  TCP *:80 (LISTEN)
    nginx      777        www-data    6u  IPv4  22977      0t0  TCP *:80 (LISTEN)
    nginx      777        www-data    7u  IPv6  22978      0t0  TCP *:80 (LISTEN)
    sshd       825            root    3u  IPv4  24041      0t0  TCP *:22 (LISTEN)
    sshd       825            root    4u  IPv6  24052      0t0  TCP *:22 (LISTEN)
   
   80 порт используют web сервера (протокол http)
   22 порт используется для подключения к консоли через протокол ssh
   ```
   
4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

   #### Ответ:
   ```
   vagrant@vagrant:~$ ss -ulpn
    State      Recv-Q     Send-Q           Local Address:Port           Peer Address:Port     Process
    
    UNCONN     0          0                127.0.0.53%lo:53                  0.0.0.0:*
    
    UNCONN     0          0               10.0.2.15%eth0:68                  0.0.0.0:*
    
    UNCONN     0          0                      0.0.0.0:111                 0.0.0.0:*
    
    UNCONN     0          0                         [::]:111                    [::]:*
   
   vagrant@vagrant:~$ sudo lsof -i -P | grep UDP
    systemd      1            root   36u  IPv4  15472      0t0  UDP *:111
    systemd      1            root   38u  IPv6  15478      0t0  UDP *:111
    systemd-n  399 systemd-network   17u  IPv4  17884      0t0  UDP vagrant:68
    rpcbind    586            _rpc    5u  IPv4  15472      0t0  UDP *:111
    rpcbind    586            _rpc    7u  IPv6  15478      0t0  UDP *:111
    systemd-r  587 systemd-resolve   12u  IPv4  22772      0t0  UDP localhost:53
   
   53 Порт используется для DNS запросов
   
   ```
   
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 

   #### Ответ:
   ```
   
   ```
   
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

   #### Ответ:
   ```
   
   ```
   
7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

   #### Ответ:
   ```
   
   ```
   
8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

   #### Ответ:
   ```
   
   ```
   