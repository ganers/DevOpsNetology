## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

   #### Ответ:
   ```
  Сокращение сроков разработки и дотавки ПО.
  Автоматизация подготовки среды для разработчиков и продукта.
  Поддержка одинаковой среды для разработчиков, тестировщиков, продукта.
  
  Основной принцип IaaC сокращение времени и ресурсов на разработку, доставку и развертывание ПО.
   ```

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

   #### Ответ:
   ```
  Ansible использует существующую SSH инфраструктуру.
  Не представляю как определить какой метод работы более надежный, более удобный метод push, т.к. для его работы нет необходимости устанавливать агентов на управляемые машины.
   ```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

   #### Ответ:
   ```
  - VirtualBox:
  root@ganers-ubuntu:/home/ganers# virtualbox --help
  Oracle VM VirtualBox VM Selector v6.1.26_Ubuntu
  (C) 2005-2021 Oracle Corporation
  All rights reserved.

  No special options.
  
  If you are looking for --startvm and related options, you need to use VirtualBoxVM.

  - Vagrant:
  root@ganers-ubuntu:/home/ganers# vagrant --version
  Vagrant 2.2.18

  - Ansible:
  root@ganers-ubuntu:/home/ganers# ansible --version
  ansible [core 2.11.6]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.5 (default, Jul 28 2020, 12:59:40) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True
   ```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

   #### Ответ:
   ```
   P.s. При первом чистом запуске выдается такая ошибка:
   
    TASK [Gathering Facts] *********************************************************
    fatal: [server1.netology]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: ssh: Could not resolve hostname 5.2/src/vagrant/.vagrant/machines/server1.netology/virtualbox/private_key: Name or service not known", "unreachable": true}
    
    PLAY RECAP *********************************************************************
    server1.netology           : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0   
    
    Ansible failed to complete successfully. Any error output should be
    visible above. Please fix these errors and try again.
    
   P.s. После vagrant destroy (в корне все равно остается папка .vagrant) новый запуск проходит без ошибок. Я пробовал создавать паралельно еще одну машину и есть у меня подозрение, что проблемы были из-за того что мы используем маппинг портов для виртуалбокса!!!
    ---------------------------------------------------------------------------------
   
    erver1.netology: Running ansible-playbook...

    PLAY [nodes] *******************************************************************
    
    TASK [Gathering Facts] *********************************************************
    ok: [server1.netology]
    
    TASK [Create directory for ssh-keys] *******************************************
    changed: [server1.netology]
    
    TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
    changed: [server1.netology]
    
    TASK [Checking DNS] ************************************************************
    changed: [server1.netology]
    
    TASK [Installing tools] ********************************************************
    ok: [server1.netology] => (item=['git', 'curl'])
    
    TASK [Installing docker] *******************************************************
    changed: [server1.netology]
    
    TASK [Add the current user to docker group] ************************************
    changed: [server1.netology]
    
    PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ---------------------------------------------------------------------------------
    
    vagrant@server1:~$ docker --version
    Docker version 20.10.10, build b485636
   ```
