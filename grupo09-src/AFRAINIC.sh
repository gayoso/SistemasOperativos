#!/bin/bash

source AFRAINfunc.sh
AFRAINIC="AFRAINIC"
terminar=false

function darPermisos {
	logEchoInfo $AFRAINIC "Chequeando permisos de archivos"

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

PATH_ARCH_CONFIG="../conf/AFRAINST.conf"

#variables de ambiente
#if [ ! -f $PATH_ARCH_CONFIG ]; then
	#lo dejo para el dev, por si escribimos mal el path
#	logError $AFRAINIC "El archivo de configuracion indicado no es valido. Por favor correr AFRAINST.sh"
#	terminar=true
#fi

if [ $terminar = false ]; then

	export GRUPO=$(grep 'GRUPO=' "$PATH_ARCH_CONFIG" | sed "s/GRUPO=//" | sed "s/=.*//")
	echo "$GRUPO"
	
	PATH_ARCH_CONFIG="$GRUPO"/"conf/AFRAINST.conf"
	echo "$PATH_ARCH_CONFIG"
	
	export CONFDIR="$GRUPO"/$(grep 'CONFDIR=' "$PATH_ARCH_CONFIG" | sed "s/CONFDIR=//" | sed "s/=.*//")
	export BINDIR="$GRUPO"/$(grep 'BINDIR=' "$PATH_ARCH_CONFIG" | sed "s/BINDIR=//" | sed "s/=.*//")
	export MAEDIR="$GRUPO"/$(grep 'MAEDIR=' "$PATH_ARCH_CONFIG" | sed "s/MAEDIR=//" | sed "s/=.*//")
	export DATASIZE=$(grep 'DATASIZE=' "$PATH_ARCH_CONFIG" | sed "s/DATASIZE=//" | sed "s/=.*//")
	export ACEPDIR="$GRUPO"/$(grep 'ACEPDIR=' "$PATH_ARCH_CONFIG" | sed "s/ACEPDIR=//" | sed "s/=.*//")
	export RECHDIR="$GRUPO"/$(grep 'RECHDIR=' "$PATH_ARCH_CONFIG" | sed "s/RECHDIR=//" | sed "s/=.*//")
	export PROCDIR="$GRUPO"/$(grep 'PROCDIR=' "$PATH_ARCH_CONFIG" | sed "s/PROCDIR=//" | sed "s/=.*//")
	export REPODIR="$GRUPO"/$(grep 'REPODIR=' "$PATH_ARCH_CONFIG" | sed "s/REPODIR=//" | sed "s/=.*//")
	export LOGDIR="$GRUPO"/$(grep 'LOGDIR=' "$PATH_ARCH_CONFIG" | sed "s/LOGDIR=//" | sed "s/=.*//")
	export LOGSIZE=$(grep 'LOGSIZE=' "$PATH_ARCH_CONFIG" | sed "s/LOGSIZE=//" | sed "s/=.*//")
	export NOVEDIR="$GRUPO"/$(grep 'NOVEDIR=' "$PATH_ARCH_CONFIG" | sed "s/NOVEDIR=//" | sed "s/=.*//")
	export LOGEXT=$(grep 'LOGEXT=' "$PATH_ARCH_CONFIG" | sed "s/LOGEXT=//" | sed "s/=.*//")
	export ENTORNO_CONFIGURADO=true

	logEchoInfo $AFRAINIC "Creando variables de entorno"


	# verificar faltantes en la instalacion, informar, etc
	logEchoInfo $AFRAINIC "Viendo faltantes en la instalacion"
	dir_falt=$(verificarDirectorios)
	arch_falt=$(verificarArchivos)
	if [[ "$dir_falt" != "" ]] || [[ "$arch_falt" != "" ]]; then
		logEchoError "Se detectaron faltantes o errores en la instalacion del sistema. Por favor, correr el script AFRAINST.sh antes de continuar"
		logEchoWarn "Directorios faltantes: $dir_falt"
		logEchoWarn "Archivos faltantes: $arch_falt"
		terminar=true
	fi
fi

if [ $terminar = false ]; then
	# permisos
	darPermisos

	# ver si arranco AFRARECI
	input="asd"
	while [[ "$input" != "Si" ]] && [[ "$input" != "No" ]]; do
		echo -n "¿Desea efectuar la activacion de AFRARECI? (Si/No): "
		read input
	done

	if [ "$input" == "No" ]; then
		logEchoInfo $AFRAINIC "Puede arrancar AFRARECI en cualquier momento con el comando 'Arrancar AFRARECI.sh'"
	else
		logEchoInfo $AFRAINIC "Puede detener AFRARECI en cualquier momento con el comando Detener"
		./Arrancar.sh "AFRARECI.sh"
	fi
fi



