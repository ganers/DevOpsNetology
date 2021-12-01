# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

#### Ответ:

---
```
mysql> status
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)
...
Server version:         8.0.27 MySQL Community Server - GPL
...

mysql> SELECT * FROM test_db.orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

```
---

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

#### Ответ:

---

```
mysql> SELECT * FROM information_schema.user_attributes WHERE user='test';
+------+-----------+-----------+
| USER | HOST      | ATTRIBUTE |
+------+-----------+-----------+
| test | 127.0.0.1 | NULL      |
+------+-----------+-----------+
1 row in set (0.01 sec)


mysql> SELECT User,max_questions,plugin,password_lifetime,User_attributes FROM mysql.user WHERE User="test";
+------+---------------+-----------------------+-------------------+------------------------------------------------------------------------------------------------------------------------+
| User | max_questions | plugin                | password_lifetime | User_attributes                                                                                                        |
+------+---------------+-----------------------+-------------------+------------------------------------------------------------------------------------------------------------------------+
| test |           100 | mysql_native_password |               180 | {"Name": "James", "Familita": "Prety", "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 1}} |
+------+---------------+-----------------------+-------------------+------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

P.s. Я так понимаю первый запрос должен был вывести что то подобное второму!? Что я сделал не так?

---

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

#### Ответ:

---
Профилирование
```
mysql> show profiles;
+----------+------------+---------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                             |
+----------+------------+---------------------------------------------------------------------------------------------------+
|       20 | 0.00087450 | SELECT ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='test_db'                         |
|       21 | 0.00105275 | SELECT Table_schema,Engine,Table_name FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='test_db' |
|       22 | 0.00006675 | show profile from query 21                                                                        |
+----------+------------+---------------------------------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)

mysql> show profile for query 21;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000149 |
| Executing hook on transaction  | 0.000015 |
| starting                       | 0.000012 |
| checking permissions           | 0.000009 |
| Opening tables                 | 0.000486 |
| init                           | 0.000015 |
| System lock                    | 0.000014 |
| optimizing                     | 0.000020 |
| statistics                     | 0.000107 |
| preparing                      | 0.000037 |
| executing                      | 0.000066 |
| checking permissions           | 0.000029 |
| end                            | 0.000004 |
| query end                      | 0.000004 |
| waiting for handler commit     | 0.000010 |
| closing tables                 | 0.000013 |
| freeing items                  | 0.000039 |
| cleaning up                    | 0.000027 |
+--------------------------------+----------+
18 rows in set, 1 warning (0.00 sec)
```
Engine
```
mysql> SELECT Table_schema,Engine,Table_name FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='test_db';
+--------------+--------+------------+
| TABLE_SCHEMA | ENGINE | TABLE_NAME |
+--------------+--------+------------+
| test_db      | InnoDB | orders     |
+--------------+--------+------------+
1 row in set (0.00 sec)

mysql> ALTER TABLE test_db.orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE test_db.orders ENGINE=InnoDB;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW profiles;
+----------+------------+------------------------------------------+
| Query_ID | Duration   | Query                                    |
+----------+------------+------------------------------------------+
|        1 | 0.00021400 | set profiling=1                          |
|        2 | 0.00875950 | ALTER TABLE test_db.orders ENGINE=MyISAM |
|        3 | 0.01024850 | ALTER TABLE test_db.orders ENGINE=InnoDB |
+----------+------------+------------------------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql> show profile for query 2;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000068 |
| Executing hook on transaction  | 0.000006 |
| starting                       | 0.000023 |
| checking permissions           | 0.000006 |
| checking permissions           | 0.000007 |
| init                           | 0.000014 |
| Opening tables                 | 0.000305 |
| setup                          | 0.000091 |
| creating table                 | 0.000694 |
| waiting for handler commit     | 0.000010 |
| waiting for handler commit     | 0.000985 |
| After create                   | 0.000269 |
| System lock                    | 0.000009 |
| copy to tmp table              | 0.000087 |
| waiting for handler commit     | 0.000007 |
| waiting for handler commit     | 0.000008 |
| waiting for handler commit     | 0.000017 |
| rename result table            | 0.000043 |
| waiting for handler commit     | 0.002268 |
| waiting for handler commit     | 0.000009 |
| waiting for handler commit     | 0.000822 |
| waiting for handler commit     | 0.000007 |
| waiting for handler commit     | 0.001601 |
| waiting for handler commit     | 0.000008 |
| waiting for handler commit     | 0.000376 |
| end                            | 0.000663 |
| query end                      | 0.000305 |
| closing tables                 | 0.000005 |
| waiting for handler commit     | 0.000020 |
| freeing items                  | 0.000020 |
| cleaning up                    | 0.000011 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)

mysql> show profile for query 3;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000097 |
| Executing hook on transaction  | 0.000004 |
| starting                       | 0.000016 |
| checking permissions           | 0.000004 |
| checking permissions           | 0.000003 |
| init                           | 0.000010 |
| Opening tables                 | 0.000160 |
| setup                          | 0.000039 |
| creating table                 | 0.000054 |
| After create                   | 0.003522 |
| System lock                    | 0.000010 |
| copy to tmp table              | 0.000063 |
| rename result table            | 0.000541 |
| waiting for handler commit     | 0.000009 |
| waiting for handler commit     | 0.001235 |
| waiting for handler commit     | 0.000009 |
| waiting for handler commit     | 0.002266 |
| waiting for handler commit     | 0.000009 |
| waiting for handler commit     | 0.001129 |
| waiting for handler commit     | 0.000025 |
| waiting for handler commit     | 0.000335 |
| end                            | 0.000300 |
| query end                      | 0.000237 |
| closing tables                 | 0.000005 |
| waiting for handler commit     | 0.000018 |
| freeing items                  | 0.000130 |
| cleaning up                    | 0.000022 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.00 sec)
```
---

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

#### Ответ:

---
```
innodb_log_file_size 100MB
innodb_compression_level 9
innodb_log_buffer_size 1
innodb_buffer_pool_size "КАК ЗАДАТЬ В ПРОЦЕНТНОМ СООТНОШЕНИИ?"
```
---
