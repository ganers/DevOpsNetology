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
  Ansible написан на популярном языке Python и имеет большое количество компонентов и большое сообщество. Прост в установке.
  Мне кажеться более надежным метод работы pull, но более удобный метод push, т.к. для его работы нет необходимости устанавливать агентов на управляемые машины.
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
  
   ```
