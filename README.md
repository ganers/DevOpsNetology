**[comment]: <> (# DevOpsNetology)

[comment]: <> (Course DevOps from Netology)

[comment]: <> (- ***/.terraform/* - папка .terraform)

[comment]: <> (- *.tfstate - все файлы с расширением .tfstate)

[comment]: <> (- *.tfstate.* - файлы в именах которых встречается .tfstate.)

[comment]: <> (- crash.log - все файлы crash.log)

[comment]: <> (- *.tfvars - все файлы с расширением .tfvars)

[comment]: <> (- override.tf - файлы ovveride.tf)

[comment]: <> (- override.tf.json - файл override.tf.json)

[comment]: <> (- *_override.tf - все файлы заканчивающиеся на _override.tf)

[comment]: <> (- *_override.tf.json - все файлы заканчивающиеся на _override.tf.json)

[comment]: <> (- .terraformrc - файлы с расширением .terraformrc)

[comment]: <> (- terraform.rc - файлы terraform.rc)

####Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
    * $git log --pretty=oneline -1 aefea
	aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md

####Какому тегу соответствует коммит 85024d3?
    * $git log --pretty=oneline -1 85024d3
	85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23) v0.12.23
	Тэг v0.12.23

####Сколько родителей у коммита b8d720? Напишите их хеши.
    * $git log -1 b8d720
	commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
	Merge: 56cd7859e 9ea88f22f
	...
	Хэши родителей 56cd7859e 9ea88f22f
	
	Еще нашел такой вариант поиска родителей коммита git show --pretty=raw b8d720

####Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
	$git log v0.12.23..v0.12.24 --oneline
	33ff1c03b (tag: v0.12.24) v0.12.24
	b14b74c49 [Website] vmc provider links
	3f235065b Update CHANGELOG.md
	6ae64e247 registry: Fix panic when server is unreachable
	5c619ca1b website: Remove links to the getting started guide's old location
	06275647e Update CHANGELOG.md
	d5f9411f5 command: Fix bug when using terraform login on Windows
	4b6d06cc5 Update CHANGELOG.md
	dd01a3507 Update CHANGELOG.md
	225466bc3 Cleanup after v0.12.23 release

####Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
	$git log -S 'func providerSource'
	Смотрим первый коммит по дате создания.
	8c928e83589d90a031f811fae52a81be7153e82f - коммит в котором была создана функция providerSource.

####Найдите все коммиты в которых была изменена функция globalPluginDirs.
	$ git grep --heading globalPluginDirs - ищем файл в котором объявлена функция
	$ git log -L :globalPluginDirs:plugins.go - поиск всех коммитов где была изменена функция
	78b12205587fe839f10d946ea3fdc06719decb05
	52dbf94834cb970b510f2fba853a5b49ad9b1a46
	41ab0aef7a0fe030e84018973a64135b11abcd70
	66ebff90cdfaa6938f26f908c7ebad8d547fea17
	8364383c359a6b738a436d1b7745ccdce178df47
	
####Кто автор функции synchronizedWriters?
	$ git log -S synchronizedWriters - поиск коммитов где встречается функция
	Смотрю по дате (первый коммит):
	commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
	Author: Martin Atkins <mart@degeneration.co.uk>**
