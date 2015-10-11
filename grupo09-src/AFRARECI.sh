#!/bin/bash

#Nombre de este script
miNombre="AFRARECI"

if [[ "$ENTORNO_CONFIGURADO" == false ]]; then
	# No logueo porque no existen las variables de ambiente
	echo "[ERROR] El entorno no ha sido configurado aún. Corra el script AFRAINIC.sh para configurarlo."
	exit 1
fi 

#Codigo de las centrales
#MdC="$1"
Mdc="$MAEDIR"/CdC.mae

#Directorio con novedades
#Novedir="$2"
Novedir="$NOVEDIR"

#Directorio con Aceptados
#Aceptados="ACEPDIR"
Aceptados="$ACEPDIR"

#Directorio con rechazados
#Rechazados="RECHDIR"
Rechazados="$RECHDIR"

#Tiempo entre cada Checkeo
tiempoDeCheckeo=10

#funcion que se fija si es un archivo de texto
function esTexto {
	local tipoArch=$(file -0 "$1" | cut -d $'\0' -f2)
	
	case "$tipoArch" in 
		(*text*)
			
			return 1
			;;
		(*) 
			./GraLog.sh "$miNombre" "Archivo $1 no es de texto. El archivo se movera a rechazados" "INFO"
			return 0
			;;
	esac
}

#Funcion que se fija si el nombre es valido
function esValidoElFormato {
	local arch=$1

	if [[ ${#arch} -eq 12 ]] && [[ ${arch:3:1} == '_' ]]
	then
		return 1
	else
		./GraLog.sh "$miNombre" "Archivo $1 invalido: formato invalido. El archivo se movera a rechazados"  "INFO"
		return 0
	fi	
}

#Funcion que se fija si la fecha es invalida
function esFechaInvalida {

	local __returnVar=$2
	
	date -d "$1" > /dev/null 2>&1
	local res="$?"
	eval $__returnVar=$res
}

#Funcion que se fija si el formato sea valido
function esValidoElNombre {

	IFS='_' read codigoCentral fecha <<< "$1"
	
	#echo -e "$codigoCentral :  $fecha"

	local existeElCodigo=$(grep -c "$codigoCentral" "$Mdc")
	
	if [[ "$existeElCodigo" -eq 0 ]]; then
		./GraLog.sh "$miNombre" "Archivo $1 invalido: el codigo no existe. El archivo se movera a rechazados" "INFO"
		return 0
	fi
	
	esFechaInvalida ${fecha:4:2}"/"${fecha:6:2}"/"${fecha:0:4} bool
	
	if [[ "$bool" -eq 1 ]]; then
		./GraLog.sh "$miNombre" "Archivo $1 invalido: fecha es invalida. El archivo se movera a rechazados" "INFO"
		return 0
	fi

	fecha_posta=$(date +"%Y%m%d")
	
	if [[ $((fecha_posta - fecha)) -gt 10000 ]]; then
		./GraLog.sh "$miNombre" "Archivo $1 invalido: fecha es mayor a un año. El archivo se movera a rechazados" "INFO"
		return 0
	fi
		
	if [[ "$fecha_posta" -lt "$fecha" ]]; then
		./GraLog.sh $miNombre "Archivo $1 invalido: fecha no es anterior a la actual. El archivo se movera a rechazados" "INFO"
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
	./GraLog.sh "$miNombre" "Ciclo Nro. $numIteracion" "INFO"

	#Checkear si hay nuevos archivos
	# Me fijo si hay archivos nomas con el find
	if [[ $(find "$Novedir" -maxdepth 1 -type f) != "" ]]; then
		#Recorro archivos
		for	archivo in "$Novedir"/*; do
			
			archivo_sin_dir=${archivo##*/} #Guardo en archivo el nombre
			
			esTexto "$archivo" #checkeo si es un arch de texto
			
			if [[ "$?" == 0 ]]; then 
				./MoverA.sh "$archivo" "$Rechazados" "AFRARECI"
				continue
			fi #si no es valido salgo del loop

			esValidoElFormato "$archivo_sin_dir"
			
			if [[ "$?" == 0 ]]; then  
				./MoverA.sh "$archivo" "$Rechazados" "AFRARECI"
				continue
			fi #si no es valido salgo del loop		
			
			esValidoElNombre "$archivo_sin_dir"
			
			if [[ "$?" == 0 ]]; then
				./MoverA.sh "$archivo" "$Rechazados" "AFRARECI"
				continue 
			fi #si no es valido salgo del loop	
			
			./GraLog.sh "$miNombre" "Archivo valido: $archivo_sin_dir PATH: $archivo" "INFO"
			./MoverA.sh "$archivo" "$Aceptados" "AFRARECI"
		 
		done
	fi

	# Me fijo si hay archivos nomas con el find
	if [[ $(find "$Aceptados" -maxdepth 1 -type f) != "" ]]; then
		./Arrancar.sh "AFRAUMBR.sh" "$miNombre" 1>/dev/null
				
		if [[ "$?" != 0 ]]; then
			./GraLog.sh "$miNombre" "Invocacion de AFRAUMBR pospuesta para el siguiente ciclo" "WARN"
			# echo "[WARNING] Invocacion de AFRAUMBR pospuesta para el siguiente ciclo"
		else
			#SE LLAMO A AFRAUMBR
			pidof_afraumbr=$(pgrep AFRAUMBR.sh)
			echo "[INFO] AFRAUMBR corriendo bajo el no.: $pidof_afraumbr"
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
