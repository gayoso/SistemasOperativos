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
	local line="asd"
	reSi='^[Ss][Ii]$'
	reNo='^[Nn][Oo]$'
	while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !("$line" =~ $reNo)]]; do
		echo "Error: debe ingresar 'Si' o 'No'"
		return 0 # Este return despues volarlo, esto es para que sea mas facil seguir de largo
	done < "/dev/stdin"
	line=${line,,} #toLower

	if [[ "$line" == "si" ]]; then
		return 0
	else
		return 1
	fi
}

function verificarNombreDirectorio {
	local aux=""
	local erBarra='^/.*$'
	read aux
	if [[ "$aux" != "" && "$aux" != "conf" ]]; then
		if ! [[ "$aux" =~ $erBarra ]]; then
			echo "$aux"
		else
			#Loguear que no puede empezar con /
			echo "Empieza con barra"
			echo "$1"
		fi
	else
		echo "$1"
	fi
}

function crearDirectorio {
	if [ ! -d "$1" ]; then
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
if [ ! -d "$CONFDIR" ]; then
	echo "El directorio $CONFDIR no existe. Creandolo..."
	mkdir "$CONFDIR" 		
fi

archConf=$CONFDIR/AFRAINST.conf
if [ ! -f "$archConf" ]; then
	echo "El archivo $archConf no existe."
	verificarPerl
	aceptarTerminosYCondiciones
	if [ "$?" -eq 0 ]; then #Si acepto las condiciones
		clear
		confirmarInicio="no"
		while [[ "$confirmarInicio" != "si" ]]; do
			echo "ATENCION: Si se ingresa enter directamente se toma como valor el \"por defecto\" provisto entre parentesis."
			echo "ATENCION: Todo directorio ingresado sera relativo a \$GRUPO:$GRUPO"
			echo
			aux=""
			erBarra='^/.*$'
			echo 'Defina el directorio de instalación de los ejecutables ($GRUPO/'"$BINDIR):"
			BINDIR=$(verificarNombreDirectorio "$BINDIR")
			# read aux
			# if [[ "$aux" != "" && "$aux" != "conf" ]]; then
			# 	if ! [[ "$aux" =~ $erBarra ]]; then
			# 		BINDIR=$aux
			# 	else
			# 		#Loguear que no puede empezar con /
			# 		echo "Empieza con barra"
			# 	fi
			# fi
			echo 'Defina el directorio para maestros y tablas ($GRUPO/'"$MAEDIR):"
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					MAEDIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			echo 'Defina el directorio de recepción de archivos de llamadas ($GRUPO/'"$NOVEDIR):"
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					NOVEDIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			echo "Defina espacio mínimo libre para la recepción de archivos de llamadas en Mbytes ($DATASIZE):"
			read aux
			if [[ "$aux" != "" ]]; then
				re='^[0-9]+$'
				if ! [[ "$aux" =~ $re ]] ; then
					# loguear que como no es un numero (O es con coma u negativo) se toma el por defecto
					echo "error: Not a number"
				else
					if [[ "$aux" -gt 0 ]]; then
						DATASIZE=$aux
					else
						# loguear que es igual a 0
						echo "Es igual a 0"
					fi
				fi
			fi

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
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					ACEPDIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			echo 'Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/'"$PROCDIR):"
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					PROCDIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			echo 'Defina el directorio de grabación de los reportes ($GRUPO/'"$REPODIR):"
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					REPODIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			echo 'Defina el directorio para los archivos de log ($GRUPO/'"$LOGDIR):"
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					LOGDIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			echo "Defina el nombre para la extensión de los archivos de log ($LOGEXT):"
			read aux
			if [[ "$aux" != "" ]]; then
				if [[ ${#aux} -gt 5 ]]; then
					# loguear que es mayor a 5
					echo ${#aux}
				else
					LOGEXT=$aux
				fi
			fi
			echo "Defina el tamaño máximo para cada archivo de log en KBytes ($LOGSIZE):"
			read aux
			if [[ "$aux" != "" ]]; then
				re='^[0-9]+$'
				if ! [[ "$aux" =~ $re ]] ; then
					# loguear que como no es mayor a 0 o no es un numero se toma el por defecto
					echo "error: Not a number"
				else
					if [[ "$aux" -gt 0 ]]; then
						LOGSIZE=$aux
					else
						echo "No es mayor a 0"
					fi
				fi
			fi
			echo 'Defina el directorio de grabación de archivos rechazados ($GRUPO/'"$RECHDIR):"
			read aux
			if [[ "$aux" != "" && "$aux" != "conf" ]]; then
				if ! [[ "$aux" =~ $erBarra ]]; then
					RECHDIR=$aux
				else
					#Loguear que no puede empezar con /
					echo "Empieza con barra"
				fi
			fi
			clear
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
			# while read line && [[ "$line" != "Si" ]] && [[ "$line" != "No" ]]; do #TODO: Ver si con la expresion regular reSi se puede hacer que se pueda ingresar Si, SI, sI, si
				echo "Error: debe ingresar 'Si' o 'No'"
			done < "/dev/stdin"
			line=${line,,} #toLower
			confirmarInicio=$line
			clear
			# if [[ "$confirmarInicio" == "No" ]]; then
			# 	clear
			# fi
		done

		echo "Iniciando Instalacion. Esta Ud. seguro? (Si - No)"
		reSi='^[Ss][Ii]$'
		reNo='^[Nn][Oo]$'
		while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !("$line" =~ $reNo)]]; do
			echo "Error: debe ingresar 'Si' o 'No'"
		done < "/dev/stdin"
		echo
		line=${line,,} #toLower
		if [[ "$line" == "si" ]]; then
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

	exit 2
else
	echo "El archivo $archConf existe."
	verificarInstalacionCompleta

fi
#cerrarLog