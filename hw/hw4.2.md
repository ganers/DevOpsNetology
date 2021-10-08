# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
	* Как получить для переменной c значение 12?
	* Как получить для переменной c значение 3?

   #### Ответ:
   ```
   c = a + b - ошибка TypeError
   c = str(a) + b
   c = a + int(b)
   ```
   
2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```

   #### Ответ:
   ```python
    #!/usr/bin/env python3
   
    import os
	
    path = "~/netology/sysadm-homeworks"
    bash_command = [f"cd {path}", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
    for result in result_os.split('\n'):
    	if result.find('modified') != -1:
    		prepare_result = result.replace('\tmodified:   ', '')
    		print(path + "/" + prepare_result)
   ```
   
3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

   #### Ответ:
   ```python
    #!/usr/bin/env python3
    
    import os
    import sys

    if len(sys.argv) > 1:
        path = sys.argv[1]
    else:
        #путь к репозиторию по умолчанию
        path = "~/netology/sysadm-homeworks"

    if os.path.isdir(path + "/.git") == True:
        bash_command = [f"cd {path}", "git status"]
        result_os = os.popen(' && '.join(bash_command)).read()
        is_change = False
        for result in result_os.split('\n'):
            if result.find('modified') != -1:
                prepare_result = result.replace('\tmodified:   ', '')
                print(path + "/" + prepare_result)
    else:
        print(f"{path} не является рпеозиторием")
   ```
   
4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

   #### Ответ:
   ```python
   #!/usr/bin/env python3

    import sys
    import socket
    
    is_checking = False
    
    for arg in sys.argv:
        is_checking = True if arg == '-ch' else False
    
    db_file_path = "db_file.txt"
    
    def get_list_services(file_path):
        services_list = {}
        with open(file_path, 'r') as services_db:
            lines = services_db.readlines()
            for srv_line in lines:
                service = srv_line.split(":")
                services_list[service[0]] = service[1].strip('\n')
        return services_list
    
    def save_list_services(file_path, services_list):
        with open(file_path, 'w') as services_db:
            for service in services_list:
                line_in = f"{service}:{services_list[service]}\n"
                services_db.write(line_in)
    
    services = get_list_services(db_file_path)
    
    for service in services:
        current_ip = socket.gethostbyname(service)
        print(f"{service} - {current_ip}")
    
        if is_checking and current_ip != services[service]:
                print(f"[ERROR] {service} IP mismatch: {services[service]} {current_ip}")
                services[service] = current_ip
    
    save_list_services(db_file_path, services)
   ```
   
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения.

   #### Ответ:
   ```
   
   ```
   