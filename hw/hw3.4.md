# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
   
   #### Ответ:
   ```
   vagrant@vagrant:~$ systemctl status node_exporter
   ● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-09-14 15:14:30 UTC; 12min ago
   Main PID: 615 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 18.1M
     CGroup: /system.slice/node_exporter.service
             └─615 /usr/local/bin/node_exporter
   ```
   ```node_exporter.service
   vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
   [Unit]
   Description=Node Exporter
   After=network.target

   [Service]
   User=node_exporter
   Group=node_exporter
   Type=symple
   EnvironmentFile=-/etc/node_exporter.cfg
   ExecStart=/usr/local/bin/node_exporter $ARGS

   [Install]
   WantedBy=multi-user.target
   ```

2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
   
   #### Ответ:
   ```
   Через curl http://localhost:9100/metrics | grep node_ - можно получить метрики для мониторинга системы.
   node_cpu_*, node_memory_*,node_disk_*, node_network_* - чтобы выбрать какие то конкретные в данный момент надо изучать node_exporter, в мануалах на ГитХабе не нашел пока чего то вменяемого.
   
   С какими опциями ознакомится??? Не понимаю о чем идет реч.
   ```
   
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
   
   #### Ответ:
   ```
   P.s. Интересный инструмент. Как-то можно организовать (стандартными средствами) одну точку входа для нескольких серверов которые мониторятся NetData?
   ```
   
4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

   #### Ответ:
   ```
   DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
   Hypervisor detected: KVM
   CPU MTRRs all blank - virtualized system.
   Booting paravirtualized kernel on KVM
   systemd[1]: Detected virtualization oracle.
   ```
   
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

   #### Ответ:
   ```
   Максимальное количества открытых файлов
   fs.nr_open = 1048576
   ulimit -n 1048576
   
   ```
   
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
   
   #### Ответ:
   ```
   vagrant@vagrant:~$ sudo nsenter --target 1722 -p --mount
   root@vagrant:/# ps -aux
   USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
   root           1  0.0  0.0   8076   592 pts/3    S+   17:16   0:00 sleep 1h
   root           2  0.0  0.3   9836  4012 pts/2    S    17:17   0:00 -bash
   root          11  0.0  0.3  11680  3540 pts/2    R+   17:17   0:00 ps -aux
   root@vagrant:/#
   
   Вроде все отработало как надо.
   
   P.s. но нам ничего толком и не рассказали про то как это устроено. По советуйте пожалуйста где и что почитать на эту тему для новичков!!!
   ```
   
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

   #### Ответ:
   ```
   Функция которая вызывает себя два раза (непонял почему именно fork). Рекурсивно создает по два новых "СЕБЯ" :-)))
   Не совсем понял когда это прекратилось, пока не нажал ЕНТЕР ничего не менялось, в dmesg нашел только это
   cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope с большим времнем выполнения.
   Через 5 минут ВМ так и тупит. При попытке запустить команду man выдает "man: fork failed: Resource temporarily unavailable" - делаю вывод никакие штатные механизмы не победили ЭТО на моей ВМ.
   
   Количество процессов на пользователя можно задать с помощью ulimit -u
   ```