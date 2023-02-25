@echo off
cls
SET "org=g:\Respaldos"
SET "dest=G:\VM\gitlab"
cd %dest%
REM Intentamos poner bien permisos en la instancia actual antes de intentar el update
docker exec -it gitlab chmod 0600 /etc/gitlab/gitlab-secrets.json /etc/gitlab/gitlab.rb | bash
docker exec -it gitlab chmod 0700 /etc/gitlab/*_key | bash
dir /b %org%\*-docker-compose_*.yml
FOR /F "tokens=*" %%G IN ('dir /b %org%\*-docker-compose_*.yml') DO (
 echo "%org%\%%G" 
 copy "%org%\%%G" %dest%\docker-compose.yml /Y 
 echo %DATE% %TIME% Levantando v %%G
 REM Usamos un unico fichero de configuracion para guardar las rutas de todos los composes.
 docker compose --env-file %org%\gitlab.env up -d
 if %%G==01-docker-compose_13_8_8.yml goto nomigracion
 if %%G==02-docker-compose_13_12_15.yml goto nomigracion
 echo consultamos cada 30 segundos para que haga sus migraciones
:migracionespendientes
 TIMEOUT /T 30 /nobreak
 REM Sacado de https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
 FOR /F "tokens=* USEBACKQ" %%F IN (`docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"`) DO (
  SET pendientes=%%F
  echo %%F tareas pendientes
  if %%F==0 GOTO migrado
  REM Si el comando resulta en error , es una version que no tiene migraciones , asi que hemos terminado tambien
  IF %ERRORLEVEL% NEQ 0 goto migrado
  GOTO migracionespendientes
 )
:nomigracion
 echo Versiones que no necesitan hacer migraciones , esperamos 10 minutos a que esten estabilizadas
 TIMEOUT /T 600 /nobreak
:migrado
 echo copia seguridad
 docker exec -it gitlab gitlab-rake gitlab:backup:create
)
cd %org%