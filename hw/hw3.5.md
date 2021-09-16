# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
   
   #### Ответ:
   ```
   Узнал! Только не совсем понял зачем они нужны. ПО каким причинам обычный файл может иметь блоки нулевых байт?
   ```
   
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   
   #### Ответ:
   ```
   Не могут. Потому, что жесткая ссылка это файл физически ссылающийся на место оригинального файла. 
   ```
   
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
   
   #### Ответ:
   ```
   Готово. Только непонятно зачем создавать новую ВМ, почему просто не добавить диски к старой ВМ?!
   ```
   
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
   
   #### Ответ:
   ```
   vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
   Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
   Disk model: VBOX HARDDISK
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x399f3725

   Device     Boot   Start     End Sectors  Size Id Type
   /dev/sdb1          2048 4196351 4194304    2G 83 Linux
   /dev/sdb2       4196352 5242879 1046528  511M 83 Linux
   vagrant@vagrant:~$ sudo fdisk -l /dev/sdc
   Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
   Disk model: VBOX HARDDISK
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x399f3725

   Device     Boot   Start     End Sectors  Size Id Type
   /dev/sdc1          2048 4196351 4194304    2G 83 Linux
   /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
   ```
   
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
   
   #### Ответ:
   ```
   sudo sfdisk -d /dev/sdb > dev.sdb.dump
   sudo sfdisk /dev/sdc < dev.sdb.dump
   ```
   
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
   
   #### Ответ:
   ```
   sudo mdadm -C /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
   ```
   
7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
   
   #### Ответ:
   ```
    sudo mdadm -C /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
   ```
   
8. Создайте 2 независимых PV на получившихся md-устройствах.
   
   #### Ответ:
   ```
   sudo pvcreate /dev/md0 /dev/md1
   ```
   
9. Создайте общую volume-group на этих двух PV.
   
   #### Ответ:
   ```
   sudo vgcreate vol_group1 /dev/md0 /dev/md1
   ```
   
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
   
   #### Ответ:
   ```
   sudo lvcreate -L 100M -n logical_vol1 vol_group1 /dev/md1
   ```
   
11. Создайте `mkfs.ext4` ФС на получившемся LV.
   
   #### Ответ:
   ```
   sudo mkfs.ext4 /dev/vol_group1/logical_vol1
   ```
   
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
   
   #### Ответ:
   ```
   mkdir /tmp/new
   sudo mount /dev/vol_group1/logical_vol1 /tmp/new
   ```
   
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
   
   #### Ответ:
   ```
   Готово
   ```
   
14. Прикрепите вывод `lsblk`.
   
   #### Ответ:
   ```
   vagrant@vagrant:~$ lsblk
   NAME                          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   sda                             8:0    0   64G  0 disk
   ├─sda1                          8:1    0  512M  0 part  /boot/efi
   ├─sda2                          8:2    0    1K  0 part
   └─sda5                          8:5    0 63.5G  0 part
     ├─vgvagrant-root            253:0    0 62.6G  0 lvm   /
     └─vgvagrant-swap_1          253:1    0  980M  0 lvm   [SWAP]
   sdb                             8:16   0  2.5G  0 disk
   ├─sdb1                          8:17   0    2G  0 part
   │ └─md0                         9:0    0    2G  0 raid1
   └─sdb2                          8:18   0  511M  0 part
     └─md1                         9:1    0 1018M  0 raid0
       └─vol_group1-logical_vol1 253:2    0  100M  0 lvm   /tmp/new
   sdc                             8:32   0  2.5G  0 disk
   ├─sdc1                          8:33   0    2G  0 part
   │ └─md0                         9:0    0    2G  0 raid1
   └─sdc2                          8:34   0  511M  0 part
     └─md1                         9:1    0 1018M  0 raid0
       └─vol_group1-logical_vol1 253:2    0  100M  0 lvm   /tmp/new
   ```
   
15. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
   
   #### Ответ:
   ```
   Готово. Код завершения 0
   ```
   
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
   
   #### Ответ:
   ```
   sudo pvmove /dev/md1 /dev/md0
   /dev/md1: Moved: 12.00%
   /dev/md1: Moved: 100.00%
   ```
   
17. Сделайте `--fail` на устройство в вашем RAID1 md.
   
   #### Ответ:
   ```
   sudo mdadm --fail /dev/md0 /dev/sdb1
   mdadm: set /dev/sdb1 faulty in /dev/md0
   ```
   
18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
   
   #### Ответ:
   ```
   [30097.187895] md/raid1:md0: Disk failure on sdb1, disabling device.
                  md/raid1:md0: Operation continuing on 1 devices.
   ```
   
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
   
   #### Ответ:
   ```
   Готово. Код завершения 0
   ```
   
20. Погасите тестовый хост, `vagrant destroy`.
   
   #### Ответ:
   ```
   Легко.
   ```
   