@echo off
REM este script sube la version del gitlab de la 13.5.3 a la ultima version en el momento de escribirlo , 15.7.5. Para ver las versiones necesarias para migrar a ultima plataforma , mirar https://gitlab-com.gitlab.io/support/toolbox/upgrade-path/?current=13.5.7&distro=docker&auto=true&edition=ce
cd E:\VM\gitlab\
copy E:\Respaldos\01-docker-compose_13_8_8.yml E:\VM\gitlab\docker-compose.yml /Y 
echo %DATE% %TIME% Levantando v 13.8.8
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos 10 minutos para que haga sus migraciones
TIMEOUT /T 600 /nobreak
rem echo copia seguridad
rem docker exec -it gitlab gitlab-rake gitlab:backup:create
copy E:\Respaldos\02-docker-compose_13_12_15.yml E:\VM\gitlab\docker-compose.yml /Y 
echo %DATE% %TIME% Levantando v 13.12.15
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos 10 minutos para que haga sus migraciones
TIMEOUT /T 600
docker exec -it gitlab chmod 0600 /etc/gitlab/gitlab-secrets.json /etc/gitlab/gitlab.rb | bash
docker exec -it gitlab chmod 0700 /etc/gitlab/*_key | bash


copy E:\Respaldos\03-docker-compose_14_0_12.yml E:\VM\gitlab\docker-compose.yml /Y 
echo %DATE% %TIME% Levantando v 14.0.12
docker compose --env-file %org%\gitlab.env up -d
REM Esperamos un par de minutos para que haya un bash y se hayan montado las particiones para asegurar los permisos.
echo 11 - Esperamos 5 minutos para iniciar
TIMEOUT /T 300
docker exec -it gitlab chmod 0600 /etc/gitlab/gitlab-secrets.json /etc/gitlab/gitlab.rb | bash
docker exec -it gitlab chmod 0700 /etc/gitlab/*_key | bash
echo Esperamos 5 minutos mas para asegurar
TIMEOUT /T 300
:migracionespendientes_14_0_12
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_14_0_12
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_14_0_12
  GOTO migracionespendientes_14_0_12
 )
 :migrado_14_0_12

copy E:\Respaldos\04-docker-compose_14_3_6.yml E:\VM\gitlab\docker-compose.yml /Y
echo %DATE% %TIME% Levantando v 14.3.6
docker compose --env-file %org%\gitlab.env up -d
REM Esperamos un par de minutos para que haya un bash y se hayan montado las particiones para asegurar los permisos.
echo 11 - Esperamos 5 minutos para que haga sus migraciones
TIMEOUT /T 300
:migracionespendientes_14_3_6
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_14_3_6
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_14_3_6
  GOTO migracionespendientes_14_3_6
 )
 :migrado_14_3_6

copy E:\Respaldos\05-docker-compose_14_9_5.yml E:\VM\gitlab\docker-compose.yml /Y
echo %DATE% %TIME% Levantando v 14.9.5
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos Esperamos 5 minutos para que haga sus migraciones
TIMEOUT /T 300
:migracionespendientes_14_9_5
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_14_9_5
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_14_9_5
  GOTO migracionespendientes_14_9_5
 )
 :migrado_14_9_5

copy E:\Respaldos\06-docker-compose_14_10_5.yml E:\VM\gitlab\docker-compose.yml /Y
echo %DATE% %TIME% Levantando v 14.10.5
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos Esperamos 5 minutos para que haga sus migraciones
TIMEOUT /T 300
:migracionespendientes_14_10_5
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_14_10_5
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_14_10_5
  GOTO migracionespendientes_14_10_5
 )
 :migrado_14_10_5

copy E:\Respaldos\07-docker-compose_15_0_5.yml E:\VM\gitlab\docker-compose.yml /Y
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos Esperamos 5 minutos para que haga sus migraciones
TIMEOUT /T 300
:migracionespendientes_15_0_5
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_15_0_5
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_15_0_5
  GOTO migracionespendientes_15_0_5
 )
 :migrado_15_0_5


copy E:\Respaldos\08-docker-compose_15_4_6.yml E:\VM\gitlab\docker-compose.yml /Y
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos Esperamos 5 minutos para que haga sus migraciones
TIMEOUT /T 300
:migracionespendientes_15_4_6
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_15_4_6
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_15_4_6
  GOTO migracionespendientes_15_4_6
 )
 :migrado_15_4_6


copy E:\Respaldos\10-docker-compose_15_9_1.yml E:\VM\gitlab\docker-compose.yml /Y
docker compose --env-file %org%\gitlab.env up -d
echo 11 - Esperamos Esperamos 5 minutos para que haga sus migraciones
TIMEOUT /T 300
:migracionespendientes_15_9_1
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  if %%F EQU 0 GOTO migrado_15_9_1
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado_15_9_1
  GOTO migracionespendientes_15_9_1
 )
 :migrado_15_9_1
docker exec -it gitlab gitlab-rake gitlab:backup:create

cd E:\Respaldos

echo %DATE% %TIME% Paramos tras ultima copia de seguridad.
