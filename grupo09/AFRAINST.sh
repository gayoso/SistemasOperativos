#!/bin/bash
# Asumo que todos los archivos (tanto los script como los maestros y tablas) están en el directorio raíz ($GRUPO) a la hora de ejecutar AFRAINST.sh
# Asumo que AFRAINST.sh se encuentra en $GRUPO

function verificarPerl {
	echo Perl
	return 0
}
function aceptarTerminosYCondiciones {
	#TODO: Loguear
	echo "********************************************************************************"
	echo "*                      Proceso de Instalación de \"AFRA-I\"                      *"
	echo "*           Tema I Copyright © Grupo 09 - Segundo Cuatrimestre 2015            *"
	echo "********************************************************************************"
	echo " A T E N C I O N: Al instalar Ud. expresa aceptar los términos y condiciones del \"ACUERDO DE LICENCIA DE SOFTWARE\" incluido en este paquete. Acepta? Si - No"
	local line="asd"
	while read line && [[ "$line" != "Si" ]] && [[ "$line" != "No" ]]; do
		echo "Error: debe ingresar 'Si' o 'No'"
		# return 0 # Este return despues volarlo, esto es para que sea mas facil seguir de largo
	done < "/dev/stdin"
	if [[ "$line" == "Si" ]]; then
		return 0
	else
		return 1
	fi
}

function verificarInstalacionCompleta {
	# leer del arch de conf todos los valores de las variables y verificar que esten los archivos pertinentes
	# en caso de que no este completa, ver que esten los archivos en $GRUPO como para completar la instalacion
	echo Instalacion
	return 0
}

GRUPO=`pwd`
CONFDIR=$GRUPO/conf
BINDIR=bin
MAEDIR=mae
NOVEDIR=novedades
DATASIZE=100
ACEPDIR=aceptadas
PROCDIR=sospechosas
REPODIR=reportes
LOGDIR=log
LOGEXT=log
LOGSIZE=400
RECHDIR=rechazadas

# Por enunciado $GRUPO/conf ya deberia estar creado, pero chequeo por las dudas
# Utilizo comillas para evitar problemas con directorios con espacios
if [ ! -d "$CONFDIR" ]; then
	echo "El directorio $CONFDIR no existe. Creandolo..."
	mkdir "$CONFDIR" 		
fi

