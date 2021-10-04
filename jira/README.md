# play-with-docker (Jira)

Предназначен для бесплатного запуска Jira на 4 часа

# Быстрый старт:

1.  Логинимся по адресу:

    https://labs.play-with-docker.com/
    
2.  Добавляем инстансы

3.  Копируем url для доступа по ssh 
        
        для примера выглядит так: ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com

4.  На локальном компе запускаем комманду:
        
        $ ./deploy.sh jira ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com
        
        где ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com - это url, 
        скопированный в пункте 3.

5.  Открываем порт 80 через веб-панель (должно перенаправить на Jenkins)

6.  Далее следуем инструкциям инсталятора Jira
  