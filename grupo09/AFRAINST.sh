#!/bin/bash
# Asumo que todos los archivos (tanto los script como los maestros y tablas) están en el directorio raíz ($GRUPO) a la hora de ejecutar AFRAINST.sh
# Asumo que AFRAINST.sh se encuentra en $GRUPO

function log {
	if [[ -f GraLog.sh ]]; then
		if [[ ! -x GraLog.sh ]]; then
			chmod +x GraLog.sh
		fi
		./GraLog.sh "AFRAINST" "$1" "$2" #1= log message, 2= log level
	fi
}

function logInfo {
	echo "[INFO] $1"
	log "$1" "INFO"
}
function logError {
	echo "[ERROR] $1"
	log "$1" "ERR"
}

function logWar {
	echo "[WARNING] $1"
	log "$1" "WAR"
}

function verificarPerl {
	if perl < /dev/null &>/dev/null; then # Si perl esta instalado...
		# local perlinfo=`perl -v | grep '.' | head -n 1`
		local perlVersion=$(echo `perl -v` | grep 'This is perl ' | sed "s/This is perl //" | sed "s/[^0-9].*//")
		if [[ perlVersion != "" && perlVersion -ge 5 ]]; then
			return 0
		fi
		return 1
	fi
	return 1
}

function aceptarTerminosYCondiciones {
	#TODO: Loguear
	echo "********************************************************************************"
	echo "*                      Proceso de Instalación de \"AFRA-I\"                      *"
	echo "*           Tema I Copyright © Grupo 09 - Segundo Cuatrimestre 2015            *"
	echo "********************************************************************************"
	echo " A T E N C I O N: Al instalar Ud. expresa aceptar los términos y condiciones del \"ACUERDO DE LICENCIA DE SOFTWARE\" incluido en este paquete. Acepta? Si - No"
	local respuesta="asd"
	local reSi='^[Ss][Ii]$'
	local reNo='^[Nn][Oo]$'
	while read respuesta && [[ !( "$respuesta" =~ $reSi ) ]] && [[ !("$respuesta" =~ $reNo)]]; do
		echo "Error: debe ingresar 'Si' o 'No'"
		return 0 # Este return despues volarlo, esto es para que sea mas facil seguir de largo
	done < "/dev/stdin"
	respuesta=${respuesta,,} #toLower

	if [[ "$respuesta" == "si" ]]; then
		return 0
	else
		return 1
	fi
}

function verificarNombreDirectorio {
	local aux=""
	local reBarra='^/.*$'
	read aux
	if [[ "$aux" != "" && "$aux" != "conf" ]]; then
		if ! [[ "$aux" =~ $reBarra ]]; then
			echo "$aux"
		else
			# Loguear que no puede empezar con /
			echo "$1"
		fi
	else
		echo "$1"
	fi
}

function verificarNumero {
	local aux=""
	read aux
	reNum='^[0-9]+$'
	if [[ "$aux" != "" ]]; then
		if ! [[ "$aux" =~ $reNum ]] ; then
			# No es un numero: loguear que como no es mayor a 0 o no es un numero se toma el por defecto
			echo "$1"
		else
			if [[ "$aux" -gt 0 ]]; then
				echo "$aux"
			else
				# Es 0: loguear que como es 0, se toma el por defecto
				echo "$1"
			fi
		fi
	else
		echo "$1"
	fi
}

