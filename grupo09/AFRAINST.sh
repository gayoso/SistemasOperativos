#!/bin/bash
# Asumo que todos los archivos (tanto los script como los maestros y tablas) están en el directorio raíz ($GRUPO) a la hora de ejecutar AFRAINST.sh
# Asumo que AFRAINST.sh se encuentra en $GRUPO

function verificarPerl {
	echo Perl
	return 0
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

function verificarInstalacionCompleta {
	# leer del arch de conf todos los valores de las variables y verificar que esten los archivos pertinentes
	# en caso de que no este completa, ver que esten los archivos en $GRUPO como para completar la instalacion
	echo "Instalacion"
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
	return 0
}

GRUPO=$(pwd)
CONFDIR=$GRUPO/conf
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

# Por enunciado $GRUPO/conf ya deberia estar creado, pero chequeo por las dudas
# Utilizo comillas para evitar problemas con directorios con espacios
if [[ ! -d "$CONFDIR" ]]; then
	echo "El directorio $CONFDIR no existe. Creandolo..."
	mkdir "$CONFDIR" 		
fi

archConf=$CONFDIR/AFRAINST.conf
if [[ ! -f "$archConf" ]]; then
	echo "El archivo $archConf no existe."
	verificarPerl
	aceptarTerminosYCondiciones
	if [[ "$?" -eq 0 ]]; then #Si acepto las condiciones
		clear
		confirmarInicio="no"
		while [[ "$confirmarInicio" != "si" ]]; do
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
			disponibleMB=$((disponibleKB/1024))
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

			clear
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

		if [[ "$rta" == "si" ]]; then
			echo "Creando estructuras de directorio..."
			crearDirectorios
			echo "Instalando programas y funciones"
			# Mover los ejecutables y funciones al directorio BINDIR
			# ./MoverA.sh "$GRUPO/AFRAINIC.sh" "$GRUPO/$BINDIR"
			# "$GRUPO/MoverA.sh" "$GRUPO/AFRAINIC.sh" "$GRUPO/$BINDIR"
			echo "Instalando archivos Maestros y Tablas"
			# Mover los archivos maestros y tablas a MAEDIR
			echo "Actualizando la configuracion del sistema"
			# Se debe almacenar la información de configuración del sistema en el archivo AFRAINST.conf en
			# CONFDIR grabando un registro para cada una de las variables indicadas durante este proceso.
			actualizarConfiguracion
			echo "Instalacion concluida."
		fi
	else
		echo "Condiciones no aceptadas"
	fi
else
	echo "El archivo $archConf existe."
	verificarInstalacionCompleta
fi
#cerrarLog