archConf=$CONFDIR/AFRAINST.conf
if [ ! -f "$archConf" ]; then
	echo "El archivo $archConf no existe."
	verificarPerl
	aceptarTerminosYCondiciones
	if [ "$?" -eq 0 ]; then #Si acepto las condiciones
		clear
		confirmarInicio="No"
		while [[ "$confirmarInicio" != "Si" ]]; do
			echo "ATENCION: Si se ingresa enter directamente se toma como valor el \"por defecto\" provisto entre parentesis."
			echo
			aux=""
			echo 'Defina el directorio de instalación de los ejecutables ($GRUPO/'"$BINDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				BINDIR=$aux
			fi
			echo 'Defina el directorio para maestros y tablas ($GRUPO/'"$MAEDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				MAEDIR=$aux
			fi
			echo 'Defina el directorio de recepción de archivos de llamadas ($GRUPO/'"$NOVEDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				NOVEDIR=$aux
			fi
			echo "Defina espacio mínimo libre para la recepción de archivos de llamadas en Mbytes ($DATASIZE):"
			read aux
			if [[ "$aux" != "" ]]; then
				re='^[0-9]+$'
				if ! [[ "$aux" =~ $re ]] ; then
					# loguear que como no es un numero (O es con coma u negativo) se toma el por defecto
					echo "error: Not a number"
				else
					if [[ "$aux" -gt 0 ]]; then
						DATASIZE=$aux
					else
						# loguear que no es mayor a 0
						echo "No es mayor a 0"
					fi
				fi
			fi

			# Chequear si en NOVEDIR hay DATASIZE MB libres
			disponibleKB=$(df -k "$GRUPO"| tail -1 | awk '{print $4}')
			disponibleMB=$((disponibleKB/1024))
			#O en un while???
			if [ "$disponibleMB" -gt "$DATASIZE" ]; then
				echo "Espacio OK."
			else
				#Loguear
				echo "Espacio insuficiente."
			fi

			echo 'Defina el directorio de grabación de los archivos de llamadas aceptadas ($GRUPO/'"$ACEPDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				ACEPDIR=$aux
			fi
			echo 'Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/'"$PROCDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				PROCDIR=$aux
			fi
			echo 'Defina el directorio de grabación de los reportes ($GRUPO/'"$REPODIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				REPODIR=$aux
			fi
			echo 'Defina el directorio para los archivos de log ($GRUPO/'"$LOGDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				LOGDIR=$aux
			fi
			echo "Defina el nombre para la extensión de los archivos de log ($LOGEXT):"
			read aux
			if [[ "$aux" != "" ]]; then
				if [[ ${#aux} -gt 5 ]]; then
					# loguear que es mayor a 5
					echo ${#aux}
				else
					LOGEXT=$aux
				fi
			fi
			echo "Defina el tamaño máximo para cada archivo de log en KBytes ($LOGSIZE):"
			read aux
			if [[ "$aux" != "" ]]; then
				re='^[0-9]+$'
				if ! [[ "$aux" =~ $re ]] ; then
					# loguear que como no es mayor a 0 o no es un numero se toma el por defecto
					echo "error: Not a number"
				else
					if [[ "$aux" -gt 0 ]]; then
						LOGSIZE=$aux
					else
						echo "No es mayor a 0"
					fi
				fi
			fi
			echo 'Defina el directorio de grabación de archivos rechazados ($GRUPO/'"$RECHDIR):"
			read aux
			if [[ "$aux" != "" ]]; then
				RECHDIR=$aux
			fi
			clear
			echo
			echo
			echo "Directorio de ejecutables: $BINDIR"
			echo "Directorio de maestros y tablas: $MAEDIR"
			echo "Directorio de recepción de archivos de llamadas: $NOVEDIR"
			echo "Espacio minimo libre para arribos: $DATASIZE MB"
			echo "Directorio de archivos de llamadas aceptados: $ACEPDIR"
			echo "Directorio de archivos de llamadas sospechosas: $PROCDIR"
			echo "Directorio de archivos de reportes de llamadas: $REPODIR"
			echo "Directorio de archivos de log: $LOGDIR"
			echo "Extension para los archivos de log: .$LOGEXT"
			echo "Tamaño maximo para los archivos de log: $LOGSIZE KB"
			echo "Directorio de archivos rechazados: $RECHDIR"
			echo "Estado de la instalacion: LISTA"
			echo "Desea continuar con la instalación? (Si - No)"
			line="asd"
			# reSi='^[Ss][Ii]$'
			# while read line && [[ !( "$line" =~ reSi ) ]]; do #Falta ver que sea distinto de "no"
			while read line && [[ "$line" != "Si" ]] && [[ "$line" != "No" ]]; do #TODO: Ver si con la expresion regular reSi se puede hacer que se pueda ingresar Si, SI, sI, si
				echo "Error: debe ingresar 'Si' o 'No'"
			done < "/dev/stdin"
			# line=${line,,}
			confirmarInicio=$line
			echo "$confirmarInicio"
			if [[ "$confirmarInicio" == "No" ]]; then
				clear
			fi
		done

		echo "Iniciando Instalacion. Esta Ud. seguro? (Si - No)"
		while read line && [[ "$line" != "Si" ]] && [[ "$line" != "No" ]]; do
			echo "Error: debe ingresar 'Si' o 'No'"
		done < "/dev/stdin"
		if [[ "$line" == "Si" ]]; then
			echo "Instalando"
		fi
	else
		echo "Condiciones no aceptadas"
	fi

	exit 2
else
	echo "El archivo $archConf existe."
	verificarInstalacionCompleta
fi
#cerrarLog