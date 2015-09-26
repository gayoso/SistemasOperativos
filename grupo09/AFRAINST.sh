#!/bin/bash
# Asumo que todos los archivos (tanto los script como los maestros y tablas) están en el directorio raíz ($GRUPO) a la hora de ejecutar AFRAINST.sh
# Asumo que AFRAINST.sh se encuentra en $GRUPO

function verificarPerl {
	echo Perl
	return 0
}
function aceptarTerminosYCondiciones {
	#TODO: Loguear
	echo "************************************************************"
	echo "*            Proceso de Instalación de \"AFRA-I\"            *"
	echo "* Tema I Copyright © Grupo 09 - Segundo Cuatrimestre 2015  *"
	echo "************************************************************"
	echo " A T E N C I O N: Al instalar Ud. expresa aceptar los términos y condiciones del \"ACUERDO DE LICENCIA DE SOFTWARE\" incluido en este paquete. Acepta? Si-No"
	echo
	local line="asd"
	# while [ "$line" != "Si" ] || [ "$line" != "si" ] || [ "$line" != "no" ]; do
	# while [[ $line != "Si" || $line != "No" ]]; do
	while read line && [ "$line" != "Si" ]; do
		echo "Error: debe ingresar 'Si'"
		return 0 #En realidad deberia ser algo != 0, pero para que sea mas rapido
	done < "/dev/stdin"
	return 0
}

function verificarInstalacionCompleta {
	# leer del arch de conf todos los valores de las variables y verificar que esten los archivos pertinentes
	# en caso de que no este completa, ver que esten los archivos en $GRUPO como para completar la instalacion
	echo Instalacion
	return 0
}

GRUPO=`pwd`
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
		echo "Condiciones aceptadas"
		#Hacer que con enter se quede con el por defecto
		echo 'Defina el directorio de instalación de los ejecutables ($GRUPO/'"$BINDIR):"
		read BINDIR
		echo 'Defina el directorio para maestros y tablas ($GRUPO/'"$MAEDIR):"
		read MAEDIR
		echo 'Defina el directorio de recepción de archivos de llamadas ($GRUPO/'"$NOVEDIR):"
		read NOVEDIR
		echo "Defina espacio mínimo libre para la recepción de archivos de llamadas en Mbytes ($DATASIZE):"
		read DATASIZE

		# Chequear si en NOVEDIR hay DATASIZE MB libres
		disponibleKB=$(df -k "$GRUPO"| tail -1 | awk '{print $4}')
		disponibleMB=$((disponibleKB/1024))
		#O en un while???
		if [ "$disponibleMB" -gt "$DATASIZE" ]; then
			echo "Espacio OK."
		else
			#Loguear
			echo "Espacio insuficiente."
		fi

		echo 'Defina el directorio de grabación de los archivos de llamadas aceptadas ($GRUPO/'"$ACEPDIR):"
		read ACEPDIR
		echo 'Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/'"$PROCDIR):"
		read PROCDIR
		echo 'Defina el directorio de grabación de los reportes ($GRUPO/'"$REPODIR):"
		read REPODIR
		echo 'Defina el directorio para los archivos de log ($GRUPO/'"$LOGDIR):"
		read LOGDIR
		echo "Defina el nombre para la extensión de los archivos de log ($LOGEXT):"
		read LOGEXT
		# Chequear de extension menor a 5
		echo "Defina el tamaño máximo para cada archivo de log en KBytes ($LOGSIZE):"
		read LOGSIZE
		echo 'Defina el directorio de grabación de archivos rechazados ($GRUPO/'"$RECHDIR):"
		read RECHDIR
		echo
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
		# Mismo while que dentro de aceptarTerminosYCondiciones
	else
		echo "Condiciones no aceptadas"
	fi

	exit 2
else
	echo "El archivo $archConf existe."
	verificarInstalacionCompleta
fi
#cerrarLog