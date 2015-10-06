#!/bin/bash

# Script a cargo del log de los diferentes comandos o funciones.
#-------------------------------------------------------------------------------------------------------
# El script recibe 2 o 3 parametros:
# 1°: nombre de la funcion o comando que llama al log.
# 2°: un string con el mensaje propiamente dicho a loguear.
# 3° (opcional): tipo de error: INFORMATIVO(INFO), WARNING(WARN) o ERROR(ERROR).

# Para su correcto funcionamiento debe tener seteadas las variables de ambiente 

# De no recibir el 3° parametro, se asume que el valor por default es INFO.
# Ademas, como dice el enunciado, el log tiene el mismo nombre que la funcion/comando que llama a este script
# con la extension .LOGEXT y que la ubicacion es LOGDIR o bien CONFDIR si se trata del comando AFRAINST. En
# este ultimo caso, la extension es directamente .log.
#------------------------------------------------------------------------------------------------------

WHERE="$1"					# Nombre de la funcion o comando que llama al GraLog.
WHY="$2"					# Texto del mensaje a loguear.
if [[ "$#" -eq 3 ]]; then	# Si hay 3 parametros significa que se identifica el tipo de error.
	WHAT="$3"				# Tipo de error: INFO, WARN o ERROR
elif [[ "$#" -eq 2 ]]; then	# Si hay 2 parametros se toma la variable WHAT = INFO por default.
	WHAT="INFO"				# Tipo de error: INFO por default.
else
	$BINDIR/GraLog.sh "GraLog" "Recibidos $# parametros en lugar de 2 o 3." "ERROR"
	exit $#
fi

#Me fijo si el log es el del instalador u otro comando/funcion.
if [[ "$WHERE" == "AFRAINST" ]]; then
	LOGPATH="$CONFDIR/AFRAINST.log"
else
	LOGPATH="$LOGDIR/$WHERE.$LOGEXT"
fi

WHEN=$(date +"%d/%m/%Y %T") 		# Fecha y Hora, en el formato que deseen y calculada justo antes de la grabación.
WHO="$USER"							# Usuario, es el login del usuario.

echo -e "$WHEN-$WHO-$WHERE-$WHAT-$WHY" >> $LOGPATH

exit 0