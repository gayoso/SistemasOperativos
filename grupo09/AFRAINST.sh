#! /bin/bash
# Asumo que todos los archivos (tanto los script como los maestros y tablas) están en el directorio raíz ($GRUPO) a la hora de ejecutar AFRAINST.sh
# Asumo que AFRAINST.sh se encuentra en $GRUPO
# Asumo que si se ponen 2 directorios con el mismo nombre no hay problema

# Script que instala el sistema
#-----------------------------------------------------------------------------------------------------------
# Uso:
# >$ ./AFRAINST.sh ---> No se por qué no corre con . AFRAINST.sh (Parece que no se banca las expresiones regulares)
#
# El script no recibe parametros.
#
# Función:
#  - Verifica que el sistema cumpla las condiciones para instalar.
#  - Instala.
#------------------------------------------------------------------------------------------------------------

function log {
	if [[ -f GraLog.sh ]]; then
		if [[ ! -x GraLog.sh ]]; then
			chmod +x GraLog.sh
		fi
		./GraLog.sh "AFRAINST" "$1" "$2" # 1=log message, 2=log level
	fi
}

function logEchoInfo {
	echo -e "[INFO] $1"
	logInfo "$1"
}

function logInfo {
	log "$1" "INFO"
}

function logEchoWarn {
	echo -e "[WARNING] $1"
	logWarn "$1"
}

function logWarn {
	log "$1" "WARN"
}

function logEchoError {
	echo -e "[ERROR] $1"
	logError "$1"
}

function logError {
	log "$1" "ERROR"
}

function verificarPerl {
	if perl < /dev/null &>/dev/null; then # Si perl esta instalado...
		# local perlinfo=`perl -v | grep '.' | head -n 1`
		local perlVersion=$(echo `perl -v` | grep 'This is perl ' | sed "s/This is perl //" | sed "s/[^0-9].*//")
		if [[ perlVersion != "" && perlVersion -ge 5 ]]; then
			local perlMsg=$(perl -v)
			logEchoInfo "\nPerl Version: $perlMsg\n"
			return 0
		fi
	fi
	logEchoError "
Para ejecutar el sistema AFRA-I es necesario contar con Perl 5 o superior.
Efectúe su instalación e inténtelo nuevamente.
Proceso de instalación cancelado.\n"
	return 1
}

function aceptarTerminosYCondiciones {
	logEchoInfo "
**********************************************************************
*                 Proceso de Instalación de \"AFRA-I\"                 *
*      Tema I Copyright © Grupo 09 - Segundo Cuatrimestre 2015       *
**********************************************************************
A T E N C I Ó N: Al instalar Ud. expresa aceptar los términos y condiciones del \"ACUERDO DE LICENCIA DE SOFTWARE\" incluido en este paquete. Acepta? Si - No"
	local respuesta="asd"
	local reSi='^[Ss][Ii]$'
	local reNo='^[Nn][Oo]$'
	while read respuesta && [[ !( "$respuesta" =~ $reSi ) ]] && [[ !( "$respuesta" =~ $reNo ) ]]; do
		echo "Error: debe ingresar 'Si' o 'No'"
	done < "/dev/stdin"
	respuesta=${respuesta,,} #toLower

	if [[ "$respuesta" == "si" ]]; then
		logInfo "El usuario ingresó: $respuesta"
		return 0
	else
		logWarn "El usuario ingresó: $respuesta"
		return 1
	fi
}

function verificarNombreDirectorio {
	local aux="asd"
	local reBarra='^/.*$'
	read aux
	if [[ "$aux" != "" ]]; then
		if [[ "$aux" != "conf" ]]; then
			if ! [[ "$aux" =~ $reBarra ]]; then
				echo "$aux"
			else
				logWarn "El usuario ingresó \"$aux\", pero el nombre de un directorio no puede empezar con /. Se toma el valor por defecto."
				echo "$1"
			fi
		else
			logWarn "El usuario ingresó \"$aux\", pero éste es un directorio reservado y no se puede utilizar. Se toma el valor por defecto."
			echo "$1"
		fi
	else
		logWarn "El usuario ingresó enter, por lo que se toma el valor por defecto."
		echo "$1"
	fi
}

