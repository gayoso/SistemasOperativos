#! /bin/bash

function verificarExistenciaArchivo {
	local aux=$(ls -1 "$1" | grep "^$2$")
	if [[ "$aux" == "$2" ]]; then
		return 0
	fi
	return 1
}

function verificarArchivos {
	local archivosFaltantes=""

	verificarExistenciaArchivo "$BINDIR" "AFRAINIC.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRAINIC.sh "
	fi

	verificarExistenciaArchivo "$BINDIR" "AFRARECI.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRARECI.sh "
	fi

	verificarExistenciaArchivo "$BINDIR" "AFRAUMBR.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRAUMBR.sh "
	fi

	verificarExistenciaArchivo "$BINDIR" "AFRALIST.pl"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRALIST.pl "
	fi

	verificarExistenciaArchivo "$BINDIR" "MoverA.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/MoverA.sh "
	fi

	verificarExistenciaArchivo "$BINDIR" "GraLog.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/GraLog.sh "
	fi

	verificarExistenciaArchivo "$BINDIR" "Arrancar.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/Arrancar.sh "
	fi

	verificarExistenciaArchivo "$BINDIR" "Detener.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/Detener.sh "
	fi


	verificarExistenciaArchivo "$MAEDIR" "agentes.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/agentes.mae "
	fi

	verificarExistenciaArchivo "$MAEDIR" "CdA.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/CdA.mae "
	fi

	verificarExistenciaArchivo "$MAEDIR" "CdC.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/CdC.mae "
	fi

	verificarExistenciaArchivo "$MAEDIR" "CdP.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/CdP.mae "
	fi

	verificarExistenciaArchivo "$MAEDIR" "tllama.tab"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/tllama.tab "
	fi

	verificarExistenciaArchivo "$MAEDIR" "umbral.tab"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/umbral.tab "
	fi

	echo "$archivosFaltantes"
}