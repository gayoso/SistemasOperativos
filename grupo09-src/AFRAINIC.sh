#!/bin/bash

source AFRAINfunc.sh

function darPermisos {
	chmod 777 "$BINDIR/AFRAINIC.sh"
	chmod 777 "$BINDIR/AFRARECI.sh"
	chmod 777 "$BINDIR/AFRAUMBR.sh"
	chmod 777 "$BINDIR/AFRALIST.pl"
	chmod 777 "$BINDIR/MoverA.sh"
	chmod 777 "$BINDIR/GraLog.sh"
	chmod 777 "$BINDIR/Arrancar.sh"
	chmod 777 "$BINDIR/Detener.sh"
	chmod 777 "$MAEDIR/CdP.mae"
	chmod 777 "$MAEDIR/CdA.mae"
	chmod 777 "$MAEDIR/CdC.mae"
	chmod 777 "$MAEDIR/agentes.mae"
	chmod 777 "$MAEDIR/tllama.tab"
	chmod 777 "$MAEDIR/umbral.tab"
}

if [[ $# != 3 ]]; then
	echo "La sintaxis para correr AFRAINIC es la siguiente: ./AFRAINIC.sh <path a AFRAINST.conf> <path a ejecutables> <path a tablas maestras>"
	echo "Por favor corra de nuevo el script con los parametros correctos"
	exit
fi

PATH_ARCH_CONFIG=$1
# asumo que el path es a la carpeta, no que pasan cada ejecutable como input
BINDIR=$2
# mismo (y que no termina en '/', sino agrego igual pero reemplazo '//' por '/')
MAEDIR=$3

#ver si fue configurado

#variables de ambiente
if [ ! -f $PATH_ARCH_CONFIG ]; then
	echo "El archivo de configuracion indicado no es valido. Por favor correr AFRAINST.sh"
	#log
	exit
fi

export GRUPO=$(grep 'GRUPO=' "$PATH_ARCH_CONFIG" | sed "s/GRUPO=//" | sed "s/=.*//")
export CONFDIR=$(grep 'CONFDIR=' "$PATH_ARCH_CONFIG" | sed "s/CONFDIR=//" | sed "s/=.*//")
export BINDIR=$(grep 'BINDIR=' "$PATH_ARCH_CONFIG" | sed "s/BINDIR=//" | sed "s/=.*//")
export MAEDIR=$(grep 'MAEDIR=' "$PATH_ARCH_CONFIG" | sed "s/MAEDIR=//" | sed "s/=.*//")
export DATASIZE=$(grep 'DATASIZE=' "$PATH_ARCH_CONFIG" | sed "s/DATASIZE=//" | sed "s/=.*//")
export ACEPDIR=$(grep 'ACEPDIR=' "$PATH_ARCH_CONFIG" | sed "s/ACEPDIR=//" | sed "s/=.*//")
export RECHDIR=$(grep 'RECHDIR=' "$PATH_ARCH_CONFIG" | sed "s/RECHDIR=//" | sed "s/=.*//")
export PROCDIR=$(grep 'PROCDIR=' "$PATH_ARCH_CONFIG" | sed "s/PROCDIR=//" | sed "s/=.*//")
export REPODIR=$(grep 'REPODIR=' "$PATH_ARCH_CONFIG" | sed "s/REPODIR=//" | sed "s/=.*//")
export LOGDIR=$(grep 'LOGDIR=' "$PATH_ARCH_CONFIG" | sed "s/LOGDIR=//" | sed "s/=.*//")
export LOGSIZE=$(grep 'LOGSIZE=' "$PATH_ARCH_CONFIG" | sed "s/LOGSIZE=//" | sed "s/=.*//")
export NOVEDIR=$(grep 'NOVEDIR=' "$PATH_ARCH_CONFIG" | sed "s/NOVEDIR=//" | sed "s/=.*//")
export LOGEXT=$(grep 'LOGEXT=' "$PATH_ARCH_CONFIG" | sed "s/LOGEXT=//" | sed "s/=.*//")
export ENTORNO_CONFIGURADO=true

# verificar faltantes en la instalacion, informar, etc
dir_falt=$(verificarDirectorios)
arch_falt=$(verificarArchivos)
if [[ $dir_falt != "" ]] || [[ $arch_falt != "" ]]; then
	echo "Se detectaron faltantes o errores en la instalacion del sistema. Por favor, correr el script AFRAINST.sh antes de continuar"
	echo "Directorios faltantes: $dir_falt"
	echo "Archivos faltantes: $arch_falt"
	exit
fi

# permisos
darPermisos

# ver si arranco AFRARECI
input="asd"
while [[ $input != "Si" ]] && [[ $input != "No" ]]; do
	echo -n "¿Desea efectuar la activacion de AFRARECI? (Si/No): "
	read input
done

if [ $input == "No" ]; then
	echo "Puede arrancar AFRARECI en cualquier momento con el comando 'Arrancar AFRARECI.sh'"
else
	if [ $(pgrep 'AFRARECI.sh' | wc -w) -ge 1 ]; then
		echo "AFRARECI ya esta corriendo, no se puede correr mas de una instancia al mismo tiempo"
	else
		echo "Puede detener AFRARECI en cualquier momento con el comando Detener"
		./Arrancar AFRARECI.sh
	fi
fi



