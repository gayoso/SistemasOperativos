#!/bin/bash

PATH_ARCH_CONFIG=$1
# asumo que el path es a la carpeta, no que pasan cada ejecutable como input
DIR_EJECUTABLES=$2
# mismo (y que no termina en '/', sino agrego igual pero reemplazo '//' por '/')
DIR_MAESTROS_TABLAS=$3

# lee la linea que contiene 'FUE_CONFIGURADO'
FUE_CONFIGURADO=$(grep "FUE_CONFIGURADO" $PATH_ARCH_CONFIG)
FUE_CONFIGURADO=${FUE_CONFIGURADO#"FUE_CONFIGURADO="}

if [ $FUE_CONFIGURADO = true ]; then
	# loguear que ya fue configurada la secion
fi

# verificar faltantes en la instalacion, informar, etc

# chequeo que esten todos los archivos
if [ ! -f ${PATH_MAESTROS_TABLAS}/CdP.mae ]; then
	#loguear
	exit
if [ ! -f ${PATH_MAESTROS_TABLAS}/CdA.mae ]; then
	#loguear
	exit
if [ ! -f ${PATH_MAESTROS_TABLAS}/CdC.mae ]; then
	#loguear
	exit
if [ ! -f ${PATH_MAESTROS_TABLAS}/agentes.mae ]; then
	#loguear
	exit
if [ ! -f ${PATH_MAESTROS_TABLAS}/tllama.tab ]; then
	#loguear
	exit
if [ ! -f ${PATH_MAESTROS_TABLAS}/umbral.tab ]; then
	#loguear
	exit
# chequear si falta algun script?

# permisos? se refiere a lectura/escritura? completar

# variables? todas menos GRUPO parcen estar seteadas en AFRAINST, para que estan aca tambien?
sed -i "s@GRUPO=@GRUPO=/usr/alumnos/temp/grupo09=$USER=$(date '+%D %H:%M')@" $PATH_ARCH_CONFIG
#mostrar y loguear

input=""
while [[ $input != "Si" ]] && [[ $input != "No" ]]; do
	echo -n "¿Desea efectuar la activacion de AFRARECI? (Si/No): "
	read input
done

if [ $input == "No" ]; then
	echo "Puede arrancar AFRARECI en cualquier momento con el comando Arrancar" # ver si mejorar
	# cerrar log	
	exit
fi

echo "Puede detener AFRARECI en cualquier momento con el comando Detener" # ver si mejorar
# loguear que corre AFRARECI

# activar AFRARECI (no se como puede haber otro corriendo si aca se viene solo despues de configurar y solo se puede configurar una vez. estaban re duros los que hicieron esto"



