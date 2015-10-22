#!/bin/bash

if [[ "$ENTORNO_CONFIGURADO" == false ]]; then
	# No logueo porque no existen las variables de ambiente
	echo "[ERROR] El entorno no ha sido configurado aún. Corra el script AFRAINIC.sh para configurarlo."
	exit 1
fi

#Path del directorio de archivos de llamadas aceptadas
ACEPDIR_PATH="$ACEPDIR"

#Path de directorio de archivos "Maestro y Tablas" (.mae: codigo de pais, etc)
MAEDIR_PATH="$MAEDIR"

#Path de directorio archivos procesados
PROCDIR_PATH="$PROCDIR"

#Path de directorio archivos de llamadas rechazadas
RECHDIR_PATH="$RECHDIR"

#Lista de nombre de archivos a procesar
archivosAProcesar=()

#listas con datos de validacion
#para no tener que acceder a ellos constantemente, guarda en memoria los datos relevantes a AFRAUMBR en la inicializacion
agentesValidos=()
codigosAreaValidos=()
codigosPaisValidos=()
umbrales=()

#variables de control
cantidadArchivosProcesados=0
cantidadArchivosRechazados=0

#Crea el directorio PROCDIR/proc si no existe
function crearDirectorio_ArchProcesados {
	#crea el directorio PROCDIR/proc si no existe
	if [ ! -d "$PROCDIR_PATH/proc" ]; then
		mkdir "$PROCDIR_PATH/proc"
	fi
}

#crea la lista de archivos ordenada cronológicamente
function crearListaArchivos {
	#lo dejo pero no sirve: archivosAProc=$(ls "$ACEPDIR_PATH" | sort -n -r -t _ -k 2)
	local num=0
	for i in `ls "$ACEPDIR_PATH" | sort -n -t _ -k 2` ;
	do
		if [ ! -f  "$ACEPDIR_PATH"/"$i" ]; then
			continue
		fi
		archivosAProcesar[$num]=$i
		((num++))
	done
}

#Funciones de inicializacion de listas de datos de validacion
function inicializarAgentesValidos {
	local idx=0
	while read linea || [ -n "$linea" ]
	do
		agentesValidos[$idx]=$(echo "$linea" | cut -f3 -d\;)";"$(echo "$linea" | cut -f4 -d\;)
		((idx++))
	done < "$MAEDIR_PATH"/"agentes.mae"
}

function inicializarCodigosArea {
	local idx=0
	while read linea || [ -n "$linea" ]
	do
		codigosAreaValidos[$idx]=$(echo "$linea" | cut -f2 -d\;)
		((idx++))
	done < "$MAEDIR_PATH"/"CdA.mae"
}
function inicializarCodigosPais {
	local idx=0
	while read linea || [ -n "$linea" ]
	do
		codigosPaisValidos[$idx]=$(echo "$linea" | cut -f1 -d\;)
		((idx++))
	done < "$MAEDIR_PATH"/"CdP.mae"
}
function inicializarlistaUmbrales {
	local idx=0
	while read linea || [ -n "$linea" ]
	do
		umbrales[$idx]="$linea"
		((idx++))
	done < "$MAEDIR_PATH"/"umbral.tab"
}

#checkea si el archivo ya fue procesado
#Toma como parametro el archivo(1) a analizar
function archivoYaProcesado {
	if [ -f "$PROCDIR_PATH"/proc/"$1" ]; then
		./MoverA.sh "$ACEPDIR_PATH"/"$1" "$RECHDIR_PATH" "AFRAUMBR"
		return 0 #true
	else
		return 1 #false
	fi
}

#El archivo es tomado como dañado si su primer registro no posee si la cantidad de campos
# no se corresponde con el formato establecido (8 campos)
# Toma como parametro el archivo a analizar
function archivoDañado {
	local cantDeCamposEstablecidos=8
	read -r FIRSTLINE < "$ACEPDIR_PATH"/"$1"
	local cantidadDeCampos=$(echo "$FIRSTLINE" | sed 's/[^;]//g' | wc -c)
	if [[ "$cantidadDeCampos" -eq "$cantDeCamposEstablecidos" ]]; then
		return 1 #false, archivo no dañado
	else
		return 0 #true, archivo dañado
	fi
}

