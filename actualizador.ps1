#definimos las versiones.
$org = "E:\Respaldos\"
$dest = "E:\vm\gitlab\"
$versiones = @("13.5.3","13.8.8","13.12.15","14.0.12","14.3.6","14.9.5","14.10.5","15.0.5","15.4.6","15.9.1")
foreach ($version in $versiones) {
	echo "Actualizando a "$version
	# Escapamos el $ porque es parte del nombre de la variable
	$f = '\$version'  
	# Copiamos el modelo a destino
	Copy-Item $org"docker-compose-modelo.yml" -Destination $dest"docker-compose.yml"
	# y substituimos la variable por la version de la imagen.
	(Get-Content -Path $dest"docker-compose.yml") | foreach{$_ -replace $f,$version} | Set-Content $dest"docker-compose.yml"
	# ejecutamos el compose con las variables de entorno
	docker compose --env-file $org"gitlab.env" up -d
	TIMEOUT /T 300
#ejecutar bucle para esperar a fin de migraciones
	do {
		echo esperando fin migraciones
		TIMEOUT /T 30
		$Result=docker exec -it gitlab gitlab-rails runner -e production "puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count"
         
	} While ($Result -ne 0 -or $? -ne 0)
	echo migracion completada
}