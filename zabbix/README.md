# play-with-docker (Zabbix)

Данная ветка предназначена для бесплатного запуска Zabbix на 4 часа

# Быстрый старт:

1.  Логинимся по адресу:

    https://labs.play-with-docker.com/
    
2.  Добавляем инстанс

3.  Копируем url для доступа по ssh 
        
        для примера выглядит так: ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com

4.  На локальном компе запускаем комманду:
        
        $ ./run.sh zabbix ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com
        
        где ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com - это url, 
        скопированный в пункте 3.

5.  Открываем порт 80 через веб-панель (должно перенаправить на Zabbix)

6.  Далее вводим логин/пароль: 
        
        Admin/zabbix
    
    после меняем пароль в панели администратора, если это необходимо
