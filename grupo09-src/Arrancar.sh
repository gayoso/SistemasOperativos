#!/bin/bash

source AFRAINfunc.sh
ARRANCAR="Arrancar"
CALLER="$2"
cantParametros="$#"

function loguearErrorOEcho {
	if [[ "$cantParametros" -eq 1 ]]; then
		echo "[ERROR] $1"
	else
		logEchoError "$CALLER" "Arrancar.sh: $1"
	fi
}

function loguearInfoOEcho {
	if [[ "$cantParametros" -eq 1 ]]; then
		echo "[INFO] $1"
	else
		logEchoInfo "$CALLER" "Arrancar.sh: $1"
	fi
}

if [[ "$ENTORNO_CONFIGURADO" != true ]]; then
	# No logueo porque no existen las variables de ambiente
	echo "[ERROR] El entorno no ha sido configurado aún. Corra el script AFRAINIC.sh para configurarlo."
	exit 1
fi

if [[ "$cantParametros" -ne 1 && "$cantParametros" -ne 2 ]]; then
	loguearErrorOEcho "La cantidad de parametros recibida no es correcta."
	exit 1
fi

script_name="$1"

if [[ "$script_name" != "AFRARECI.sh" ]] && [[ "$script_name" != "AFRAUMBR.sh" ]] && [[ "$script_name" != "AFRALIST.sh" ]]; then
	loguearErrorOEcho "Este comando sirve para arrancar solo a AFRARECI.sh, AFRAUMBR.sh o AFRALIST.pl."
	exit 1
fi

script_pid=$(pgrep "$script_name")
if [[ $(wc -w <<< "$script_pid") != 0 ]]; then
	loguearErrorOEcho "El script indicado ($script_name) ya esta corriendo y no puede arrancarse nuevamente."
	exit 1
fi

if [[ "$script_name" == "AFRARECI.sh" ]]; then
	./"$script_name" &
	afrareciPID=$(pgrep AFRARECI.sh)
	loguearInfoOEcho "Arrancando el script 'AFRARECI.sh' bajo el PID: $afrareciPID"
	exit 0
fi

if [[ "$script_name" == "AFRAUMBR.sh" ]]; then
	./"$script_name" &
	afraumbrPID=$(pgrep AFRAUMBR.sh)
	loguearInfoOEcho "Arrancando el script 'AFRAUMBR.sh' bajo el PID: $afraumbrPID"
	exit 0
fi

if [[ "$script_name" == "AFRALIST.pl" ]]; then
	./"$script_name"
	loguearInfoOEcho "Arrancando el script 'AFRALIST.pl'"
	exit 0
fi
