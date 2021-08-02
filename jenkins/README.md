# play-with-docker (Jenkins)

Данная ветка предназначена для бесплатного запуска Jenkins на 4 часа

# Быстрый старт:

1.  Логинимся по адресу:

    https://labs.play-with-docker.com/
    
2.  Добавляем инстансы

3.  Копируем url для доступа по ssh 
        
        для примера выглядит так: ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com

4.  На локальном компе запускаем комманду:
        
        $ ./run.sh ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com
        
        где ip172-18-0-86-c43q3bvnjsv000cfsdqg@direct.labs.play-with-docker.com - это url, 
        скопированный в пункте 3.

5.  Открываем порт 8080 через веб-панель (должно перенаправить на Jenkins)

6.  Далее следуем инструкциям инсталятора Jenkins

7.  Первоначальный пароль, который  запрашивает Jenkins,
    получаем при помощи комманды:

        docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  