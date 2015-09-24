#!/bin/bash
# Asumo que todos los archivos (tanto los script como los maestros y tablas) están en el directorio raíz ($GRUPO) a la hora de ejecutar AFRAINST.sh
# Asumo que AFRAINST.sh se encuentra en $GRUPO

function verificarPerl {
	echo Perl
	return 0
}
function aceptarTerminosYCondiciones {
	echo "************************************************************"
	echo "*            Proceso de Instalación de \"AFRA-I\"            *"
	echo "* Tema I Copyright © Grupo 09 - Segundo Cuatrimestre 2015  *"
	echo "************************************************************"
	echo " A T E N C I O N: Al instalar Ud. expresa aceptar los términos y condiciones del \"ACUERDO DE LICENCIA DE SOFTWARE\" incluido en este paquete. Acepta? Si-No"
	echo
	# line="hola"
	# while [ "$line" != "Si" ] || [ "$line" != "si" ] || [ "$line" != "no" ]
	# do
	# 	read line
	# 	echo "$line"
	# done < "/dev/stdin"
}

function verificarInstalacionCompleta {
	# leer del arch de conf todos los valores de las variables y verificar que esten los archivos pertinentes
	# en caso de que no este completa, ver que esten los archivos en $GRUPO como para completar la instalacion
	echo Instalacion
	return 0
}

GRUPO=`pwd`
CONFDIR=$GRUPO/conf

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
	exit 2
else
	echo "El archivo $archConf existe."
	verificarInstalacionCompleta
fi