function definirDirectorios {
	echo "ATENCION: Si se ingresa enter directamente se toma como valor el \"por defecto\" provisto entre parentesis."
	echo "ATENCION: Todo directorio ingresado sera relativo a \$GRUPO:$GRUPO"
	echo
	echo 'Defina el directorio de instalación de los ejecutables ($GRUPO/'"$BINDIR):"
	BINDIR=$(verificarNombreDirectorio "$BINDIR")
	echo 'Defina el directorio para maestros y tablas ($GRUPO/'"$MAEDIR):"
	MAEDIR=$(verificarNombreDirectorio "$MAEDIR")
	echo 'Defina el directorio de recepción de archivos de llamadas ($GRUPO/'"$NOVEDIR):"
	NOVEDIR=$(verificarNombreDirectorio "$NOVEDIR")
	echo "Defina espacio mínimo libre para la recepción de archivos de llamadas en Mbytes ($DATASIZE):"
	DATASIZE=$(verificarNumero "$DATASIZE")
	# Chequear si en NOVEDIR hay DATASIZE MB libres
	disponibleKB=$(df -k "$GRUPO"| tail -1 | awk '{print $4}')
	disponibleMB=$(($disponibleKB/1024))
	echo "$disponibleMB"
	#O en un while???
	if [[ "$disponibleMB" -gt "$DATASIZE" ]]; then
		echo "Espacio OK."
	else
		#Loguear
		echo "Espacio insuficiente."
	fi

	echo 'Defina el directorio de grabación de los archivos de llamadas aceptadas ($GRUPO/'"$ACEPDIR):"
	ACEPDIR=$(verificarNombreDirectorio "$ACEPDIR")
	echo 'Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/'"$PROCDIR):"
	PROCDIR=$(verificarNombreDirectorio "$PROCDIR")
	echo 'Defina el directorio de grabación de los reportes ($GRUPO/'"$REPODIR):"
	REPODIR=$(verificarNombreDirectorio "$REPODIR")
	echo 'Defina el directorio para los archivos de log ($GRUPO/'"$LOGDIR):"
	LOGDIR=$(verificarNombreDirectorio "$LOGDIR")
	echo "Defina el nombre para la extensión de los archivos de log ($LOGEXT):"
	aux=""
	read aux
	rePunto='^\..*$'
	if [[ "$aux" != "" ]]; then
		if ! [[ "$aux" =~ $rePunto ]]; then
			if [[ ${#aux} -gt 5 ]]; then
				# loguear que es mayor a 5
				echo Longitud extension: ${#aux}
			else
				LOGEXT=$aux
			fi
		else
			#Loguear: Empieza con punto!!
			echo "Empieza con punto..."
		fi
	fi

	echo "Defina el tamaño máximo para cada archivo de log en KBytes ($LOGSIZE):"
	LOGSIZE=$(verificarNumero "$LOGSIZE")
	echo 'Defina el directorio de grabación de archivos rechazados ($GRUPO/'"$RECHDIR):"
	RECHDIR=$(verificarNombreDirectorio "$RECHDIR")
}

function instalacionLista {
	echo "RECORDAR: Todo directorio es relativo a $GRUPO"
	echo
	echo "Directorio de ejecutables: $BINDIR"
	echo "Directorio de maestros y tablas: $MAEDIR"
	echo "Directorio de recepción de archivos de llamadas: $NOVEDIR"
	echo "Espacio minimo libre para arribos: $DATASIZE MB"
	echo "Directorio de archivos de llamadas aceptados: $ACEPDIR"
	echo "Directorio de archivos de llamadas sospechosas: $PROCDIR"
	echo "Directorio de archivos de reportes de llamadas: $REPODIR"
	echo "Directorio de archivos de log: $LOGDIR"
	echo "Extension para los archivos de log: .$LOGEXT"
	echo "Tamaño maximo para los archivos de log: $LOGSIZE KB"
	echo "Directorio de archivos rechazados: $RECHDIR"
	echo "Estado de la instalacion: LISTA"
	echo "Desea continuar con la instalación? (Si - No)"
}

function crearDirectorio {
	if [[ ! -d "$1" ]]; then
		mkdir -p "$1"
	fi
	echo "$GRUPO/$1"
}

function crearDirectorios {
	crearDirectorio "$BINDIR"
	crearDirectorio "$MAEDIR"
	crearDirectorio "$NOVEDIR"
	crearDirectorio "$ACEPDIR"
	crearDirectorio "$PROCDIR"
	crearDirectorio "$PROCDIR/proc"
	crearDirectorio "$REPODIR"
	crearDirectorio "$LOGDIR"
	crearDirectorio "$RECHDIR"
	crearDirectorio "$RECHDIR/llamadas"
}

function copiarArchivo {
	if [[ -f "$1" ]]; then
		if [[ ! -f "$2/$1" ]]; then
			cp "$1" "$2"
		else #Este else vuela
			echo "El archivo $1 ya existe en /$2"
			#return 1
		fi
	else
		echo "El archivo $1 no existe, por lo que no se ha podido copiar a /$2."
		return 1
	fi
	return 0
}

function copiarEjecutables {
	if [ -f MoverA.sh ]; then
		if [ ! -x MoverA.sh ]; then
			chmod +x MoverA.sh
		fi
		./MoverA.sh "$GRUPO/AFRAINIC.sh" "$GRUPO/$BINDIR"
	fi
	local resultado=0
	copiarArchivo 'AFRAINIC.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'AFRARECI.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'AFRAUMBR.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'AFRALIST.pl' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'MoverA.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'GraLog.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'Arrancar.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'Detener.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	return "$resultado"
}
function copiarMaestrosYTablas {
	local resultado=0
	copiarArchivo 'agentes.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'CdA.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'CdC.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'CdP.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'tllama.tab' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'umbral.tab' "$MAEDIR"
	resultado=$(($resultado+$?))
	return "$resultado"
}

function instalar {
	local resultado=0
	echo "Creando estructuras de directorio..."
	crearDirectorios
	echo "Instalando programas y funciones"
	copiarEjecutables
	resultado=$(($resultado+$?))
	echo "Instalando archivos Maestros y Tablas"
	copiarMaestrosYTablas
	resultado=$(($resultado+$?))
	echo "Actualizando la configuracion del sistema"
	actualizarConfiguracion
	if [[ "$resultado" -gt 0 ]]; then
		echo "La instalacion ha tenido un error y no ha podido terminar con exito. Revise el log para mas informacion."
	else
		echo "Instalacion concluida satisfactoriamente."
	fi
	return "$resultado"
}

function actualizarConfiguracion {
	# Recordar que todo directorio es relativo a $GRUPO siempre
	# TODO: Que onda lo del login del usuario??? Por ahora lo harcodeo
	echo "GRUPO=$GRUPO=alumnos=$(date +"%d-%m-%Y %T")" > "$CONFDIR/AFRAINST.conf" # Sobrescribo si ya hay algo
	echo "CONFDIR=$CONFDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf" # Append
	echo "BINDIR=$BINDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "MAEDIR=$MAEDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "DATASIZE=$DATASIZE=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "ACEPDIR=$ACEPDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "RECHDIR=$RECHDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "PROCDIR=$PROCDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "REPODIR=$REPODIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "LOGDIR=$LOGDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "LOGSIZE=$LOGSIZE=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "NOVEDIR=$NOVEDIR=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "LOGEXT=$LOGEXT=alumnos=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
}
function obtenerVariablesDeArchivoConf {
	GRUPO=$(grep 'GRUPO=' "$archConf" | sed "s/GRUPO=//" | sed "s/=.*//")
	CONFDIR=$(grep 'CONFDIR=' "$archConf" | sed "s/CONFDIR=//" | sed "s/=.*//")
	BINDIR=$(grep 'BINDIR=' "$archConf" | sed "s/BINDIR=//" | sed "s/=.*//")
	MAEDIR=$(grep 'MAEDIR=' "$archConf" | sed "s/MAEDIR=//" | sed "s/=.*//")
	DATASIZE=$(grep 'DATASIZE=' "$archConf" | sed "s/DATASIZE=//" | sed "s/=.*//")
	ACEPDIR=$(grep 'ACEPDIR=' "$archConf" | sed "s/ACEPDIR=//" | sed "s/=.*//")
	RECHDIR=$(grep 'RECHDIR=' "$archConf" | sed "s/RECHDIR=//" | sed "s/=.*//")
	PROCDIR=$(grep 'PROCDIR=' "$archConf" | sed "s/PROCDIR=//" | sed "s/=.*//")
	REPODIR=$(grep 'REPODIR=' "$archConf" | sed "s/REPODIR=//" | sed "s/=.*//")
	LOGDIR=$(grep 'LOGDIR=' "$archConf" | sed "s/LOGDIR=//" | sed "s/=.*//")
	LOGSIZE=$(grep 'LOGSIZE=' "$archConf" | sed "s/LOGSIZE=//" | sed "s/=.*//")
	NOVEDIR=$(grep 'NOVEDIR=' "$archConf" | sed "s/NOVEDIR=//" | sed "s/=.*//")
	LOGEXT=$(grep 'LOGEXT=' "$archConf" | sed "s/LOGEXT=//" | sed "s/=.*//")
}

function verificarExistencia {
	local aux=$(ls -1 "$1" | grep "$2")
	if [[ "$aux" == "$2" ]]; then
		return 0
	fi
	return 1
}

function verificarArchivos {
	local archivosFaltantes=""
	verificarExistencia "$BINDIR" "AFRAINIC.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRAINIC.sh "
	fi
	verificarExistencia "$BINDIR" "AFRARECI.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRARECI.sh "
	fi
	verificarExistencia "$BINDIR" "AFRAUMBR.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRAUMBR.sh "
	fi
	verificarExistencia "$BINDIR" "AFRALIST.pl"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRALIST.pl "
	fi
	verificarExistencia "$BINDIR" "MoverA.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/MoverA.sh "
	fi
	verificarExistencia "$BINDIR" "GraLog.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/GraLog.sh "
	fi
	verificarExistencia "$BINDIR" "Arrancar.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/Arrancar.sh "
	fi
	verificarExistencia "$BINDIR" "Detener.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/Detener.sh "
	fi
	echo "$archivosFaltantes"
}

function listarCarpetasYVerificarArchivos {
	echo "Directorio de Configuración: $CONFDIR"
	echo `ls -1 "$CONFDIR"`
	echo "Directorio de Ejecutables: $GRUPO/$BINDIR"
	echo `ls -1 "$BINDIR"`
	echo "Directorio de Maestros y Tablas: $GRUPO/$MAEDIR"
	echo `ls -1 "$MAEDIR"`
	echo "Directorio de recepcion de archivos de llamadas: $GRUPO/$NOVEDIR"
	echo "Directorio de archivos de llamadas Aceptados: $GRUPO/$ACEPDIR"
	echo "Directorio de archivos de llamadas Sospechosas: $GRUPO/$PROCDIR"
	echo "Directorio de archivos de reportes de llamadas: $GRUPO/$REPODIR"
	echo "Directorio de archivos de Log: $GRUPO/$LOGDIR"
	echo `ls -1 "$LOGDIR"`
	echo "Directorio de archivos Rechazados: $GRUPO/$RECHDIR"
	local archivosFaltantes=$(verificarArchivos)
	if [[ "$archivosFaltantes" == "" ]]; then #No hay faltantes
		echo "Estado de la instalacion: COMPLETA"
		echo "Proceso de instalacion finalizado."
	else
		echo "Estado de la instalacion: INCOMPLETA"
		echo "Componentes faltantes: $archivosFaltantes"
		echo "Desea completar la instalacion? (Si - No)"
		local reSi='^[Ss][Ii]$'
		local reNo='^[Nn][Oo]$'
		local line="asd"
		while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !("$line" =~ $reNo)]]; do
			echo "Error: debe ingresar 'Si' o 'No'"
		done < "/dev/stdin"
		line=${line,,} #toLower
		clear
		if [[ "$line" == "si" ]]; then
			instalar
			if [[ "$?" -eq 0 ]]; then
				listarCarpetasYVerificarArchivos # Al llamar aca no deberia suceder de que haya archivos faltantes, ya que me fije si fue satisfactoria la instalacion
			fi
		fi
	fi
}

# Asumo que el archivo de configuracion esta bien escrito (No hay que volver a verificar)
function verificarInstalacionCompleta {
	# leer del arch de conf todos los valores de las variables y verificar que esten los archivos pertinentes
	# en caso de que no este completa, ver que esten los archivos en $GRUPO como para completar la instalacion
	obtenerVariablesDeArchivoConf
	listarCarpetasYVerificarArchivos
	return 0
}

GRUPO=$(pwd)
CONFDIR=conf
BINDIR=bin
MAEDIR=mae
NOVEDIR=novedades
DATASIZE=100
ACEPDIR=aceptadas
PROCDIR=sospechosas
REPODIR=reportes
LOGDIR=log
LOGEXT=log
LOGSIZE=400
RECHDIR=rechazadas

#Como todavia no tengo la ruta del log, lo creo en cualquier lado y al final lo moveré a la carpeta correspondiente

# Por enunciado $GRUPO/conf ya deberia estar creado, pero chequeo por las dudas
# Utilizo comillas para evitar problemas con directorios con espacios
if [[ ! -d "$CONFDIR" ]]; then
	echo "El directorio $CONFDIR no existe. Creandolo..."
	mkdir "$CONFDIR" 		
fi

archConf=$CONFDIR/AFRAINST.conf
if [[ ! -f "$archConf" ]]; then #Si no existe el archivo $archConf
	verificarPerl
	if [[ "$?" -eq 0 ]]; then #Si Perl esta instalado
		echo 'Perl Version:'`perl -v`
		aceptarTerminosYCondiciones
		if [[ "$?" -eq 0 ]]; then #Si acepto las condiciones
			clear
			confirmarInicio="no"
			while [[ "$confirmarInicio" != "si" ]]; do
				definirDirectorios
				clear
				instalacionLista

				line="asd"
				reSi='^[Ss][Ii]$'
				reNo='^[Nn][Oo]$'
				while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !("$line" =~ $reNo)]]; do
					echo "Error: debe ingresar 'Si' o 'No'"
				done < "/dev/stdin"
				confirmarInicio=${line,,} #toLower
				clear
			done
			echo "Iniciando Instalacion. Esta Ud. seguro? (Si - No)"
			line="asd"
			while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !("$line" =~ $reNo)]]; do
				echo "Error: debe ingresar 'Si' o 'No'"
			done < "/dev/stdin"
			rta=${line,,} #toLower
			echo
			if [[ "$rta" == "si" ]]; then
				instalar
			fi
		else
			echo "Condiciones no aceptadas"
		fi
	else
		echo "Para ejecutar el sistema AFRA-I es necesario contar con Perl 5 o superior."
		echo "Efectue su instalacion e intentelo nuevamente."
		echo "Proceso de instalación cancelado."
	fi
else
	verificarInstalacionCompleta
fi
#cerrarLog
