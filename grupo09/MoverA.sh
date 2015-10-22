#!/bin/bash

source AFRAINfunc.sh

# filename con path completo
param_origen="$1"	

param_destino="$2"

CALLER="$3"

# guardo el filename del archivo sin su path original
filename=${param_origen##*/}

# guardo el path original del archivo
path_origen=${param_origen%/*}

# el nuevo path que tendria el archivo movido
filename_con_path_destino="$param_destino/$filename"

# veo si existe origen
if [[ ! -f "$param_origen" ]]; then
	logEchoError "$CALLER" "MoverA.sh: El archivo a mover ($param_origen) no existe."
	exit 1
fi

# veo si existe destino
if [[ ! -d "$param_destino" ]]; then
	logEchoError "$CALLER" "MoverA.sh: El directorio destino ($param_destino) no existe."
	exit 1
fi

# veo si origen y destino son iguales
if [[ "$param_origen" == "$filename_con_path_destino" ]]; then
	logEchoError "$CALLER" "MoverA.sh: El directorio origen y el directorio destino son iguales ($param_origen)."
	exit 1
fi

# asumo que el comando es para mover archivos nada mas, por eso '-f'
if [[ -f "$filename_con_path_destino" ]]; then
	if [[ ! -d "$param_destino/duplicados" ]]; then
		mkdir "$param_destino/duplicados"
	fi
	count=1
	while [[ -f "$param_destino/duplicados/$filename.$(printf "%03d" $count)" ]]; do
		count=$((count+1))
	done
	
	mv "$param_origen" "$param_destino/duplicados/$filename.$(printf "%03d" $count)"
else
	mv "$param_origen" "$param_destino"
fi

logInfo "$CALLER" "MoverA.sh: Se movió satisfactoriamente el archivo $param_origen a $param_destino."
exit 0