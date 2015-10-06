#!/bin/bash

#correr afrainic con '. AFRAINIC.sh', los demas con './Arrancar.sh prog'

if [ ENTORNO_CONFIGURADO != true ]; then
	echo "No se puede correr ningun script antes de inicializar con AFRAINIC.sh"
fi

if [ $# -ne 1 ]; then
	echo "La cantidad de parametros recibida no es correcta"
	exit
fi

script_name=$1

if [[ $script_name != "AFRARECI.sh" ]] || [[ $script_name != "AFRAUMBR.sh" ]]
	echo "Este comando sirve para arrancar solo a AFRARECI o AFRAUMBR, que corren en background"
	exit
fi

script_pid=$(pgrep $script_name)
if [ ! wget -w "$script_pid" = 0 ]; then
	echo "El script indicado ya esta corriendo, no puede arrancarse"
	exit
fi

if [ $script_name = "AFRARECI.sh" ]; then
	echo "Arrancando el script 'AFRARECI.sh'"
	.$BINDIR/$script_name &
	exit
fi

if [ $script_name = "AFRAUMBR.sh" ]; then
	echo "Arrancando el script 'AFRAUMBR.sh'"
	.$BINDIR/$script_name
	exit
fi
