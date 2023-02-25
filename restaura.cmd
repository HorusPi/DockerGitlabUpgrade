@echo off
cls
SET "org=E:\Respaldos"
SET "dest=E:\VM\gitlab"
SET %ver=13_5_3
echo Dockerfile "%ver%"
echo copiar %org%\Inicial.yml a %dest%\docker-compose.yml"
copy %org%\Inicial.yml %dest%\docker-compose.yml /Y
cd %dest%
echo gitlab up
echo %DATE% %TIME% Levantando v 13.5.3
docker compose --env-file %org%\gitlab.env up -d
echo 5 - Esperamos 20 minutos para que se estabilice el sistema
TIMEOUT /T 1200 /nobreak
echo 6 - copiamos el backup a la carpeta de backups
copy %org%\*.tar %dest%\data\backups /Y
echo Paramos servicios
docker exec -it gitlab gitlab-ctl stop unicorn
TIMEOUT /T 20
docker exec -it gitlab gitlab-ctl stop puma
TIMEOUT /T 20
docker exec -it gitlab gitlab-ctl stop sidekiq
TIMEOUT /T 30
docker exec -it gitlab gitlab-ctl status
TIMEOUT /T 30

echo Lanzamos tarea restauracion
docker exec -it gitlab gitlab-backup restore force=yes
xcopy %org%\etc %dest%\config\ /S /Y
echo ajustamos permisos del production log
docker exec -it gitlab bash -c "chmod 0600 /etc/gitlab/gitlab-secrets.json /etc/gitlab/gitlab.rb"
docker exec -it gitlab bash -c "chmod 0700 /etc/gitlab/*_key"
docker exec -it gitlab bash -c "chmod 0644 /etc/gitlab/*pub"
echo 9 - una vez hecho esto , reiniciamos el gitlab y le damos 10 minutos para que se estabilice
docker restart gitlab
TIMEOUT /T 600 /nobreak
echo Tareas tras la copia.
docker exec -it gitlab gitlab-rake gitlab:check SANITIZE=true
echo Finalizado a las %DATE% %TIME% v 13.5.3
cd %org%
update.cmd