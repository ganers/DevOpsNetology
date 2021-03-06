# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

#### Ответ:

---
```
\l
\c <name db> <user>
\dt, \dt+
\d <table name>
\q
```
---
## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

#### Ответ:

---
```
select tablename,attname,avg_width from pg_stats where tablename='orders';
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | id      |         4
 orders    | title   |        16
 orders    | price   |         4
 
 select max(avg_width) from pg_stats where tablename='orders';
 max
-----
  16
```
---

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

#### Ответ:

---
```
CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);

CREATE OR REPLACE FUNCTION orders_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.price > 499) THEN
        INSERT INTO orders_1 VALUES (NEW.*);
    ELSIF ( NEW.price <= 499) THEN
        INSERT INTO orders_2 VALUES (NEW.*);
    ELSE
        INSERT INTO orders VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
```
<p> Чтобы избежать ручного разбиения таблицы можно было бы использовать "декларативное партиционирование".

<p> P.s. Видел на просторах интернета вариант с созданием правил (CREATE RULE) не понял как это работает. МОжет в данном случае всетаки нужно использовать подход с правилами???
<p> P.P.s. При текущем варианте я так понимаю нам прийдется адресовать запросы разным таблицам. Дайте совет как всетаки правильно разбивать таблицы чтобы обращаться можно было и к партициям и к основной таблице?
---

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

#### Ответ:

---
```
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE,
    price integer DEFAULT 0
);

```
---