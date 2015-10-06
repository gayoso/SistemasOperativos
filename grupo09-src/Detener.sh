#!/bin/bash

if [ ENTORNO_CONFIGURADO != true ]; then
	echo "No se puede correr ningun script antes de inicializar con AFRAINIC.sh"
fi

if [ $# -ne 1 ]; then
	echo "La cantidad de parametros recibida no es correcta"
	exit
fi

script_name=$1

if [[ $script_name != "AFRARECI.sh" ]] || [[ $script_name != "AFRAUMBR.sh" ]]
	echo "Este comando sirve para detener solo a AFRARECI o AFRAUMBR, que corren en background"
	exit
fi

script_pid=$(pgrep $script_name)
if [ wget -w "$script_pid" = 0 ]; then
	echo "El script indicado no esta corriendo en este momento"
	exit
fi

echo "Deteniendo el script '"$script_name"'"
pgrep $BINDIR/$script_name | kill -KILL



