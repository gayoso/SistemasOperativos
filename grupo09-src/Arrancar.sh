#!/bin/bash

source AFRAINfunc.sh
ARRANCAR="Arrancar"

if [[ $ENTORNO_CONFIGURADO != true ]]; then
	# No logueo porque no existen las variables de ambiente
	echo "[ERROR] El entorno no ha sido configurado aún. Corra el script AFRAINIC.sh para configurarlo."
	# logEchoError $ARRANCAR "No se puede correr ningun script antes de inicializar con AFRAINIC.sh"
	exit 1
fi

if [ $# -ne 1 ]; then
	logEchoError $ARRANCAR "La cantidad de parametros recibida no es correcta"
	exit 1
fi

script_name="$1"

if [[ "$script_name" != "AFRARECI.sh" ]] && [[ "$script_name" != "AFRAUMBR.sh" ]] && [[ "$script_name" != "AFRALIST.sh" ]]; then
	logEchoError $ARRANCAR "Este comando sirve para arrancar solo a AFRARECI.sh, AFRAUMBR.sh o AFRALIST.pl, que corren en background"
	exit 1
fi

script_pid=$(pgrep "$script_name")
if [[ $(wc -w <<< "$script_pid") != 0 ]]; then
	logEchoError $ARRANCAR "El script indicado ya esta corriendo, no puede arrancarse nuevamente."
	exit 1
fi

if [ "$script_name" = "AFRARECI.sh" ]; then
	logEchoInfo $ARRANCAR "Arrancando el script 'AFRARECI.sh'"
	"$BINDIR/$script_name" &
	exit 0
fi

if [ "$script_name" = "AFRAUMBR.sh" ]; then
	logEchoInfo $ARRANCAR "Arrancando el script 'AFRAUMBR.sh'"
	"$BINDIR/$script_name" &
	exit 0
fi

if [ "$script_name" = "AFRALIST.pl" ]; then
	logEchoInfo $ARRANCAR "Arrancando el script 'AFRALIST.pl'"
	"$BINDIR/$script_name"
	exit 0
fi
