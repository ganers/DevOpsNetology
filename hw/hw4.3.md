# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
	```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
	```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

   #### Ответ:
   ```json
   Не совсем понял что надо сделать, например в первом элементе массива "ip" представлен числом а надо строкой (заключить в кавычки) - а что писать в решении???
   { "info" : "Sample JSON output from our service\\t",
        "elements" : [
            { "name" : "first",
            "type" : "server",
            "ip" : "7175"
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
   ```
   
2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

   #### Ответ:
   ```python
   #!/usr/bin/env python3

    import sys
    import socket
    import json
    import yaml
    
    is_checking = False
    file_type = 'txt'
    
    for arg in sys.argv:
        if arg == '-j':
            file_type = 'json'
        elif arg == '-y':
            file_type = 'yaml'
        elif arg == '-ch':
            is_checking = True
    
    db_name = "db_file"
    
    def get_list_services(file_type):
        data = {}
        with open(db_name + "." + file_type, 'r') as services_db:
            if file_type == 'json':
                data = json.load(services_db)
            elif file_type == 'yaml':
                data = yaml.safe_load(services_db)
            else:
                lines = services_db.readlines()
                for srv_line in lines:
                    service = srv_line.split(":")
                    data[service[0]] = service[1].strip('\n')
        return data
    
    def cheking_services(services):
        for srv_name, srv_ip in services.items():
            current_ip = socket.gethostbyname(srv_name)
            print(f"{srv_name} - {current_ip}")
    
            if is_checking and current_ip != srv_ip:
                print(f"[ERROR] {srv_name} IP mismatch: {srv_ip} {current_ip}")
                services[srv_name] = current_ip
    
    def save_services(services, file_type):
        db_path = db_name + "." + file_type
        if file_type == "txt":
            with open(db_path, 'w') as services_db:
                for service in services:
                    line_in = f"{service}:{services[service]}\n"
                    services_db.write(line_in)
        elif file_type == "json":
            with open(db_path, "w") as services_db:
                data = json.dumps(services)
                services_db.write(data)
        elif file_type == "yaml":
            with open(db_path, "w") as services_db:
                data = yaml.dump(services)
                services_db.write(data)
    
    services = get_list_services(file_type)
    
    cheking_services(services)
    
    save_services(services, file_type)
   ```
   
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

   #### Ответ:
   ```
   
   ```