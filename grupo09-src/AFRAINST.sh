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

source AFRAINfunc.sh

function logEchoInfoInst {
	echo -e "[INFO] $1"
	logInfoInst "$1"
}

function logInfoInst {
	logInfo "AFRAINST" "$1"
}

function logEchoWarnInst {
	echo -e "[WARNING] $1"
	logWarnInst "$1"
}

function logWarnInst {
	logWarn "AFRAINST" "$1"
}

function logEchoErrorInst {
	echo -e "[ERROR] $1"
	logErrorInst "$1"
}

function logErrorInst {
	logError "AFRAINST" "$1"
}

function verificarPerl {
	if perl < /dev/null &>/dev/null; then # Si perl esta instalado...
		# local perlinfo=`perl -v | grep '.' | head -n 1`
		local perlVersion=$(echo `perl -v` | grep 'This is perl ' | sed "s/This is perl //" | sed "s/[^0-9].*//")
		if [[ perlVersion != "" && perlVersion -ge 5 ]]; then
			local perlMsg=$(perl -v)
			logEchoInfoInst "\nPerl Version: $perlMsg\n"
			return 0
		fi
	fi
	logEchoErrorInst "
Para ejecutar el sistema AFRA-I es necesario contar con Perl 5 o superior.
Efectúe su instalación e inténtelo nuevamente.
Proceso de instalación cancelado.\n"
	return 1
}

function aceptarTerminosYCondiciones {
	logEchoInfoInst "
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
		logInfoInst "El usuario ingresó: $respuesta"
		return 0
	else
		logWarnInst "El usuario ingresó: $respuesta"
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
				logWarnInst "El usuario ingresó \"$aux\", pero el nombre de un directorio no puede empezar con /. Se toma el valor por defecto."
				echo "$1"
			fi
		else
			logWarnInst "El usuario ingresó \"$aux\", pero éste es un directorio reservado y no se puede utilizar. Se toma el valor por defecto."
			echo "$1"
		fi
	else
		logWarnInst "El usuario ingresó enter, por lo que se toma el valor por defecto."
		echo "$1"
	fi
}

function verificarNumero {
	local aux="asd"
	read aux
	reNum='^[0-9]+$'
	if [[ "$aux" != "" ]]; then
		if ! [[ "$aux" =~ $reNum ]] ; then
			logWarnInst "El usuario ingresó \"$aux\", lo cual no es un número o valor válido. Se toma el valor por defecto."
			echo "$1"
		else
			if [[ "$aux" -gt 0 ]]; then
				echo "$aux"
			else
				logWarnInst "El usuario ingresó 0, lo cual no tiene sentido, pues tiene que ser un número mayor a 0. Se toma el valor por defecto."
				echo "$1"
			fi
		fi
	else
		logWarnInst "El usuario ingresó enter, por lo que se toma el valor por defecto."
		echo "$1"
	fi
}

