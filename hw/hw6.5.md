# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

#### Ответ:
[Ссылка на Dockerfile](https://github.com/ganers/DevOpsNetology/blob/main/hw/src/hw6.5/Dockerfile)

[Ссылка на образ на DockerHub](https://hub.docker.com/repository/docker/ganers/elasticsearch)

---
```
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "0Ms21aWoSLOECCAK2CNzVw",
  "version" : {
    "number" : "7.15.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "93d5a7f6192e8a1a12e154a2b81bf6fa7309da0c",
    "build_date" : "2021-11-04T14:04:42.515624022Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```
---

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1 | 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

#### Ответ:

---
Состояние yellow обусловлено тем, что реплики не существуют
```
curl -XGET http://localhost:9200/_cluster/health
{
    "cluster_name":"elasticsearch",
    "status":"yellow",
    "timed_out":false,
    "number_of_nodes":1,
    "number_of_data_nodes":1,
    "active_primary_shards":8,
    "active_shards":8,
    "relocating_shards":0,
    "initializing_shards":0,
    "unassigned_shards":10,
    "delayed_unassigned_shards":0,
    "number_of_pending_tasks":0,
    "number_of_in_flight_fetch":0,
    "task_max_waiting_in_queue_millis":0,
    "active_shards_percent_as_number":44.44444444444444
}

root@netologydevops:/home/ganers# curl -XGET http://localhost:9200/_cat/shards
.geoip_databases 0 p STARTED    42 41.1mb 172.17.0.2 netology_test
ind-3            2 p STARTED     0   208b 172.17.0.2 netology_test
ind-3            2 r UNASSIGNED
ind-3            2 r UNASSIGNED
ind-3            3 p STARTED     0   208b 172.17.0.2 netology_test
ind-3            3 r UNASSIGNED
ind-3            3 r UNASSIGNED
ind-3            1 p STARTED     0   208b 172.17.0.2 netology_test
ind-3            1 r UNASSIGNED
ind-3            1 r UNASSIGNED
ind-3            0 p STARTED     0   208b 172.17.0.2 netology_test
ind-3            0 r UNASSIGNED
ind-3            0 r UNASSIGNED
ind-1            0 p STARTED     0   208b 172.17.0.2 netology_test
ind-2            1 p STARTED     0   208b 172.17.0.2 netology_test
ind-2            1 r UNASSIGNED
ind-2            0 p STARTED     0   208b 172.17.0.2 netology_test
ind-2            0 r UNASSIGNED

root@netologydevops:/home/ganers# curl -XGET http://localhost:9200/_cat/indices
green  open .geoip_databases uQKD9yPyQyeTdk8Qoek-kA 1 0 42 0 41.1mb 41.1mb
green  open ind-1            TdPrweoNT6a_yuRszWijsg 1 0  0 0   208b   208b
yellow open ind-3            kqpHvB0JQna-LvOb2UMQVA 4 2  0 0   832b   832b
yellow open ind-2            l7JZBASkQpyJlU1LTD3wVg 2 1  0 0   416b   416b

curl -XDELETE localhost:9200/_all
```
---

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

#### Ответ:

---
```
curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-7.15.2/snapshot/netology_backup",
    "compress": true
  }
}
'
{
  "acknowledged" : true
}

curl -X GET localhost:9200/_cat/indices
green open .geoip_databases uQKD9yPyQyeTdk8Qoek-kA 1 0 42 0 41.1mb 41.1mb
green open test             pYLphD2oSfqY53SeB1HJgQ 1 0  0 0   208b   208b

curl -X PUT "localhost:9200/_snapshot/netology_backup/test_snapshot?pretty"
{
  "accepted" : true
}

[elastic@9500d4ec1260 /]$ ll /elasticsearch-7.15.2/snapshot/netology_backup/
total 28
-rw-r--r-- 1 elastic elastic  831 Dec 10 08:47 index-0
-rw-r--r-- 1 elastic elastic    8 Dec 10 08:47 index.latest
drwxr-xr-x 4 elastic elastic 4096 Dec 10 08:47 indices
-rw-r--r-- 1 elastic elastic 9366 Dec 10 08:47 meta-Bwq2K7spS_O9Rv7OMzWm1g.dat
-rw-r--r-- 1 elastic elastic  354 Dec 10 08:47 snap-Bwq2K7spS_O9Rv7OMzWm1g.dat

root@netologydevops:/home/ganers# curl -X GET localhost:9200/_cat/indices
green open test-2           3TAOLGvxTgCiqEEKZB5zJA 1 0  0 0   208b   208b
green open .geoip_databases uQKD9yPyQyeTdk8Qoek-kA 1 0 42 0 41.1mb 41.1mb

curl -X POST "localhost:9200/_snapshot/netology_backup/test_snapshot/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test",
  "feature_states": [ "geoip" ]
}
'

curl -X GET localhost:9200/_cat/indices
green open test-2           3TAOLGvxTgCiqEEKZB5zJA 1 0  0 0   208b   208b
green open .geoip_databases xO3eDMf2QW2fqtDiuHF6UA 1 0 42 0 41.1mb 41.1mb
green open test             2pFglBU3T9y-g27MCtymDg 1 0  0 0   208b   208b

```
---
