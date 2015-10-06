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

if [ $script_name = "AFRARECI.sh" ]
	echo "Arrancando el script 'AFRARECI.sh'"
	./$BINDIR/$script_name &
	exit
fi

if [ $script_name = "AFRAUMBR.sh" ]
	echo "Arrancando el script 'AFRAUMBR.sh'"
	./$BINDIR/$script_name &
	exit
fi

echo "El argumento no es un nombre valido de script"
