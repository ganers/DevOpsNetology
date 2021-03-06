# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
- Склады и автомобильные дороги для логистической компании
- Генеалогические деревья
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
- Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

#### Ответ:

---
- Электронные чеки в json виде - документо ориентированная СУБД
- Склады и автомобильные дороги для логистической компании - Не совсем понятно какие данные необходимо хранить в БД. Если отдельные сущности складов и дорог то Column-oriented. Если связи складов дорогами то Графовая или Реляционная
- Генеалогические деревья - Иерархическая СУБД, т.к. БД этого типа имеет древовидную структуру
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации - Key-Value СУБД
- Отношения клиент-покупка для интернет-магазина - реляционные или документо ориентированные СУБД
---

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

#### Ответ:

---
- Данные записываются на все узлы с задержкой до часа (асинхронная запись) - AP - AP\EC
- При сетевых сбоях, система может разделиться на 2 раздельных кластера - AP - AP\EL
- Система может не прислать корректный ответ или сбросить соединение - CP - Не понимаю этого варианта. Прокоментируйте пожалуйста. 
---

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

#### Ответ:

---
Система может соответствовать частично принципам ACID и частично BASE т.к. это граничащие требования от надежной до быстрой системы включающией в себя несколько принципов, которые могут быть выполнены в разных объемах.

---

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

#### Ответ:

---
Redis - key-value СУБД с возможностями Pub\sub системы. В случае с Redis минусом будет то, что данные хранятся в оперативной памяти и могут быть потеряны.

---