function definirDirectorios {
	logEchoWarnInst "ATENCIÓN: Si se ingresa 'enter' directamente se toma como valor el \"por defecto\" provisto entre paréntesis."
	logEchoWarnInst "ATENCIÓN: Todo directorio ingresado será relativo a \$GRUPO:$GRUPO\n"

	logEchoInfoInst 'Defina el directorio de instalación de los ejecutables ($GRUPO/'"$BINDIR):"
	BINDIR=$(verificarNombreDirectorio "$BINDIR")
	logInfoInst "La variable BINDIR quedó seteada en: $BINDIR"

	logEchoInfoInst 'Defina el directorio para maestros y tablas ($GRUPO/'"$MAEDIR):"
	MAEDIR=$(verificarNombreDirectorio "$MAEDIR")
	logInfoInst "La variable MAEDIR quedó seteada en: $MAEDIR"

	logEchoInfoInst 'Defina el directorio de recepción de archivos de llamadas ($GRUPO/'"$NOVEDIR):"
	NOVEDIR=$(verificarNombreDirectorio "$NOVEDIR")
	logInfoInst "La variable NOVEDIR quedó seteada en: $NOVEDIR"

	# Chequeo si en NOVEDIR hay DATASIZE MB libres
	disponibleKB=$(df -k "$GRUPO"| tail -1 | awk '{print $4}')
	disponibleMB=$(($disponibleKB/1024))
	local dataSizeAux=$DATASIZE
	DATASIZE=999999999999
	while ! [[ "$disponibleMB" -ge "$DATASIZE" ]]; do
		DATASIZE="$dataSizeAux"
		logEchoInfoInst "Defina espacio mínimo libre para la recepción de archivos de llamadas en MBytes ($DATASIZE):"
		DATASIZE=$(verificarNumero "$DATASIZE")
		if ! [[ "$disponibleMB" -ge "$DATASIZE" ]]; then
			logEchoWarnInst "\nInsuficiente espacio en disco.
Espacio disponible: $disponibleMB MB.
Espacio requerido $DATASIZE MB.
Inténtelo nuevamente."
		fi
	done
	logInfoInst "La variable DATASIZE quedó seteada en: $DATASIZE"
	logInfoInst "Hay espacio disponible para la carpeta $NOVEDIR."

	logEchoInfoInst 'Defina el directorio de grabación de los archivos de llamadas aceptadas ($GRUPO/'"$ACEPDIR):"
	ACEPDIR=$(verificarNombreDirectorio "$ACEPDIR")
	logInfoInst "La variable ACEPDIR quedó seteada en: $ACEPDIR"

	logEchoInfoInst 'Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/'"$PROCDIR):"
	PROCDIR=$(verificarNombreDirectorio "$PROCDIR")
	logInfoInst "La variable PROCDIR quedó seteada en: $PROCDIR"

	logEchoInfoInst 'Defina el directorio de grabación de los reportes ($GRUPO/'"$REPODIR):"
	REPODIR=$(verificarNombreDirectorio "$REPODIR")
	logInfoInst "La variable REPODIR quedó seteada en: $REPODIR"

	logEchoInfoInst 'Defina el directorio para los archivos de log ($GRUPO/'"$LOGDIR):"
	LOGDIR=$(verificarNombreDirectorio "$LOGDIR")
	logInfoInst "La variable LOGDIR quedó seteada en: $LOGDIR"

	logEchoInfoInst "Defina el nombre para la extensión de los archivos de log ($LOGEXT):"
	local aux="asd"
	read aux
	rePunto='^\..*$'
	if [[ "$aux" != "" ]]; then
		if ! [[ "$aux" =~ $rePunto ]]; then
			if [[ ${#aux} -gt 5 ]]; then
				logWarnInst "La longitud de la extensión \"$aux\" es mayor a 5, lo cual es inválido. Se toma el valor por defecto."
			else
				LOGEXT=$aux
			fi
		else
			logWarnInst "La extensión \"$aux\" comienza con un punto (.), lo cual es inválido. Se toma el valor por defecto."
		fi
	fi
	logInfoInst "La variable LOGEXT quedó seteada en: $LOGEXT"

	logEchoInfoInst "Defina el tamaño máximo para cada archivo de log en KBytes ($LOGSIZE):"
	LOGSIZE=$(verificarNumero "$LOGSIZE")
	logInfoInst "La variable LOGSIZE quedó seteada en: $LOGSIZE"

	logEchoInfoInst 'Defina el directorio de grabación de archivos rechazados ($GRUPO/'"$RECHDIR):"
	RECHDIR=$(verificarNombreDirectorio "$RECHDIR")
	logInfoInst "La variable RECHDIR quedó seteada en: $RECHDIR"
}

function instalacionLista {
	logEchoInfoInst "
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
		logEchoInfoInst "$GRUPO/$1"
	fi
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
	if [[ ! -f "$2/$1" ]]; then
		if [[ -f "$1" ]]; then
			cp "$1" "$2"
			logEchoInfoInst "Se ha copiado el archivo $1 a /$2."
		else
			logEchoWarnInst "El archivo $1 no existe en $GRUPO, por lo que no se ha podido copiar a /$2."
			return 1
		fi
	fi
	return 0
}

function copiarEjecutables {
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
	copiarArchivo 'AFRAINfunc.sh' "$BINDIR"
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
	logEchoInfoInst "Creando estructuras de directorio..."
	crearDirectorios
	logEchoInfoInst "Instalando programas y funciones..."
	copiarEjecutables
	resultado=$(($resultado+$?))
	logEchoInfoInst "Instalando archivos maestros y tablas..."
	copiarMaestrosYTablas
	resultado=$(($resultado+$?))
	logEchoInfoInst "Actualizando la configuración del sistema..."
	actualizarConfiguracion
	if [[ "$resultado" -gt 0 ]]; then
		logEchoErrorInst "La instalación ha tenido un error y no ha podido terminar con éxito. Esto se debe a archivos faltantes, por favor revise el log."
	else
		logEchoInfoInst "Instalación concluida satisfactoriamente."
	fi
	return "$resultado"
}

function obtenerVariablesDeArchivoConf {
	local aux=""
	aux=$(grep 'GRUPO=' "$archConf" | sed "s/GRUPO=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		GRUPO="$aux"
	fi
	aux=$(grep 'CONFDIR=' "$archConf" | sed "s/CONFDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		CONFDIR="$aux"
	fi
	aux=$(grep 'BINDIR=' "$archConf" | sed "s/BINDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		BINDIR="$aux"
	fi
	aux=$(grep 'MAEDIR=' "$archConf" | sed "s/MAEDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		MAEDIR="$aux"
	fi
	aux=$(grep 'DATASIZE=' "$archConf" | sed "s/DATASIZE=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		DATASIZE="$aux"
	fi
	aux=$(grep 'ACEPDIR=' "$archConf" | sed "s/ACEPDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		ACEPDIR="$aux"
	fi
	aux=$(grep 'RECHDIR=' "$archConf" | sed "s/RECHDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		RECHDIR="$aux"
	fi
	aux=$(grep 'PROCDIR=' "$archConf" | sed "s/PROCDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		PROCDIR="$aux"
	fi
	aux=$(grep 'REPODIR=' "$archConf" | sed "s/REPODIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		REPODIR="$aux"
	fi
	aux=$(grep 'LOGDIR=' "$archConf" | sed "s/LOGDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		LOGDIR="$aux"
	fi
	aux=$(grep 'LOGSIZE=' "$archConf" | sed "s/LOGSIZE=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		LOGSIZE="$aux"
	fi
	aux=$(grep 'NOVEDIR=' "$archConf" | sed "s/NOVEDIR=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		NOVEDIR="$aux"
	fi
	aux=$(grep 'LOGEXT=' "$archConf" | sed "s/LOGEXT=//" | sed "s/=.*//")
	if [[ "$aux" != "" ]]; then
		LOGEXT="$aux"
	fi
}

function listarCarpetasYVerificarArchivos {
	local lsCONFDIR=$(ls -1 "$CONFDIR")
	local lsBINDIR=$(ls -1 "$BINDIR")
	local lsMAEDIR=$(ls -1 "$MAEDIR")
	local lsLOGDIR=$(ls -1 "$LOGDIR")
	logEchoInfoInst "
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
	local directoriosFaltantes=$(verificarDirectorios)
	if [[ "$archivosFaltantes" == "" && "$directoriosFaltantes" == "" ]]; then #No hay faltantes
		logEchoInfoInst "\nEstado de la instalación: COMPLETA\nProceso de instalación finalizado."
		return 0
	else
		logEchoWarnInst "\nEstado de la instalación: INCOMPLETA\nComponentes faltantes: $archivosFaltantes\nDirectorios faltantes: $directoriosFaltantes\nDesea completar la instalación? (Si - No)"
		local reSi='^[Ss][Ii]$'
		local reNo='^[Nn][Oo]$'
		local line="asd"
		while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !( "$line" =~ $reNo ) ]]; do
			echo "Error: debe ingresar 'Si' o 'No'"
		done < "/dev/stdin"
		line=${line,,} #toLower
		clear
		if [[ "$line" == "si" ]]; then
			logInfoInst "El usuario ingresó: $line"
			instalar
			if [[ "$?" -eq 0 ]]; then
				listarCarpetasYVerificarArchivos # Al llamar aca no deberia suceder de que haya archivos faltantes, ya que me fije si fue satisfactoria la instalacion
				return 0
			fi
			return 1
		else
			logWarnInst "El usuario ingresó: $line"
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
					logInfoInst "El usuario ingresó: $confirmarInicio"
				else
					logWarnInst "El usuario ingresó: $confirmarInicio"
				fi
				clear
			done
			logEchoInfoInst "Iniciando instalación. Está ud. seguro? (Si - No)"
			line="asd"
			while read line && [[ !( "$line" =~ $reSi ) ]] && [[ !( "$line" =~ $reNo ) ]]; do
				echo "Error: debe ingresar 'Si' o 'No'"
			done < "/dev/stdin"
			rta=${line,,} #toLower
			echo
			if [[ "$rta" == "si" ]]; then
				logInfoInst "El usuario ingresó: $rta"
				instalar
				exit "$?"
			else
				logWarnInst "El usuario ingresó: $rta. La instalación ha sido cancelada."
				exit 1
			fi
		else
			logEchoErrorInst "Los términos y condiciones no han sido aceptados. La instalación ha sido cancelada."
			exit 1
		fi
	fi
	exit 1 #Perl no está instalado
else
	verificarInstalacionCompleta
	exit "$?"
fi
