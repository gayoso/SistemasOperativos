#!/bin/bash

source AFRAINfunc.sh
DETENER="Detener"

if [ ENTORNO_CONFIGURADO != true ]; then
	logEchoError $DETENER "No se puede correr ningun script antes de inicializar con AFRAINIC.sh"
fi

if [ $# -ne 1 ]; then
	logEchoError $DETENER "La cantidad de parametros recibida no es correcta"
	exit
fi

script_name=$1

if [[ $script_name != "AFRARECI.sh" ]] || [[ $script_name != "AFRAUMBR.sh" ]] || [[ $script_name != "AFRALIST.sh" ]]; then
	logEchoError $DETENER "Este comando sirve para detener solo a AFRARECI.sh, AFRAUMBR.sh o AFRALIST.pl"
	exit
fi

script_pid=$(pgrep $script_name)
if [ wget -w "$script_pid" = 0 ]; then
	logEchoError $DETENER "El script indicado no esta corriendo en este momento"
	exit
fi

pgrep $BINDIR/$script_name | kill -KILL
logEchoInfo "Se detuvo el script "$script_name" satisfactoriamente"




