#!/bin/bash

#TODOS LOS ECHOS DEBERIAN SER EL LOG

#Codigo de las centrales
MdC="$1"

#Directorio con novedades
Novedir="$2"

#Directorio con Aceptados
Aceptados="ACEPDIR"

#Directorio con rechazados
Rechazados="RECHDIR"

#Nombre de este script
miNombre="prueba_parseo.sh"

#Tiempo entre de Checkeo
tiempoDeCheckeo=10

#funcion que se fija si es un archivo de texto
function esTexto {
	local tipoArch=$(file -0 "$1" | cut -d $'\0' -f2)
	
	case "$tipoArch" in 
		(*text*)
			
			return 1
			;;
		(*) 
			echo "Archivo "$1" no es de texto"
			return 0
			;;
	esac
}

#Funcion que se fija si el nombre es valido
function esValidoElFormato {
	local arch=$1

	if [ ${#arch} -eq 12 ] && [ ${arch:3:1} == '_' ]
	then
		return 1
	else
		echo "Archivo "$1" invalido: formato invalido"
		return 0
	fi	
}

#Funcion que se fija si la fecha es invalida
function esFechaInvalida {

	local __returnVar=$2
	
	date -d $1 > /dev/null 2>&1
	local res=$?
	eval $__returnVar=$res
}

#Funcion que se fija si el formato sea valido
function esValidoElNombre {

	IFS='_' read codigoCentral fecha <<< $1
	
	#echo -e "$codigoCentral :  $fecha"
	
	local existeElCodigo=$(grep -c $codigoCentral $2)
	
	if [ $existeElCodigo -eq 0 ]; then
		echo "Archivo "$1" invalido :el codigo no existe"
		return 0
	fi
	
	esFechaInvalida ${fecha:4:2}"/"${fecha:6:2}"/"${fecha:0:4} bool
	
	if [ $bool -eq 1 ]; then
		echo "Archivo "$1" invalido :fecha es invalida"
		return 0
	fi

	fecha_posta=$(date +"%Y%m%d")
	
	if [ $((fecha_posta - fecha)) -gt 10000 ]; then
		echo "Archivo $1 invalido :fecha es menor a un año"
		return 0
	fi
		
	if [ "$fecha_posta" -lt "$fecha" ]; then
		echo "Archivo $1 invalido :fecha no es anterior a la actual"
		return 0
	fi

	return 1
}

#seteo el numero de iteracion en 1
numIteracion=1

#setsid prueba_parseo.sh > /dev/null 2>&1 < /dev/null &

#Empiezo a loopear
while true; do

	#Decirle al log "AFRARECI ciclo nro 1"
	echo "AFRARECI ciclo nro. "$numIteracion

	#Checkear si hay nuevos archivos
	for	archivo in "$Novedir"/*; do
		
		archivo_sin_dir=${archivo##*/} #Guardo en archivo el nombre
		
		esTexto "$archivo_sin_dir" #checkeo si es un arch de texto
		
				
		if (( $? == 0)); then 
			#FALTA MOVE A ARCHIVO INVALIDO
			./MoverA.sh "$archivo" "$Rechazados" "AFRARECI"
			continue
		fi #si no es valido salgo del loop

		esValidoElFormato "$archivo_sin_dir"
		
		if (( $? == 0)); then  
			#FALTA MOVE A ARCHIVO INVALIDO
			./MoverA.sh "$archivo" "$Rechazados" "AFRARECI"
			continue
		fi #si no es valido salgo del loop		
		
		esValidoElNombre "$archivo_sin_dir" "$MdC"
		
		if (( $? == 0)); then
			#FALTA MOVE A ARCHIVO INVALIDO
			./MoverA.sh "$archivo" "$Rechazados" "AFRARECI"
			continue 
		fi #si no es valido salgo del loop	
		
		echo "Archivo valido: " "$archivo_sin_dir" " PATH: " "$archivo"
		./MoverA.sh "$archivo" "$Aceptados" "AFRARECI" 
		#FALTA EL MOVER A PARA ARCHIVO VALIDO

	done

	if [ "$(ls -A $Aceptados)" ]; then
		if [ "$(pidof AFRAUMBR.sh)" ]; then
			echo "Invocacion de AFRAUMBR propuesta para el siguiente ciclo"
		else
			#LLAMAR A AFRAUMBR

			echo "AFRAUMBR corriendo bajo  el no.: " #pidof AFRAUMBR
		fi
	fi

	#Aumento la iteracion en 1
	((numIteracion++))

	sleep $tiempoDeCheckeo	
done

#while read line; do
#	IFS=';' read var1 var2 <<< $line
#	echo -e "$var1 :  $var2\n "
#done < $1
