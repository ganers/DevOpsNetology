# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

   #### Ответ:
   ```
   Готово!
   Установил плагин на Chrome. Сохранил логин-пароль в ручном и автоматическом режиме.
   ```
   
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

   #### Ответ:
   ```
   Готово!
   ```
   
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

   #### Ответ:
   ```
   sudo apt install apache2
   sudo a2enmod ssl
   sudo systemctl restart apache2
   sudo openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout /etc/ssl/private/apache-ssc.key -out /etc/ssl/certs/apache-ssc.crt -subj "/C=RU/ST=Tyumen/L=Tyumen/O=DevOps/OU=Org/CN=localhost"
   sudo nano /etc/apache2/sites-available/ganers.local.conf
   
   <VirtualHost *:443>
      ServerName ganerx.local
      DocumentRoot /var/www/ganers.local
      SSLEngine on
      SSLCertificateFile /etc/ssl/certs/apache-ssc.crt
      SSLCertificateKeyFile /etc/ssl/private/apache-ssc.key
   </VirtualHost>
   
   sudo mkdir /var/www/ganers.local
   nano /var/www/ganers.local/index.html
   
   <h1>it worked!</h1>
   
   sudo a2ensite ganers.local.conf
   sudo apache2ctl configtest
   sudo systemctl reload apache2
   
   #проверяем
   vagrant@vagrant:~$ curl -k https://localhost
   <h1>It worked!</h1>
   ```
   
