#!/bin/bash

source AFRAINfunc.sh
DETENER="Detener"

if [[ $ENTORNO_CONFIGURADO != true ]]; then
	# No logueo porque no existen las variables de ambiente
	echo "[ERROR] El entorno no ha sido configurado aún. Corra el script AFRAINIC.sh para configurarlo."
	# logEchoError $DETENER "No se puede correr ningun script antes de inicializar con AFRAINIC.sh"
	exit 1
fi

if [ $# -ne 1 ]; then
	logEchoError $DETENER "La cantidad de parametros recibida no es correcta"
	exit 1
fi

script_name="$1"

if [[ "$script_name" != "AFRARECI.sh" ]] && [[ "$script_name" != "AFRAUMBR.sh" ]] && [[ "$script_name" != "AFRALIST.sh" ]]; then
	logEchoError $DETENER "Este comando sirve para detener solo a AFRARECI.sh, AFRAUMBR.sh o AFRALIST.pl"
	exit 1
fi

script_pid=$(pgrep "$script_name")
if [[ $(wc -w <<< "$script_pid") == 0 ]]; then
	logEchoError $DETENER "El script indicado no esta corriendo en este momento"
	exit 1
fi

kill -KILL "$script_pid"

script_pid=$(pgrep "$script_name")
if [[ $(wc -w <<< "$script_pid") != 0 ]]; then
	logEchoWarn $DETENER "No se pudo detener el script $script_name"
	exit 1
else
	logEchoInfo $DETENER "Se detuvo el script "$script_name" satisfactoriamente"
	exit 0
fi