#$1 string
function isNumber {
	re='^[0-9]+$'
	if [[ "$1" =~ $re ]] ; then
   		return 0 #true
	else
		return 1 #false
	fi
}

#recibe un id y lo valida checkeando en MAEDIR/agentes.mae
function validar_IDAgente {
	for agente in "${agentesValidos[@]}"
	do
		local nombreAgente=$(echo "$agente" | cut -f1 -d\;)
		if [ "$nombreAgente" = "$1" ]; then
			return 0 #true. existe el agente
		fi
	done
	return 1 #false si no lo encontro
}

#recibe un codigo de area y lo valida checkeando en MAEDIR/CdA.mae
function validar_codigoArea {
	for codigo in "${codigosAreaValidos[@]}"
	do
		if [ "${codigo}" = "$1" ]; then
			return 0 #true. existe el agente
		fi
	done
	return 1 #false si no lo encontro
}

#valida el numero de linea de la siguiente forma:
#debe contener:
#-8 dígitos si el código de área es de 2 dígitos
#-7 dígitos si el código de área es de 3 dígitos
#-6 dígitos si el código de área es de 4 dígitos
#-recibe como parametros $1 el codigo de area y $2 el numero de linea
function validar_numeroDeLinea {
	if ! isNumber "$2";then
		return 1 #false, no es un numero
	fi
	local longitudCodigoArea=${#1}
	local longitudNumeroLinea=${#2}
	if [[ $longitudCodigoArea -eq 2 && $longitudNumeroLinea -ne 8 ]]; then
		return 1 #false, invalido
	fi
	if [[ $longitudCodigoArea -eq 3 && $longitudNumeroLinea -ne 7 ]]; then
		return 1 #false, invalido
	fi
	if [[ $longitudCodigoArea -eq 4 && $longitudNumeroLinea -ne 6 ]]; then
		return 1 #false, invalido
	fi
	return 0 #true en otro caso
}

#$1 : codigo de pais destino
function validar_codigoDePais {
	if [ -n "$1" ];then
		for codigoPais in "${codigosPaisValidos[@]}"
		do
			if [ "${codigoPais}" -eq "$1" ]; then
				return 0 #true, codigo valido
			fi
		done
		return 1 #false: el campo no es nulo y no está en CdP.mae
	fi
	return 0 #true en otro caso
}

#$1: codigo de area destino
#$2: codigo de pais destino
function validar_codigoDeAreaDestino {
	if [[ -n "$1" && -z "$2" ]];then
		if validar_codigoArea "$1";then
			return 0 #codigo valido
		else
			return 1 #codigo invalido
		fi
	fi
	return 0 #true en otro caso
}


#$1: numero de linea destino
#$2: codigo de pais
#$3: codigo de area (B)
function validar_numeroLineaDestino {
	if [[ -z "$1" ]];then
		return 1 #false, debe tener contenido
	fi
	if ! isNumber "$1";then
		return 1 #false, no es un numero
	fi
	if [[ -z "$2" ]];then
		#se trata de una llamada DDN o LOC
		local longitudNumeroLinea=${#1}
		local longitudCodigoArea=${#3}
		local suma=$(( $longitudNumeroLinea+$longitudCodigoArea ))
		if [[ "$suma" -ne "10" ]];then
			return 1 #false, la cantidad de digiton entre codigo y numero de linea en llamadas DDN/LOC debe ser 10
		fi
	fi
	return 0 #true, paso las condiciones
}

#$1: tiempo de conversion a analizar
function validar_tiempoDeConversion {
	if [[ "$1" -ge "0" ]];then
		return 0 #true
	else
		return 1 #false, no puede ser negativo
	fi
}

#DDI = 0 / DDN = 1  / LOC = 2 / ERROR = 9
#Los campos ya estan validados con anterioridad
#$1:codigo pais destino
#$2:codigo area destino
#$3 numero linea destino
#$4:codigo area origen
function determinarTipoLlamada {
	local tipo=9
	if [[ -n "$1" && -n "$3" ]];then
		tipo=0 #La lalmada es DDI
	else
		if [[ "$2" -ne "$4" ]];then
			tipo=1 #La llamada es DDN
		else
			tipo=2 #los codigos de area son iguales, la llamada es Local
		fi
	fi
	#checkeo de errores
	if [[ -n $1 && -n $2 ]];then
		tipo=9
	fi
	if [[ -z $3 ]];then #nunca deberia entrar aca, porque numero de liena ya esta validado, pero lo pongo por las dudas
		tipo=9
	fi
	return "$tipo"
}

function crearDirectorio_llamadasRechazadas {
	#crea el directorio PROCDIR/proc si no existe
	if [ ! -d "$RECHDIR_PATH/llamadas" ]; then
		mkdir "$RECHDIR_PATH/llamadas"
	fi
}

# Busca el nombre de la oficina del agente pasado como parametro y lo devuelve
# $1 Id del agente
function buscarOficina {
	local oficinaID=""
	for agente in "${agentesValidos[@]}"
	do
		local nombreAgente=$(echo "$agente" | cut -f1 -d\;)
		if [ "$nombreAgente" = "$1" ]; then
			local oficinaID=$(echo "$agente" | cut -f2 -d\;)
			break
		fi
	done
	echo "$oficinaID"
}

#procesa los umbrales de MAEDIR/umbral.tab y determina si la llamada es sospechoza"
#Parametros:
# $1 tipo de llamada: DDI=0 / DDN=1 / LOC=2
# $2 codigo area origen
# $3 numero linea origen
# $4 codigo pais destino
# $5 codigo area destino
# $6 tiempo de conversion
#Valores de retorno:
# 0 SIN UMBRAL
# -1 CON UMBRAL Y NO SOSPECHOSA
# ID del umbral en caso de poseer uno y ser sospechosa
# Si detecta mas de un umbral, devuelve el primero encontrado en la tabla de umbrales(de menor id)
function procesarUmbrales {
	local umbralID=0
	local umbralNumeroLinea
	local umbralTipoLLamada
	local umbralCodigoDestino
	local umbralTiempoConversion
	local umbralEstado

	local umbralEncontrado=`grep -m1 -e "^.*;$2;$3;.*" "$MAEDIR_PATH"/"umbral.tab"`
	if [[ "$umbralEncontrado" != "" ]];then
		#umbral detectado - analiza si es sospechosa o no
		umbralID="-1"
		umbralTipoLLamada=$(echo "$umbralEncontrado" | cut -f4 -d\;)
		umbralCodigoDestino=$(echo "$umbralEncontrado" | cut -f5 -d\;)
		umbralTiempoConversion=$(echo "$umbralEncontrado" | cut -f6 -d\;)
		umbralEstado=$(echo "$umbralEncontrado" | cut -f7 -d\;)

		#la llamada no es sospechosa si el umbral esta inactivo
		if [[ "$umbralEstado" == "Inactivo" ]];then
			return "$umbralID"
		fi

		local stringTipoLLamada
		if [[ "$1" -eq 0 ]];then
			#LLAMADA DDI
			stringTipoLLamada="DDI"
			if [[ -z "$umbralCodigoDestino" || "$umbralCodigoDestino" -ne "$4" ]];then
				#LLAMADA SOSPECHOSA
				umbralID=$(echo "$umbralEncontrado" | cut -f1 -d\;)
			fi
		else
			#LLAMADA DDN O LOCAL
			if [[ "$1" -eq 1 ]];then
				stringTipoLLamada="DDN"
			else
				stringTipoLLamada="LOC"
			fi
			if [[ -z "$umbralCodigoDestino" || "$umbralCodigoDestino" -ne "$5" ]];then
				#LLAMADA SOSPECHOSA
				umbralID=$(echo "$umbralEncontrado" | cut -f1 -d\;)
			fi
		fi

		# el tipo de llamada debe coincidir con el indicado en el umbral
		if [[ "$umbralTipoLLamada" != "$stringTipoLLamada" ]];then
			#LLAMADA SOSPECHOSA
			umbralID=$(echo "$umbralEncontrado" | cut -f1 -d\;)
		fi
		
		#tiempo de conversion menor al tope indicado por el umbral
		if [[ "$umbralTiempoConversion" -lt "$6" ]];then
			#LLAMADA SOSPECHOSA
			umbralID=$(echo "$umbralEncontrado" | cut -f1 -d\;)
		fi
	fi
	return "$umbralID"
}

# toma como argumento la fecha de inicio obtenida del archivo de input
# y la devuelve con el formato aniomes
function parsearFechaInicio {
	local estadoIntermedio=$(echo "$1" | cut -f1 -d' ')
	local anio=$(echo "$estadoIntermedio" | cut -f3 -d\/)
	local mes=$(echo "$estadoIntermedio" | cut -f2 -d\/)
	#local dia=$(echo "$estadoIntermedio" | cut -f1 -d\/) dia no va
	local aniomes="$anio""$mes"
	echo "$aniomes"
}

#Procesa el archivo
#toma como parametro el nombre del archivo a procesar
function procesarArchivo {
	local codigoCentral=$(echo "$1" | cut -f1 -d_)
	local cantLlamadas=0
	local cantRechazadas=0
	local conUmbral=0
	local sinUmbral=0
	local cantSospechosas=0
	local cantNoSospechosas=0
	while read linea || [ -n "$linea" ]
	do
		((cantLlamadas++))
		local IDAgente=$(echo "$linea" | cut -f1 -d\; )
		local inicioLLamada=$(echo "$linea" | cut -f2 -d\; )
		local tiempoConversion=$(echo "$linea" | cut -f3 -d\; )
		local numeroA_area=$(echo "$linea" | cut -f4 -d\; )
		local numeroA_numeroLinea=$(echo "$linea" | cut -f5 -d\; )
		local numeroB_codigoPais=$(echo "$linea" | cut -f6 -d\; )
		local numeroB_codigoArea=$(echo "$linea" | cut -f7 -d\; )
		local numeroB_numeroLineaDestino=$(echo "$linea" | cut -f8 -d\; )
		if ! validar_IDAgente "$IDAgente"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;agente no registrado;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		if ! validar_codigoArea "$numeroA_area"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;codigo de area invalido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		if ! validar_numeroDeLinea "$numeroA_area" "$numeroA_numeroLinea"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;numero de linea origen invalido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		if ! validar_codigoDePais "$numeroB_codigoPais"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;codigo de pais destino invalido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		if ! validar_codigoDeAreaDestino "$numeroB_codigoArea" "$numeroB_codigoPais"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;codigo de area destino invalido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		if ! validar_numeroLineaDestino "$numeroB_numeroLineaDestino" "$numeroB_codigoPais" "$numeroB_codigoArea"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;numero de linea destino invalido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		if ! validar_tiempoDeConversion "$tiempoConversion"; then
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;tiempo de conversion invalido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi
		#TIPO DE LLAMADA
		determinarTipoLlamada "$numeroB_codigoPais" "$numeroB_codigoArea" "$numeroB_numeroLineaDestino" "$numeroA_area" # DDI=0/DDN=1/LOC=2
		local tipoLLamada="$?"

		if [[ "$tipoLLamada" -eq "9" ]];then #HAY ERROR
			#rechazar registro
			crearDirectorio_llamadasRechazadas
			echo "$1;tipo de llamada desconocido;$IDAgente;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino" >> "$RECHDIR_PATH/llamadas/$codigoCentral.rech"
			((cantRechazadas++))
			continue
		fi

		procesarUmbrales "$tipoLLamada" "$numeroA_area" "$numeroA_numeroLinea" "$numeroB_codigoPais" "$numeroB_codigoArea" "$tiempoConversion"
		local umbralID="$?"
		if [[ "$umbralID" -eq "-1" ]];then
			#llamada con umbral y no sospechosa
			((conUmbral++)) 
			((cantNoSospechosas++))
		fi
		if [[ "$umbralID" -eq "0" ]];then
			#llamada sin umbral
			((sinUmbral++))
		fi
		if [[ "$umbralID" -gt "0" ]];then
			#llamada con umbral y sospechosa
			((conUmbral++))
			((cantSospechosas++))
			#nombre del archivo
			local oficina=$(buscarOficina "$IDAgente")
			local fechaInicio=$(parsearFechaInicio "$inicioLLamada")
			local nombreArchivo="$oficina""_$fechaInicio"
			#tipo de llamada en string
			local stringTipoLlamada=""
			if [[ "$tipoLLamada" -eq "0" ]];then
				stringTipoLlamada="DDI"
			else
				#LLAMADA DDN O LOCAL
				if [[ "$tipoLLamada" -eq "1" ]];then
					stringTipoLlamada="DDN"
				else
					stringTipoLlamada="LOC"
				fi
			fi
			local fechaArchivo=$(echo "$1" | cut -f2 -d_)
			echo "$codigoCentral;$IDAgente;$umbralID;$stringTipoLlamada;$inicioLLamada;$tiempoConversion;$numeroA_area;$numeroA_numeroLinea;$numeroB_codigoPais;$numeroB_codigoArea;$numeroB_numeroLineaDestino;$fechaArchivo" >> "$PROCDIR_PATH/$nombreArchivo"
		fi
	done < "$ACEPDIR_PATH"/"$1"
	./GraLog.sh "AFRAUMBR" "Se termino de procesar el archivo $1" "INFO"
	#TERMINO DE PROCESAR EL ARCHIVO	
	./GraLog.sh "AFRAUMBR" "De los $cantLlamadas registros:
- $cantRechazadas fueron rechazados por tener algun error en los datos.
- Se encontraron $conUmbral registros con umbral y $sinUmbral registros sin umbral
- De los registros con umbral, $cantSospechosas generaron llamadas sospechosas, mientras que los restantes $cantNoSospechosas, no lo hicieron." "INFO"
	#Mueve el archivo ya procesado para no procesarlo 2 veces cuando se vuelva a llamar AFRAUMBR
	./MoverA.sh "$ACEPDIR_PATH"/"$1" "$PROCDIR_PATH/proc" "AFRAUMBR"
}

############## MAIN ##################################
#observacion, reemplazar los logs correspondientes, por el GraLog
./GraLog.sh "AFRAUMBR" "Inicio AFRAUMBR" "INFO"
chmod +x ./MoverA.sh # esta linea no va una vez que este integrado con el resto del tp
#INICIALIZANDO AFRAUMBR...
crearDirectorio_ArchProcesados
crearListaArchivos
inicializarAgentesValidos
inicializarCodigosArea
inicializarCodigosPais
inicializarlistaUmbrales
#AFRAUMBR INICIALIZADO
./GraLog.sh "AFRAUMBR" "Cantidad de archivos: ${#archivosAProcesar[@]}" "INFO"

for arch in "${archivosAProcesar[@]}"
do
	((cantidadArchivosProcesados++))
	if archivoYaProcesado "${arch}";then
		((cantidadArchivosRechazados++))
		./GraLog.sh "AFRAUMBR" "Se rechaza el archivo ${arch} por estar DUPLICADO" "WARN"
		continue
	fi
	if archivoDañado "${arch}";then
		((cantidadArchivosRechazados++))
		./GraLog.sh "AFRAUMBR" "Se rechaza el archivo ${arch} por que su estructura interna no se corresponde con el formato esperado" "WARN"
		continue
	fi
	#SI EL ARCHIVO NO ESTA DAÑADO NI ES DUPLICADO, LO PROCESA
	./GraLog.sh "AFRAUMBR" "Archivo a procesar: ${arch}" "INFO"
	procesarArchivo "${arch}"
done
./GraLog.sh "AFRAUMBR" "SE PROCESARON TODOS LOS ARCHIVOS:
- Se procesaron $cantidadArchivosProcesados archivos.
- Se rechazaron $cantidadArchivosRechazados archivos." "INFO"
./GraLog.sh "AFRAUMBR" "Fin de AFRAUMBR" "INFO"
