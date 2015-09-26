#!/bin/bash

MoverA (){
	# filename con path completo
	param_origen=$1	

	# viene con '/' al final o sin? ej.: /home/Desktop/ o /home/Desktop (asumo que es la segunda, sino se puede agregar una barra y buscar y reemplazar '//' por '/', se resuelven ambos casos
# es una carpeta como /home/Desktop o incluye el nombre de archivo a mover por ej.;: /home/Desktop/test.txt
	param_destino=$2

	comando_que_me_invoca=$3

	# guardo el filename del archivo sin su path original
	filename=${param_origen##*/}

	# guardo el path original del archivo
	path_origen=${param_origen%/*}

	# el nuevo path que tendria el archivo movido
	filename_con_path_destino=$param_destino/$filename
	
	# veo si existe origen
	if [ ! -d $path_origen ]; then
		#loguear que no existe origen	
		exit
	fi

	# veo si existe destino
	if [ ! -d $param_destino ]; then
		#loguear que no existe destino
		exit
	fi
	
	# veo si origen y destino son iguales
	if [ "$param_origen" == "$filename_con_path_destino" ]; then
		#loguear que son iguales		
		exit
	fi
	
	# asumo que el comando es para mover archivos nada mas, por eso '-f'
	if [ -f $filename_con_path_destino ]; then
		mkdir $param_destino/duplicados
		mv $param_origen $param_destino/duplicados
	else
		mv $param_origen $param_destino
	fi
}

#falta agregar que si en duplicados ya existe, mueva cambiando el nombre segun secuencia .nnn