4. Проверьте на TLS уязвимости произвольный сайт в интернете.

   #### Ответ:
   ```
    Testing vulnerabilities

    Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
    CCS (CVE-2014-0224)                       not vulnerable (OK)
    Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
    ROBOT                                     Server does not support any cipher suites that use RSA key transport
    Secure Renegotiation (RFC 5746)           supported (OK)
    Secure Client-Initiated Renegotiation     not vulnerable (OK)
    CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
    BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
    POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
    TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
    SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
    FREAK (CVE-2015-0204)                     not vulnerable (OK)
    DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                              make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                              https://censys.io/ipv4?q=BFB95BD2637AC2D4C0BF109780B95FD004082BF9DFDCB029B8CACF251F4DC5CF could help you to find out
    LOGJAM (CVE-2015-4000), experimental      common prime with 2048 bits detected: RFC3526/Oakley Group 14 (2048 bits),
                                              but no DH EXPORT ciphers
    BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
    LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
    Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
    RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)
   ```
   
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
 
   #### Ответ:
   ```
   ganers@lgsm-server:~$ ssh-keygen
   Generating public/private rsa key pair.
   Enter file in which to save the key (/home/ganers/.ssh/id_rsa):
   Enter passphrase (empty for no passphrase):
   Enter same passphrase again:
   Your identification has been saved in /home/ganers/.ssh/id_rsa.
   Your public key has been saved in /home/ganers/.ssh/id_rsa.pub.
   The key fingerprint is:
   
   # В ручную скопировал id_rsa.pub на ВМ Vagrant
   echo <pub key> >> .ssh/authorized_keys
   ssh ganers@192.168.3.6
   ```
   
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

   #### Ответ:
   ```
   touch .ssh/config
   chmod 600 .ssh/config
   nano .ssh/config
   
   Host lgsm
        HostName 192.168.3.6
        IdentityFile .ssh/lgsm.pub
        User ganers

   Host *
        User vagrant
        IdentityFile .ssh/id_rsa
        Protocol 2
   
   ssh lgsm
   
   P.s. Я не совсем понял почему для "Host *" мы используем приватный ключ (из урока)???
   ```
   
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

   #### Ответ:
   ```
   sudo tcpdump -c 100 -w 001.pcap -i eth0
   
   С помощью WinSCP выкачал файл и открыл в Wireshark на Windows.
   
   No.	Time	Source	Destination	Protocol	Length	Info
   1	0.000000	10.0.2.15	10.0.2.2	SSH	146	Server: Encrypted packet (len=92)
   2	0.000277	10.0.2.2	10.0.2.15	TCP	60	62367 → 22 [ACK] Seq=1 Ack=93 Win=65535 Len=0
   3	112.075822	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [SYN] Seq=0 Win=65535 Len=0 MSS=1460
   4	112.075859	10.0.2.15	10.0.2.2	TCP	58	22 → 60618 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460
   5	112.076058	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=1 Ack=1 Win=65535 Len=0
   6	112.077141	10.0.2.2	10.0.2.15	SSHv2	87	Client: Protocol (SSH-2.0-OpenSSH_for_Windows_8.1)
   7	112.077148	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1 Ack=34 Win=64207 Len=0
   8	112.091786	10.0.2.15	10.0.2.2	SSHv2	95	Server: Protocol (SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.2)
   9	112.092051	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=34 Ack=42 Win=65535 Len=0
   10	112.092500	10.0.2.2	10.0.2.15	SSHv2	1446	Client: Key Exchange Init
   11	112.092507	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=42 Ack=1426 Win=64032 Len=0
   12	112.093176	10.0.2.15	10.0.2.2	SSHv2	1110	Server: Key Exchange Init
   13	112.093347	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=1426 Ack=1098 Win=65535 Len=0
   14	112.094819	10.0.2.2	10.0.2.15	SSHv2	102	Client: Elliptic Curve Diffie-Hellman Key Exchange Init
   15	112.094832	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1098 Ack=1474 Win=64032 Len=0
   16	112.108461	10.0.2.15	10.0.2.2	SSHv2	562	Server: Elliptic Curve Diffie-Hellman Key Exchange Reply, New Keys, Encrypted packet (len=228)
   17	112.108689	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=1474 Ack=1606 Win=65535 Len=0
   18	112.112679	10.0.2.2	10.0.2.15	SSHv2	70	Client: New Keys
   19	112.112684	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1606 Ack=1490 Win=64032 Len=0
   20	112.112802	10.0.2.2	10.0.2.15	SSHv2	98	Client: Encrypted packet (len=44)
   21	112.112807	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1606 Ack=1534 Win=64032 Len=0
   22	112.112898	10.0.2.15	10.0.2.2	SSHv2	98	Server: Encrypted packet (len=44)
   23	112.113147	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=1534 Ack=1650 Win=65535 Len=0
   24	112.113183	10.0.2.2	10.0.2.15	SSHv2	122	Client: Encrypted packet (len=68)
   25	112.113187	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1650 Ack=1602 Win=64032 Len=0
   26	112.122182	10.0.2.15	10.0.2.2	SSHv2	106	Server: Encrypted packet (len=52)
   27	112.122471	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=1602 Ack=1702 Win=65535 Len=0
   28	112.129634	10.0.2.2	10.0.2.15	SSHv2	706	Client: Encrypted packet (len=652)
   29	112.129641	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1702 Ack=2254 Win=64032 Len=0
   30	112.138965	10.0.2.15	10.0.2.2	SSHv2	106	Server: Encrypted packet (len=52)
   31	112.139229	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2254 Ack=1754 Win=65535 Len=0
   32	117.269177	PcsCompu_73:60:cf	RealtekU_12:35:02	ARP	42	Who has 10.0.2.2? Tell 10.0.2.15
   33	117.269398	RealtekU_12:35:02	PcsCompu_73:60:cf	ARP	60	10.0.2.2 is at 52:54:00:12:35:02
   34	126.868149	10.0.2.2	10.0.2.15	SSHv2	202	Client: Encrypted packet (len=148)
   35	126.878281	10.0.2.15	10.0.2.2	SSHv2	82	Server: Encrypted packet (len=28)
   36	126.878484	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2402 Ack=1782 Win=65535 Len=0
   37	126.879310	10.0.2.2	10.0.2.15	SSHv2	166	Client: Encrypted packet (len=112)
   38	126.920811	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=1782 Ack=2514 Win=64032 Len=0
   39	127.426653	10.0.2.15	10.0.2.2	SSHv2	690	Server: Encrypted packet (len=636)
   40	127.426923	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2514 Ack=2418 Win=65535 Len=0
   41	127.426936	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   42	127.427092	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2514 Ack=2454 Win=65535 Len=0
   43	127.427289	10.0.2.2	10.0.2.15	SSHv2	174	Client: Encrypted packet (len=120)
   44	127.427295	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=2454 Ack=2634 Win=64032 Len=0
   45	127.428681	10.0.2.15	10.0.2.2	SSHv2	162	Server: Encrypted packet (len=108)
   46	127.428850	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2634 Ack=2562 Win=65535 Len=0
   47	127.429063	10.0.2.15	10.0.2.2	SSHv2	514	Server: Encrypted packet (len=460)
   48	127.431900	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2634 Ack=3022 Win=65535 Len=0
   49	127.444848	10.0.2.15	10.0.2.2	SSHv2	130	Server: Encrypted packet (len=76)
   50	127.445041	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2634 Ack=3098 Win=65535 Len=0
   51	133.140089	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   52	133.140127	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=3098 Ack=2670 Win=64032 Len=0
   53	133.140379	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   54	133.140615	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2670 Ack=3134 Win=65535 Len=0
   55	133.268652	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   56	133.268668	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=3134 Ack=2706 Win=64032 Len=0
   57	133.268951	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   58	133.269117	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2706 Ack=3170 Win=65535 Len=0
   59	133.540243	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   60	133.540269	10.0.2.15	10.0.2.2	TCP	54	22 → 60618 [ACK] Seq=3170 Ack=2742 Win=64032 Len=0
   61	133.540503	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   62	133.540667	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2742 Ack=3206 Win=65535 Len=0
   63	134.292731	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   64	134.292925	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   65	134.293086	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2778 Ack=3242 Win=65535 Len=0
   66	135.236355	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   67	135.236503	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   68	135.236702	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2814 Ack=3278 Win=65535 Len=0
   69	135.444595	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   70	135.444808	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   71	135.444967	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2850 Ack=3314 Win=65535 Len=0
   72	135.668206	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   73	135.668353	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   74	135.668531	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2886 Ack=3350 Win=65535 Len=0
   75	135.876412	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   76	135.876569	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   77	135.876748	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2922 Ack=3386 Win=65535 Len=0
   78	136.484414	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   79	136.484604	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   80	136.484743	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2958 Ack=3422 Win=65535 Len=0
   81	136.628787	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   82	136.628938	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   83	136.629100	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=2994 Ack=3458 Win=65535 Len=0
   84	136.956258	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   85	136.956445	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   86	136.956624	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=3030 Ack=3494 Win=65535 Len=0
   87	138.724630	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   88	138.724874	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   89	138.725064	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=3066 Ack=3530 Win=65535 Len=0
   90	138.908064	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   91	138.908251	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   92	138.908423	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=3102 Ack=3566 Win=65535 Len=0
   93	141.804287	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   94	141.804633	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   95	141.804803	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=3138 Ack=3602 Win=65535 Len=0
   96	141.908418	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   97	141.908732	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   98	141.908946	10.0.2.2	10.0.2.15	TCP	60	60618 → 22 [ACK] Seq=3174 Ack=3638 Win=65535 Len=0
   99	142.011492	10.0.2.2	10.0.2.15	SSHv2	90	Client: Encrypted packet (len=36)
   100	142.011884	10.0.2.15	10.0.2.2	SSHv2	90	Server: Encrypted packet (len=36)
   ```
   
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

   #### Ответ:
   ```
   
   ```
   
9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443

   #### Ответ:
   ```
   
   ```
   