function verificarNumero {
	local aux="asd"
	read aux
	reNum='^[0-9]+$'
	if [[ "$aux" != "" ]]; then
		if ! [[ "$aux" =~ $reNum ]] ; then
			logWarn "El usuario ingresó \"$aux\", lo cual no es un número o valor válido. Se toma el valor por defecto."
			echo "$1"
		else
			if [[ "$aux" -gt 0 ]]; then
				echo "$aux"
			else
				logWarn "El usuario ingresó 0, lo cual no tiene sentido, pues tiene que ser un número mayor a 0. Se toma el valor por defecto."
				echo "$1"
			fi
		fi
	else
		logWarn "El usuario ingresó enter, por lo que se toma el valor por defecto."
		echo "$1"
	fi
}

function definirDirectorios {
	logEchoWarn "ATENCIÓN: Si se ingresa 'enter' directamente se toma como valor el \"por defecto\" provisto entre paréntesis."
	logEchoWarn "ATENCIÓN: Todo directorio ingresado será relativo a \$GRUPO:$GRUPO\n"

	logEchoInfo 'Defina el directorio de instalación de los ejecutables ($GRUPO/'"$BINDIR):"
	BINDIR=$(verificarNombreDirectorio "$BINDIR")
	logInfo "La variable BINDIR quedó seteada en: $BINDIR"

	logEchoInfo 'Defina el directorio para maestros y tablas ($GRUPO/'"$MAEDIR):"
	MAEDIR=$(verificarNombreDirectorio "$MAEDIR")
	logInfo "La variable MAEDIR quedó seteada en: $MAEDIR"

	logEchoInfo 'Defina el directorio de recepción de archivos de llamadas ($GRUPO/'"$NOVEDIR):"
	NOVEDIR=$(verificarNombreDirectorio "$NOVEDIR")
	logInfo "La variable NOVEDIR quedó seteada en: $NOVEDIR"

	# Chequeo si en NOVEDIR hay DATASIZE MB libres
	disponibleKB=$(df -k "$GRUPO"| tail -1 | awk '{print $4}')
	disponibleMB=$(($disponibleKB/1024))
	local dataSizeAux=$DATASIZE
	DATASIZE=999999999999
	while ! [[ "$disponibleMB" -ge "$DATASIZE" ]]; do
		DATASIZE="$dataSizeAux"
		logEchoInfo "Defina espacio mínimo libre para la recepción de archivos de llamadas en MBytes ($DATASIZE):"
		DATASIZE=$(verificarNumero "$DATASIZE")
		if ! [[ "$disponibleMB" -ge "$DATASIZE" ]]; then
			logEchoWarn "\nInsuficiente espacio en disco.
Espacio disponible: $disponibleMB MB.
Espacio requerido $DATASIZE MB.
Inténtelo nuevamente."
		fi
	done
	logInfo "La variable DATASIZE quedó seteada en: $DATASIZE"
	logInfo "Hay espacio disponible para la carpeta $NOVEDIR."

	logEchoInfo 'Defina el directorio de grabación de los archivos de llamadas aceptadas ($GRUPO/'"$ACEPDIR):"
	ACEPDIR=$(verificarNombreDirectorio "$ACEPDIR")
	logInfo "La variable ACEPDIR quedó seteada en: $ACEPDIR"

	logEchoInfo 'Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/'"$PROCDIR):"
	PROCDIR=$(verificarNombreDirectorio "$PROCDIR")
	logInfo "La variable PROCDIR quedó seteada en: $PROCDIR"

	logEchoInfo 'Defina el directorio de grabación de los reportes ($GRUPO/'"$REPODIR):"
	REPODIR=$(verificarNombreDirectorio "$REPODIR")
	logInfo "La variable REPODIR quedó seteada en: $REPODIR"

	logEchoInfo 'Defina el directorio para los archivos de log ($GRUPO/'"$LOGDIR):"
	LOGDIR=$(verificarNombreDirectorio "$LOGDIR")
	logInfo "La variable LOGDIR quedó seteada en: $LOGDIR"

	logEchoInfo "Defina el nombre para la extensión de los archivos de log ($LOGEXT):"
	local aux="asd"
	read aux
	rePunto='^\..*$'
	if [[ "$aux" != "" ]]; then
		if ! [[ "$aux" =~ $rePunto ]]; then
			if [[ ${#aux} -gt 5 ]]; then
				logWarn "La longitud de la extensión \"$aux\" es mayor a 5, lo cual es inválido. Se toma el valor por defecto."
			else
				LOGEXT=$aux
			fi
		else
			logWarn "La extensión \"$aux\" comienza con un punto (.), lo cual es inválido. Se toma el valor por defecto."
		fi
	fi
	logInfo "La variable LOGEXT quedó seteada en: $LOGEXT"

	logEchoInfo "Defina el tamaño máximo para cada archivo de log en KBytes ($LOGSIZE):"
	LOGSIZE=$(verificarNumero "$LOGSIZE")
	logInfo "La variable LOGSIZE quedó seteada en: $LOGSIZE"

	logEchoInfo 'Defina el directorio de grabación de archivos rechazados ($GRUPO/'"$RECHDIR):"
	RECHDIR=$(verificarNombreDirectorio "$RECHDIR")
	logInfo "La variable RECHDIR quedó seteada en: $RECHDIR"
}

function instalacionLista {
	logEchoInfo "
RECORDAR: Todo directorio es relativo a $GRUPO

Directorio de ejecutables: $BINDIR
Directorio de maestros y tablas: $MAEDIR
Directorio de recepción de archivos de llamadas: $NOVEDIR
Espacio minimo libre para arribos: $DATASIZE MB
Directorio de archivos de llamadas aceptados: $ACEPDIR
Directorio de archivos de llamadas sospechosas: $PROCDIR
Directorio de archivos de reportes de llamadas: $REPODIR
Directorio de archivos de log: $LOGDIR
Extension para los archivos de log: .$LOGEXT
Tamaño maximo para los archivos de log: $LOGSIZE KB
Directorio de archivos rechazados: $RECHDIR
Estado de la instalación: LISTA
Desea continuar con la instalación? (Si - No)"
}

function crearDirectorio {
	if [[ ! -d "$1" ]]; then
		mkdir -p "$1"
	fi
	logEchoInfo "$GRUPO/$1"
}

function crearDirectorios {
	crearDirectorio "$BINDIR"
	crearDirectorio "$MAEDIR"
	crearDirectorio "$NOVEDIR"
	crearDirectorio "$ACEPDIR"
	crearDirectorio "$PROCDIR"
	crearDirectorio "$PROCDIR/proc"
	crearDirectorio "$REPODIR"
	crearDirectorio "$LOGDIR"
	crearDirectorio "$RECHDIR"
	crearDirectorio "$RECHDIR/llamadas"
}

function copiarArchivo {
	if [[ -f "$1" ]]; then
		if [[ ! -f "$2/$1" ]]; then
			cp "$1" "$2"
			logEchoInfo "Se ha copiado el archivo $1 a /$2."
		fi
	else
		logEchoWarn "El archivo $1 no existe en $GRUPO, por lo que no se ha podido copiar a /$2."
		return 1
	fi
	return 0
}

function copiarEjecutables {
	# if [ -f MoverA.sh ]; then
	# 	if [ ! -x MoverA.sh ]; then
	# 		chmod +x MoverA.sh
	# 	fi
	# 	./MoverA.sh "$GRUPO/AFRAINIC.sh" "$GRUPO/$BINDIR"
	# fi
	local resultado=0
	copiarArchivo 'AFRAINIC.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'AFRARECI.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'AFRAUMBR.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'AFRALIST.pl' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'MoverA.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'GraLog.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'Arrancar.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'Detener.sh' "$BINDIR"
	resultado=$(($resultado+$?))
	return "$resultado"
}
function copiarMaestrosYTablas {
	local resultado=0
	copiarArchivo 'agentes.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'CdA.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'CdC.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'CdP.mae' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'tllama.tab' "$MAEDIR"
	resultado=$(($resultado+$?))
	copiarArchivo 'umbral.tab' "$MAEDIR"
	resultado=$(($resultado+$?))
	return "$resultado"
}

function actualizarConfiguracion {
	# Recordar que todo directorio es relativo a $GRUPO siempre
	echo "GRUPO=$GRUPO=$USER=$(date +"%d-%m-%Y %T")" > "$CONFDIR/AFRAINST.conf" # Sobrescribo si ya hay algo
	echo "CONFDIR=$CONFDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf" # Append
	echo "BINDIR=$BINDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "MAEDIR=$MAEDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "DATASIZE=$DATASIZE=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "ACEPDIR=$ACEPDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "RECHDIR=$RECHDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "PROCDIR=$PROCDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "REPODIR=$REPODIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "LOGDIR=$LOGDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "LOGSIZE=$LOGSIZE=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "NOVEDIR=$NOVEDIR=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
	echo "LOGEXT=$LOGEXT=$USER=$(date +"%d-%m-%Y %T")" >> "$CONFDIR/AFRAINST.conf"
}

function instalar {
	local resultado=0
	logEchoInfo "Creando estructuras de directorio..."
	crearDirectorios
	logEchoInfo "Instalando programas y funciones..."
	copiarEjecutables
	resultado=$(($resultado+$?))
	logEchoInfo "Instalando archivos maestros y tablas..."
	copiarMaestrosYTablas
	resultado=$(($resultado+$?))
	logEchoInfo "Actualizando la configuración del sistema..."
	actualizarConfiguracion
	if [[ "$resultado" -gt 0 ]]; then
		logEchoError "La instalación ha tenido un error y no ha podido terminar con éxito. Esto se debe a archivos faltantes, por favor revise el log."
	else
		logEchoInfo "Instalación concluida satisfactoriamente."
	fi
	return "$resultado"
}

function obtenerVariablesDeArchivoConf {
	GRUPO=$(grep 'GRUPO=' "$archConf" | sed "s/GRUPO=//" | sed "s/=.*//")
	CONFDIR=$(grep 'CONFDIR=' "$archConf" | sed "s/CONFDIR=//" | sed "s/=.*//")
	BINDIR=$(grep 'BINDIR=' "$archConf" | sed "s/BINDIR=//" | sed "s/=.*//")
	MAEDIR=$(grep 'MAEDIR=' "$archConf" | sed "s/MAEDIR=//" | sed "s/=.*//")
	DATASIZE=$(grep 'DATASIZE=' "$archConf" | sed "s/DATASIZE=//" | sed "s/=.*//")
	ACEPDIR=$(grep 'ACEPDIR=' "$archConf" | sed "s/ACEPDIR=//" | sed "s/=.*//")
	RECHDIR=$(grep 'RECHDIR=' "$archConf" | sed "s/RECHDIR=//" | sed "s/=.*//")
	PROCDIR=$(grep 'PROCDIR=' "$archConf" | sed "s/PROCDIR=//" | sed "s/=.*//")
	REPODIR=$(grep 'REPODIR=' "$archConf" | sed "s/REPODIR=//" | sed "s/=.*//")
	LOGDIR=$(grep 'LOGDIR=' "$archConf" | sed "s/LOGDIR=//" | sed "s/=.*//")
	LOGSIZE=$(grep 'LOGSIZE=' "$archConf" | sed "s/LOGSIZE=//" | sed "s/=.*//")
	NOVEDIR=$(grep 'NOVEDIR=' "$archConf" | sed "s/NOVEDIR=//" | sed "s/=.*//")
	LOGEXT=$(grep 'LOGEXT=' "$archConf" | sed "s/LOGEXT=//" | sed "s/=.*//")
}

function verificarExistencia {
	local aux=$(ls -1 "$1" | grep "^$2$")
	if [[ "$aux" == "$2" ]]; then
		return 0
	fi
	return 1
}

function verificarArchivos {
	local archivosFaltantes=""
	verificarExistencia "$BINDIR" "AFRAINIC.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRAINIC.sh "
	fi
	verificarExistencia "$BINDIR" "AFRARECI.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRARECI.sh "
	fi
	verificarExistencia "$BINDIR" "AFRAUMBR.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRAUMBR.sh "
	fi
	verificarExistencia "$BINDIR" "AFRALIST.pl"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/AFRALIST.pl "
	fi
	verificarExistencia "$BINDIR" "MoverA.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/MoverA.sh "
	fi
	verificarExistencia "$BINDIR" "GraLog.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/GraLog.sh "
	fi
	verificarExistencia "$BINDIR" "Arrancar.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/Arrancar.sh "
	fi
	verificarExistencia "$BINDIR" "Detener.sh"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$BINDIR/Detener.sh "
	fi

	verificarExistencia "$MAEDIR" "agentes.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/agentes.mae "
	fi
	verificarExistencia "$MAEDIR" "CdA.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/CdA.mae "
	fi
	verificarExistencia "$MAEDIR" "CdC.mae"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/CdP.mae "
	fi
	verificarExistencia "$MAEDIR" "tllama.tab"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/tllama.tab "
	fi
	verificarExistencia "$MAEDIR" "umbral.tab"
	if [[ "$?" -eq 1 ]]; then
		archivosFaltantes+="$MAEDIR/umbral.tab "
	fi

	echo "$archivosFaltantes"
}

function listarCarpetasYVerificarArchivos {
	local lsCONFDIR=$(ls -1 "$CONFDIR")
	local lsBINDIR=$(ls -1 "$BINDIR")
	local lsMAEDIR=$(ls -1 "$MAEDIR")
	local lsLOGDIR=$(ls -1 "$LOGDIR")
	logEchoInfo "
Directorio de configuración: $CONFDIR
$lsCONFDIR
Directorio de ejecutables: $GRUPO/$BINDIR
$lsBINDIR
Directorio de maestros y tablas: $GRUPO/$MAEDIR
$lsMAEDIR
Directorio de recepción de archivos de llamadas: $GRUPO/$NOVEDIR
Directorio de archivos de llamadas aceptados: $GRUPO/$ACEPDIR
Directorio de archivos de llamadas sospechosas: $GRUPO/$PROCDIR
Directorio de archivos de reportes de llamadas: $GRUPO/$REPODIR
Directorio de archivos de log: $GRUPO/$LOGDIR
$lsLOGDIR
Directorio de archivos rechazados: $GRUPO/$RECHDIR"
	local archivosFaltantes=$(verificarArchivos)
	if [[ "$archivosFaltantes" == "" ]]; then #No hay faltantes
		logEchoInfo "\nEstado de la instalación: COMPLETA\nProceso de instalación finalizado."
		return 0
	else
		logEchoWarn "\nEstado de la instalación: INCOMPLETA\nComponentes faltantes: $archivosFaltantes \nDesea completar la instalación? (Si - No)"
		local reSi='^[Ss][Ii]$'
		local reNo='^[Nn][Oo]$'
		local line="asd"
		while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !( "$line" =~ $reNo ) ]]; do
			echo "Error: debe ingresar 'Si' o 'No'"
		done < "/dev/stdin"
		line=${line,,} #toLower
		clear
		if [[ "$line" == "si" ]]; then
			logInfo "El usuario ingresó: $line"
			instalar
			if [[ "$?" -eq 0 ]]; then
				listarCarpetasYVerificarArchivos # Al llamar aca no deberia suceder de que haya archivos faltantes, ya que me fije si fue satisfactoria la instalacion
				return 0
			fi
			return 1
		else
			logWarn "El usuario ingresó: $line"
			return 1
		fi
	fi
}

# Asumo que el archivo de configuracion esta bien escrito (No hay que volver a verificar)
function verificarInstalacionCompleta {
	obtenerVariablesDeArchivoConf
	listarCarpetasYVerificarArchivos
	return "$?"
}

export GRUPO=$(pwd)
export CONFDIR=conf
export BINDIR=bin
export MAEDIR=mae
export NOVEDIR=novedades
export DATASIZE=100
export ACEPDIR=aceptadas
export PROCDIR=sospechosas
export REPODIR=reportes
export LOGDIR=log
export LOGEXT=log
export LOGSIZE=400
export RECHDIR=rechazadas

# Por enunciado $GRUPO/conf ya deberia estar creado, pero chequeo por las dudas
# Utilizo comillas para evitar problemas con directorios con espacios
if [[ ! -d "$CONFDIR" ]]; then
	# echo "El directorio $CONFDIR no existe. Creándolo..."
	mkdir "$CONFDIR" 		
fi

archConf=$CONFDIR/AFRAINST.conf
if [[ ! -f "$archConf" ]]; then #Si no existe el archivo $archConf
	verificarPerl
	if [[ "$?" -eq 0 ]]; then #Si Perl esta instalado
		aceptarTerminosYCondiciones
		if [[ "$?" -eq 0 ]]; then #Si acepto las condiciones
			clear
			confirmarInicio="no"
			while [[ "$confirmarInicio" != "si" ]]; do
				definirDirectorios
				clear
				instalacionLista

				line="asd"
				reSi='^[Ss][Ii]$'
				reNo='^[Nn][Oo]$'
				while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !( "$line" =~ $reNo ) ]]; do
					echo "Error: debe ingresar 'Si' o 'No'"
				done < "/dev/stdin"
				confirmarInicio=${line,,} #toLower
				if [[ "$confirmarInicio" == "si" ]]; then
					logInfo "El usuario ingresó: $confirmarInicio"
				else
					logWarn "El usuario ingresó: $confirmarInicio"
				fi
				clear
			done
			logEchoInfo "Iniciando instalación. Está ud. seguro? (Si - No)"
			line="asd"
			while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !( "$line" =~ $reNo ) ]]; do
				echo "Error: debe ingresar 'Si' o 'No'"
			done < "/dev/stdin"
			rta=${line,,} #toLower
			echo
			if [[ "$rta" == "si" ]]; then
				logInfo "El usuario ingresó: $rta"
				instalar
				exit "$?"
			else
				logWarn "El usuario ingresó: $rta. La instalación ha sido cancelada."
				exit 1
			fi
		else
			logEchoError "Los términos y condiciones no han sido aceptados. La instalación ha sido cancelada."
			exit 1
		fi
	fi
	exit 1 #Perl no está instalado
else
	verificarInstalacionCompleta
	exit "$?"
fi