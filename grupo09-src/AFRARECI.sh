#!/bin/bash

#TODOS LOS ECHOS DEBERIAN SER EL LOG

#Nombre de este script
miNombre="AFRARECI"

#if [ -z "$MAEDIR"] && [ -z "$NOVEDIR"] && [ -z "$ACEPDIR"] && [ -z "$RECHDIR"] && [ -z "$LOGDIR"];then
if [[ ENTORNO_CONFIGURADO == true ]]; then
	./GraLog.sh "$miNombre" "no estan seteadas las variables de estado, el proceso se interrumpira" "ERROR"	
	#echo "no estan seteadas las variables de estado, el proceso se interrumpira"
	exit
fi 

#Codigo de las centrales
#MdC="$1"
Mdc="$MAEDIR"

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
			./GraLog.sh "$miNombre" "Archivo "$1" no es de texto. El archivo se movera a rechazados" "INFO" 			#echo "Archivo "$1" no es de texto"
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
		./GraLog.sh "$miNombre" "Archivo "$1" invalido: formato invalido. El archivo se movera a rechazados"  "INFO"
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
		./GraLog.sh "$miNombre" "Archivo "$1" invalido :el codigo no existe. El archivo se movera a rechazados" "INFO"
		return 0
	fi
	
	esFechaInvalida ${fecha:4:2}"/"${fecha:6:2}"/"${fecha:0:4} bool
	
	if [ $bool -eq 1 ]; then
		./GraLog.sh "$miNombre" "Archivo "$1" invalido :fecha es invalida. El archivo se movera a rechazados" "INFO"
		return 0
	fi

	fecha_posta=$(date +"%Y%m%d")
	
	if [ $((fecha_posta - fecha)) -gt 10000 ]; then
		./GraLog.sh "$miNombre" "Archivo $1 invalido :fecha es menor a un año. El archivo se movera a rechazados" "INFO"
		return 0
	fi
		
	if [ "$fecha_posta" -lt "$fecha" ]; then
		./GraLog.sh $miNombre "Archivo $1 invalido :fecha no es anterior a la actual. El archivo se movera a rechazados" "INFO"
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
	./GraLog.sh "$miNombre" "ciclo nro. $numIteracion" "INFO"

	#Checkear si hay nuevos archivos
	if [ "$(ls -A $Novedir)" ]; then
		#Recorro archivos
		for	archivo in "$Novedir"/*; do
			
			archivo_sin_dir=${archivo##*/} #Guardo en archivo el nombre
			
			esTexto "$archivo" #checkeo si es un arch de texto
			
					
			if (( $? == 0)); then 
				aLoguear=$(./MoverA.sh "$archivo" "$Rechazados" "AFRARECI")
				./GraLog.sh "$miNombre" "$aLoguear" "WARN"
				continue
			fi #si no es valido salgo del loop

			esValidoElFormato "$archivo_sin_dir"
			
			if (( $? == 0)); then  
				aLoguear=$(./MoverA.sh "$archivo" "$Rechazados" "AFRARECI")
				./GraLog.sh "$miNombre" "$aLoguear" "WARN"
				continue
			fi #si no es valido salgo del loop		
			
			esValidoElNombre "$archivo_sin_dir" "$MdC"
			
			if (( $? == 0)); then
				aLoguear=$(./MoverA.sh "$archivo" "$Rechazados" "AFRARECI")
				./GraLog.sh "$miNombre" "$aLoguear" "WARN"
				continue 
			fi #si no es valido salgo del loop	
			
			./GraLog.sh "$miNombre" "Archivo valido: $archivo_sin_dir PATH: $archivo" "INFO"
			aLoguear=$(./MoverA.sh "$archivo" "$Aceptados" "AFRARECI")
			./GraLog.sh "$miNombre" "$aLoguear" "WARN"			
		 
		done
	fi

	if [ "$(ls -A $Aceptados)" ]; then
		#pidof_afraumbr="$(pidof AFRAUMBR.sh)"
		
		aLoguear=$(./Arrancar "AFRAUMBR.sh")
		./GraLog.sh "$miNombre" "$aLoguear" "WARN"		
		
		#if [ $pidof_afraumbr ]; then
		#	./GraLog.sh "Invocacion de AFRAUMBR propuesta para el siguiente ciclo" "WARN"
		#else
		#	#LLAMAR A AFRAUMBR
		#	./Arrancar.sh AFRAUMBR					
		#	pidof_afraumbr="$(pidof AFRAUMBR.sh)"
		#	./GraLog.sh "AFRAUMBR corriendo bajo  el no.: $pidof_afraumbr" "INFO"
		#fi
	fi

	#Aumento la iteracion en 1
	((numIteracion++))

	sleep $tiempoDeCheckeo	
done

#while read line; do
#	IFS=';' read var1 var2 <<< $line
#	echo -e "$var1 :  $var2\n "
#done < $1
