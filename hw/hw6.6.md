# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

#### Ответ:

---
Запускаем mongo shell
db.currentOp() - находим ID зависшей операции
db.killOp(opId) - завершаем операцию

Для долгих запросов можно использовать метод maxTimeMS(<ms>)

---

## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

#### Ответ:

---
Никогда не работал с Redis, по этому мой ответ больше похож на предположение!

Не совсем понимаю при чем тут масштабирование, но дело видимо в том, что истекших ключей более 25% и за первую итерацию (за 1 секунду) не все истекшие ключи удаляются и далее Redis блокируется чтобы продолжить очистку.

P.s. Вообще разьяснения подобных нюансов я жду от этого курса. Напишите в ответе пожалуйста как на самом деле это работает и правильно ли я это понял.

---

## Задача 3

Перед выполнением задания познакомьтесь с документацией по [Common Mysql errors](https://dev.mysql.com/doc/refman/8.0/en/common-errors.html).

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения данной проблемы вы можете предложить?

#### Ответ:

---
Для начала я бы изучил логи MySQL.

Если исключить проблемы с сетью то учитывая рост базы велика вероятность того, что субд не успевает вернуть большое количество записей. Как вариант увеличить значение параметра net_read_timeout.

Не сталкивался с гис-системами, но на сколько я понимаю основные данные гис-системы должны хранится в BLOB формате. Тогда нам потребуется увеличить значение параметра max_allowed_packet.

---

## Задача 4

Перед выполнением задания ознакомтесь со статьей [Common PostgreSQL errors](https://www.percona.com/blog/2020/06/05/10-common-postgresql-errors/) из блога Percona.

Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Как бы вы решили данную проблему?

#### Ответ:

---
Заканчивается память и oom-killer останаливает процесс PostgreSQL.
Привести настройки памяти выделеной для PostgreSQL в соответствии с имеющимися ресурсами.

---