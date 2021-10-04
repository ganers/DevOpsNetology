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
   