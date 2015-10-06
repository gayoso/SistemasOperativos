#! /bin/bash

function log {
	if [[ -f GraLog.sh ]]; then
		if [[ ! -x GraLog.sh ]]; then
			chmod +x GraLog.sh
		fi
		./GraLog.sh "$1" "$2" "$3" # 1=nombre del script que loguea, 2=log message, 3=log level
	fi
}

function logEchoInfo {
	echo -e "[INFO] $2"
	logInfo "$1" "$2"
}

function logInfo {
	log "$1" "$2" "INFO"
}

function logEchoWarn {
	echo -e "[WARNING] $2"
	logWarn "$1" "$2"
}

function logWarn {
	log "$1" "$2" "WARN"
}

function logEchoError {
	echo -e "[ERROR] $2"
	logError "$1" "$2"
}

function logError {
	log "$1" "$2" "ERROR"
}

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

function verificarDirectorios {
	local directoriosFaltantes=""

	if [[ ! -d "$BINDIR" ]]; then
		directoriosFaltantes+="$BINDIR "
	fi

	if [[ ! -d "$CONFDIR" ]]; then
		directoriosFaltantes+="$CONFDIR "
	fi

	if [[ ! -d "$MAEDIR" ]]; then
		directoriosFaltantes+="$MAEDIR "
	fi

	if [[ ! -d "$ACEPDIR" ]]; then
		directoriosFaltantes+="$ACEPDIR "
	fi

	if [[ ! -d "$RECHDIR" ]]; then
		directoriosFaltantes+="$RECHDIR $RECHDIR/llamadas "
	else
		if [[ ! -d "$RECHDIR/llamadas" ]]; then
			directoriosFaltantes+="$RECHDIR/llamadas "
		fi
	fi

	if [[ ! -d "$PROCDIR" ]]; then
		directoriosFaltantes+="$PROCDIR $PROCDIR/proc "
	else
		if [[ ! -d "$PROCDIR/proc" ]]; then
			directoriosFaltantes+="$PROCDIR/proc "
		fi
	fi

	if [[ ! -d "$REPODIR" ]]; then
		directoriosFaltantes+="$REPODIR "
	fi

	if [[ ! -d "$LOGDIR" ]]; then
		directoriosFaltantes+="$LOGDIR "
	fi

	if [[ ! -d "$NOVEDIR" ]]; then
		directoriosFaltantes+="$NOVEDIR "
	fi

	echo "$directoriosFaltantes"
}
