#!/bin/perl

## tiene un error de guardado, la variable no guarda bien ...
## falta realizar bien los filtros
## falta cambiar el Directorio de los archivos

if("$ENV{'ENTORNO_CONFIGURADO'}" eq "true"){

$grabar = -1;
#mkdir "$ENV{'LOGDIR'}/AFRALIST-grabados";
$GRABDIR = "$ENV{'REPODIR'}/grabar";
$Dir= "$ENV{'BINDIR'}";
$direcPeligrosas="$ENV{'PROCDIR'}"."/";
$uvtoficina=-1;
$uvtam=-1;

$uvtagente=-1;
$uvtcentral=-1;
$uvtumbral=-1;
$uvtnuma=-1;
$uvttipo=-1;

$fagente=-1;
$fcentral=-1;
$fumbral=-1;
$fnuma=-1;
$ftipo=-1;


sub MenuPal {

	print "AFRALIST\n";
	system("clear");
	print "MenuPPAL\n";
	print "________\n";
	print "Ingrese '-h' para pedir ayuda\n";
	print "Ingrese '-w' para grabar\n";
	print "Ingrese '-r' para realizar una consulta\n";
	print "Ingrese '-s' para ver estadisticas\n";
	print "Ingrese '-e' para salir\n";

	$menu = <STDIN>;
	chomp($menu);

	if ($menu eq "-h") {
		Menuh();
	}
	else {
		if ($menu eq "-w") {
			Menuw();
		}
		else {
			if ($menu eq "-r") {
				Menur();
			}
			else {
				if ($menu eq "-s") {
					Menus();
				}
				else {
					if ($menu eq "-e") {
						Menue();
					}
					else {
						MenuPal(); 			
					} 
				} 
			} 
		} 
	}
	
}
	
sub Menuh {
	system("clear");
	print "Menu de ayuda\n";
	print "Si desea salir apretar s\n";

	print "Se cuenta con un archivo default.txt\n";
	print "El mismo contendra id de centrales, agentes, umbrales, tipo de llamada, area y numero de linea\n";
	print "Ante el filtro uno, se utilizara el primer id de cada campo";
	print "Ante el filtro varios, se utilizara los primeros 3 ids de cada campo";
	print "Ante el filtro todos, utilizara todos los ids conocidos";

	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Menu de ayuda\n";
		print "Se cuenta con un archivo default.txt\n";
		print "El mismo contendra id de centrales, agentes, umbrales, tipo de llamada, area y 				numero de linea\n";
		print "Ante el filtro uno, se utilizara el primer id de cada campo";
		print "Ante el filtro varios, se utilizara los primeros 3 ids de cada campo";
		print "Ante el filtro todos, utilizara todos los ids conocidos";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
	MenuPal(); 			
}

sub Menuw {
	$listo = 0;
	system("clear");
	#print "$grabar\n";
	print "Si desea salir apretar e\n";
	if ($grabar ==1){
		print "Se grabara su proxima busqueda\n";	
	}
	if ($grabar ==0){
		print "No se grabara su proxima busqueda\n";	
	}
	
	print "¿Desea grabar la siguiente busqueda?[s/n]\n";
	$opc = <STDIN>;
	chomp($opc);
	if ($opc eq "s"){
		$grabar = 1;
		$listo = 1;	
	
	}
	if ($opc eq "n"){
		$grabar	= 0;
		$listo = 1;
	}		
	
	while (($opc ne "e")&& (listo != 1)) {
			system("clear");
		print "Si desea salir apretar e\n";
		if ($grabar ==1){
			print "Se grabara su proxima busqueda\n";	
		}
		if ($grabar ==0){
			print "No se grabara su proxima busqueda\n";	
		}		
		print "¿Desea grabar la siguiente busqueda?[s/n]\n";
		$opc = <STDIN>;
		chomp($opc);
		if ($opc eq "s"){
			$grabar = 1;
			$listo =1;	
		}
		if ($opc eq "n"){
			$grabar	= 0;
			$listo =1;
		}		
	}
	MenuPal(); 			
}

sub IngresarInput{
	system("clear");
	print "Filtrar archivos imput\n";
	print "Si desea salir apretar s\n";	
	print "¿Cuantos filtros de oficina  desea tener(1=uno/2=varios/3=todos)?\n";
	$opc = <STDIN>;
	chop($opc);
	if($opc == 1){$uvtoficina = 1;}
	if($opc == 2){$uvtoficina = 2;}
	if($opc == 3){$uvtoficina = 3;}
	while (($uvtoficina == -1)&& ($opc ne "s")){
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "¿Cuantos filtros de oficina  desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvtoficina = 1;}
		if($opc == 2){$uvtoficina = 2;}
		if($opc == 3){$uvtoficina = 3;}
	}
	system("clear");
	print "Filtrar archivos imput\n";
	print "Si desea salir apretar s\n";	
	print "¿Cuantos filtros de año/mes  desea tener(1=uno/2=varios/3=todos)?\n";
	$opc = <STDIN>;
	chop($opc);
	if($opc == 1){$uvtam = 1;}
	if($opc == 2){$uvtam = 2;}
	if($opc == 3){$uvtam = 3;}
	while (($uvtam == -1)&& ($opc ne "s")){
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "¿Cuantos filtros de año/mes  desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvtam = 1;}
		if($opc == 2){$uvtam = 2;}
		if($opc == 3){$uvtam = 3;}
	}								
	if ($uvtoficina==-1){$uvtoficina=3;};
	if ($uvtam==-1){$uvtam=3;};
}



sub filtroCent{
	system("clear");
	print "Elegir Filtros\n";		
	print "Si desea salir apretar e\n";
	print "¿Desea filtrar por central? [s/n] ";
	$opc = <STDIN>;
	chop($opc);
	if ($opc eq "s"){
		$fcentral = 1;
		$rescentral ="si";
		print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvtcentral = 1; $rescentral2="uno";}
		if($opc == 2){$uvtcentral = 2; $rescentral2="varios";}
		if($opc == 3){$uvtcentral = 3; $rescentral2="todos";}
		while (($uvtcentral == -1)&& ($opc ne "e")){
			system("clear");
			print "Elegir Filtros\n";
			print "Si desea salir apretar e\n";
			print "Filtro por central: ";	
			print "$rescentral\n";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtcentral = 1; $rescentral2="uno";}
			if($opc == 2){$uvtcentral = 2; $rescentral2="varios";}
			if($opc == 3){$uvtcentral = 3; $rescentral2="todos";}				
		}								
	}	
	if($opc eq "n"){
		$fcentral = 0;
		$rescentral = "no";
	}	

	while (($fcentral == -1) && ($opc ne "e")){
		
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "¿Desea filtrar por central? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$fcentral = 1;
			$rescentral = "si";		
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtcentral = 1; $rescentral2="uno";}
			if($opc == 2){$uvtcentral = 2; $rescentral2="varios";}
			if($opc == 3){$uvtcentral = 3; $rescentral2="todos";}
			while (($uvtcentral == -1) && ($opc ne "e")){
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n";
				print "Filtro por central: ";	
				print "$rescentral\n";
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){$uvtcentral = 1; $rescentral2="uno";}
				if($opc == 2){$uvtcentral = 2; $rescentral2="varios";}
				if($opc == 3){$uvtcentral = 3; $rescentral2="todos";}			
			}
		}	
		if($opc eq "n"){
			$fcentral = 0;
			$rescentral = "no";
		}			
	}
}


sub filtroAgente{
	
	system("clear");
	print "Elegir Filtros\n";
	print "Si desea salir apretar e\n";
	print "Filtro por central: ";	
	print "$rescentral";
	$aux = "("."$rescentral2".")\n";
	print "$aux";
	print "¿Desea filtrar por agente? [s/n] ";

	$opc = <STDIN>;
	chop($opc);
	if($opc eq "s"){
		$fagente = 1;
		$resagente = "si";
		print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvtagente = 1;$resagente2 = "uno";}
		if($opc == 2){$uvtagente = 2;$resagente2 = "varios";}
		if($opc == 3){$uvtagente = 3;$resagente2 = "todos";}
		while (($uvtagente == -1)&& ($opc ne "e")){
			system("clear");
			print "Elegir Filtros\n";
			print "Si desea salir apretar e\n";
			print "Filtro por central: ";	
			print "$rescentral";
			$aux = "("."$rescentral2".")\n";
			print "$aux";
			print "Filtro por agente: ";	
			print "$resagente\n";	
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtagente = 1;$resagente2 = "uno";}
			if($opc == 2){$uvtagente = 2;$resagente2 = "varios";}
			if($opc == 3){$uvtagente = 3;$resagente2 = "todos";}		
		}	
	}	
	if($opc eq "n"){
		$fagente = 0;
		$resagente = "no";
	}	

	while (($fagente == -1) && ($opc ne "e")){
		
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "Filtro por central: ";	
		print "$rescentral";
		$aux = "("."$rescentral2".")\n";
		print "$aux";
		print "¿Desea filtrar por agente? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$fagente = 1;
			$resagente = "si";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtagente = 1;$resagente2 = "uno";}
			if($opc == 2){$uvtagente = 2;$resagente2 = "varios";}
			if($opc == 3){$uvtagente = 3;$resagente2 = "todos";}
			while (($uvtagente == -1)&& ($opc ne "e")){
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n";
				print "Filtro por central: ";	
				print "$rescentral";
				$aux = "("."$rescentral2".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "$resagente\n";	
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){$uvtagente = 1;$resagente2 = "uno";}
				if($opc == 2){$uvtagente = 2;$resagente2 = "varios";}
				if($opc == 3){$uvtagente = 3;$resagente2 = "todos";}			
			}
		}	
		if($opc eq "n"){
			$fagente = 0;
			$resagente = "no";
		}	
	}	
}


sub filtroUmbral{

	system("clear");
	print "Elegir Filtros\n";
	print "Si desea salir apretar e\n";
	print "Filtro por central: ";	
	print "$rescentral";
	$aux = "("."$rescentral2".")\n";
	print "$aux";
	print "Filtro por agente: ";	
	print "$resagente";
	$aux = "("."$resagente2".")\n";
	print "$aux";
	
	print "¿Desea filtrar por umbral? [s/n] ";

	$opc = <STDIN>;
	chop($opc);
	if($opc eq "s"){
		$fumbral = 1;
		$resumbral = "si";
		print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvtumbral = 1;$resumbral2 ="uno";}
		if($opc == 2){$uvtumbral = 2;$resumbral2 ="varios";}
		if($opc == 3){$uvtumbral = 3;$resumbral2 ="todos";}
		while (($uvtumbral == -1)&& ($opc ne "e")){
			system("clear");
			print "Elegir Filtros\n";
			print "Si desea salir apretar e\n";	
			print "Filtro por central: ";	
			print "$rescentral";
			$aux = "("."$rescentral2".")\n";
			print "$aux";
			print "Filtro por agente: ";	
			print "$resagente";
			$aux = "("."$resagente2".")\n";
			print "$aux";
			print "Filtro por umbral: ";	
			print "$resumbral";
			$aux = "("."$resumbral2".")\n";
			print "$aux";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtumbral = 1;$resumbral2 ="uno";}
			if($opc == 2){$uvtumbral = 2;$resumbral2 ="varios";}
			if($opc == 3){$uvtumbral = 3;$resumbral2 ="todos";}
		}
	}	
	if($opc eq "n"){
		$fumbral = 0;
		$resumbral = "no";
	}	

	while (($fumbral == -1) && ($opc ne "e")){
		
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "Filtro por central: ";	
		print "$rescentral";
		$aux = "("."$rescentral2".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "$resagente";
		$aux = "("."$resagente2".")\n";
		print "$aux";
		print "¿Desea filtrar por umbral? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$fumbral = 1;
			$resumbral = "si";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtumbral = 1;$resumbral2 ="uno";}
			if($opc == 2){$uvtumbral = 2;$resumbral2 ="varios";}
			if($opc == 3){$uvtumbral = 3;$resumbral2 ="todos";}		
			while (($uvtumbral == -1)&& ($opc ne "e")){
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n";
				print "Filtro por central: ";	
				print "$rescentral";
				$aux = "("."$rescentral2".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "$resagente";
				$aux = "("."$resagente2".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "$resumbral";
				$aux = "("."$resumbral2".")\n";
				print "$aux";
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){$uvtumbral = 1;$resumbral2 ="uno";}
				if($opc == 2){$uvtumbral = 2;$resumbral2 ="varios";}
				if($opc == 3){$uvtumbral = 3;$resumbral2="todos";}
			}		
		}	
		if($opc eq "n"){
			$fumbral = 0;
			$resumbral = "no";
		}	
	}	
}


sub filtroTipo{
	system("clear");
	print "Elegir Filtros\n";
	print "Si desea salir apretar e\n";
	print "Filtro por central: ";	
	print "$rescentral";
	$aux = "("."$rescentral2".")\n";
	print "$aux";
	print "Filtro por agente: ";	
	print "$resagente";
	$aux = "("."$resagente2".")\n";
	print "$aux";
	print "Filtro por umbral: ";	
	print "$resumbral";
	$aux = "("."$resumbral2".")\n";
	print "$aux";			
	print "¿Desea filtrar por tipo? [s/n] ";

	$opc = <STDIN>;
	chop($opc);
	if($opc eq "s"){
		$ftipo = 1;
		$restipo = "si";
		print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvttipo = 1;$restipo2 ="uno";}
		if($opc == 2){$uvttipo = 2;$restipo2 ="varios";}
		if($opc == 3){$uvttipo = 3;$restipo2 ="todos";}
		while (($uvttipo == -1)&& ($opc ne "e")){
			system("clear");
			print "Elegir Filtros\n";
			print "Si desea salir apretar e\n";
			print "Filtro por central: ";	
			print "$rescentral";
			$aux = "("."$rescentral2".")\n";
			print "$aux";
			print "Filtro por agente: ";	
			print "$resagente";
			$aux = "("."$resagente2".")\n";
			print "$aux";
			print "Filtro por umbral: ";	
			print "$resumbral";
			$aux = "("."$resumbral2".")\n";
			print "$aux";		
			print "Filtro por tipo: ";	
			print "$restipo\n";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvttipo = 1;$restipo2 ="uno";}
			if($opc == 2){$uvttipo = 2;$restipo2 ="varios";}
			if($opc == 3){$uvttipo = 3;$restipo2 ="todos";}		
		}
	}	
	if($opc eq "n"){
		$ftipo = 0;
		$restipo = "no";
	}	

	while (($ftipo == -1) && ($opc ne "e")){
		
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "Filtro por central: ";	
		print "$rescentral";
		$aux = "("."$rescentral2".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "$resagente";
		$aux = "("."$resagente2".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "$resumbral";
		$aux = "("."$resumbral2".")\n";
		print "$aux";				
		print "¿Desea filtrar por tipo? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$ftipo = 1;
			$restipo = "si";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvttipo = 1;$restipo2 ="uno";}
			if($opc == 2){$uvttipo = 2;$restipo2 ="varios";}
			if($opc == 3){$uvttipo = 3;$restipo2 ="todos";}
			while (($uvttipo == -1)&& ($opc ne "e")){
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n";
				print "Filtro por central: ";	
				print "$rescentral";
				$aux = "("."$rescentral2".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "$resagente";
				$aux = "("."$resagente2".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "$resumbral";
				$aux = "("."$resumbral2".")\n";
				print "$aux";
				print "Filtro por tipo: ";	
				print "$restipo\n";
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){$uvttipo = 1;$restipo2 ="uno";}
				if($opc == 2){$uvttipo = 2;$restipo2 ="varios";}
				if($opc == 3){$uvttipo = 3;$restipo2 ="todos";}			
			}		
		}	
		if($opc eq "n"){
			$ftipo = 0;
			$restipo = "no";
		}	
	}	
}


sub filtroTiempo{
system("clear");
	$tvalido = -1;
	print "Elegir Filtros\n";
	print "Si desea salir apretar e\n";
	print "Filtro por central: ";	
	print "$rescentral";
	$aux = "("."$rescentral2".")\n";
	print "$aux";
	print "Filtro por agente: ";	
	print "$resagente";
	$aux = "("."$resagente2".")\n";
	print "$aux";
	print "Filtro por umbral: ";	
	print "$resumbral";
	$aux = "("."$resumbral2".")\n";
	print "$aux";	
	print "Filtro por tipo: ";	
	print "$restipo";			
	$aux = "("."$restipo2".")\n";
	print "$aux";			
	print "¿Desea filtrar por tiempo? [s/n] ";

	$opc = <STDIN>;
	chop($opc);
	if($opc eq "s"){
		$ftiempo = 1;
		$restiempo = "si";
		print "¿Cuantos tiempo desea filtrar en minutos?\n";
		$opc = <STDIN>;
		chop($opc);
		if ($opc =~ /^[+-]?\d+$/) {
			if ($opc > 0){
				$tvalido = 1;
				$ttiempo = $opc;
			}
		}		
		while (($tvalido == -1)&& ($opc ne "e")){
			system("clear");
			print "Elegir Filtros\n";
			print "Si desea salir apretar e\n";
			print "Filtro por central: ";	
			print "$rescentral";
			$aux = "("."$rescentral2".")\n";
			print "$aux";
			print "Filtro por agente: ";	
			print "$resagente";
			$aux = "("."$resagente2".")\n";
			print "$aux";
			print "Filtro por umbral: ";	
			print "$resumbral";
			$aux = "("."$resumbral2".")\n";
			print "$aux";	
			print "Filtro por tipo: ";	
			print "$restipo";			
			$aux = "("."$restipo2".")\n";
			print "$aux";
			print "Filtro por tiempo: ";	
			print "$restiempo\n";			
			print "¿Cuantos tiempo desea filtrar en minutos?\n";
			$opc = <STDIN>;
			chop($opc);
			if ($opc =~ /^[+-]?\d+$/) {
				if ($opc > 0){
					$tvalido = 1;
					$ttiempo = $opc;
				}
		
			}			
		}	

	}	
	if($opc eq "n"){
		$ftiempo = 0;
		$restiempo = "no";
	}	

	while (($ftiempo == -1) && ($opc ne "e")){
		
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";				
		print "Filtro por central: ";	
		print "$rescentral";
		$aux = "("."$rescentral2".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "$resagente";
		$aux = "("."$resagente2".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "$resumbral";
		$aux = "("."$resumbral2".")\n";
		print "$aux";	
		print "Filtro por tipo: ";	
		print "$restipo";			
		$aux = "("."$restipo2".")\n";
		print "$aux";					
		print "¿Desea filtrar por tiempo? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$ftiempo = 1;
			$restiempo = "si";
			print "¿Cuantos tiempo desea filtrar en minutos?\n";
			$opc = <STDIN>;
			chop($opc);
			if ($opc =~ /^[+-]?\d+$/) {
				if ($opc > 0){
					$tvalido = 1;
					$ttiempo = $opc;
				}
			}		
			while (($ftiempo == -1)&& ($opc ne "e")){
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n";
				print "Filtro por central: ";	
				print "$rescentral";
				$aux = "("."$rescentral2".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "$resagente";
				$aux = "("."$resagente2".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "$resumbral";
				$aux = "("."$resumbral2".")\n";
				print "$aux";	
				print "Filtro por tipo: ";	
				print "$restipo";			
				$aux = "("."$restipo2".")\n";
				print "$aux";
				print "Filtro por tiempo: ";
				print "$restiempo\n";			
				print "¿Cuantos tiempo desea filtrar en minutos?\n";
				$opc = <STDIN>;
				chop($opc);
				if ($opc =~ /^[+-]?\d+$/) {
					if ($opc > 0){
						$tvalido = 1;
						$ttiempo = $opc;
					}
				}		
			}	
		}	
		if($opc eq "n"){
			$ftipo = 0;
			$restiempo = "no";
		}	
	}
}


sub filtroNuma{
	system("clear");
	print "Elegir Filtros\n";
	print "Si desea salir apretar e\n";
	print "Filtro por central: ";	
	print "$rescentral";
	$aux = "("."$rescentral2".")\n";
	print "$aux";
	print "Filtro por agente: ";	
	print "$resagente";
	$aux = "("."$resagente2".")\n";
	print "$aux";
	print "Filtro por umbral: ";	
	print "$resumbral";
	$aux = "("."$resumbral2".")\n";
	print "$aux";	
	print "Filtro por tipo: ";	
	print "$restipo";			
	$aux = "("."$restipo2".")\n";
	print "$aux";
	print "Filtro por tiempo: ";
	print "$restiempo";	
	$aux = "("."$ttiempo".")\n";
	print "$aux";		
					
	print "¿Desea filtrar por num A? [s/n] ";

	$opc = <STDIN>;
	chop($opc);
	if($opc eq "s"){
		$fnuma = 1;
		$resnuma = "si";
		print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){$uvtnuma = 1;$resnuma2="uno";}
		if($opc == 2){$uvtnuma = 2;$resnuma2="varios";}
		if($opc == 3){$uvtnuma = 3;$resnuma2="todos";}
		while (($uvtnuma == -1)&& ($opc ne "e")){
			system("clear");
			print "Elegir Filtros\n";
			print "$rescentral";
			$aux = "("."$rescentral2".")\n";
			print "$aux";
			print "Filtro por agente: ";	
			print "$resagente";
			$aux = "("."$resagente2".")\n";
			print "$aux";
			print "Filtro por umbral: ";	
			print "$resumbral";
			$aux = "("."$resumbral2".")\n";
			print "$aux";	
			print "Filtro por tipo: ";	
			print "$restipo";			
			$aux = "("."$restipo2".")\n";
			print "$aux";
			print "Filtro por tiempo: ";
			print "$restiempo";	
			$aux = "("."$ttiempo".")\n";
			print "$aux";			
			print "Filtro por numa: ";	
			print "$resnuma\n";			
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtnuma = 1;$resnuma2="uno";}
			if($opc == 2){$uvtnuma = 2;$resnuma2="varios";}
			if($opc == 3){$uvtnuma = 3;$resnuma2="todos";}		
		}	
	}	
	if($opc eq "n"){
		$fnuma = 0;
		$resnuma = "no";
	}	

	while (($fnuma == -1) && ($opc ne "e")){
		
		system("clear");
		print "$rescentral";
		$aux = "("."$rescentral2".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "$resagente";
		$aux = "("."$resagente2".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "$resumbral";
		$aux = "("."$resumbral2".")\n";
		print "$aux";	
		print "Filtro por tipo: ";	
		print "$restipo";			
		$aux = "("."$restipo2".")\n";
		print "$aux";	
		print "Filtro por tiempo: ";
		print "$restiempo\n";	
		$aux = "("."$ttiempo".")\n";
		print "$aux";					
		print "¿Desea filtrar por numa? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$fnuma = 1;
			$resnuma = "si";
			print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
			$opc = <STDIN>;
			chop($opc);
			if($opc == 1){$uvtnuma = 1;$resnuma2="uno";}
			if($opc == 2){$uvtnuma = 2;$resnuma2="varios";}
			if($opc == 3){$uvtnuma = 3;$resnuma2="todos";}
			while (($uvtnuma == -1)&& ($opc ne "e")){
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n";
				print "$rescentral";
				$aux = "("."$rescentral2".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "$resagente";
				$aux = "("."$resagente2".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "$resumbral";
				$aux = "("."$resumbral2".")\n";
				print "$aux";	
				print "Filtro por tipo: ";	
				print "$restipo";			
				$aux = "("."$restipo2".")\n";
				print "$aux";				
				print "Filtro por tiempo: ";
				print "$restiempo\n";	
				$aux = "("."$$ttiempo".")\n";
				print "$aux";
				print "Filtro por numa: ";	
				print "$resnuma\n";			
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){$uvtnuma = 1;$resnuma2="uno";}
				if($opc == 2){$uvtnuma = 2;$resnuma2="varios";}
				if($opc == 3){$uvtnuma = 3;$resnuma2="todos";}			}	
		}	
		if($opc eq "n"){
			$fnuma = 0;
			$resnuma = "no";
		}	
	}
}

sub iniciarBusqueda{


	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
	}

	$direcdef = "$Dir"."/default.txt";
	open (DEFAULT,$direcdef);
	@regs=<DEFAULT>;
	$it1=0;
	foreach $t (@regs){
		if ($it1==0){@tc=split(";",$t);}
		if ($it1==1){@ta=split(";",$t);}
		if ($it1==2){@tu=split(";",$t);}
		if ($it1==3){@tt=split(";",$t);}
		if ($it1==4){@tar=split(";",$t);}
		if ($it1==5){@tn=split(";",$t);}
			
	$it1 = $it1+1;	
	}
	close(DEFAULT);	

	opendir(DIR, "$direcPeligrosas");
	@FILES = readdir(DIR);
	foreach $file (@FILES) {

		open (ARCH,"$direcPeligrosas/$file");
		@registros=<ARCH>;

		foreach $peligro (@registros){
			@aux=split(";",$peligro);
			$imprimo = 1;


			#CENTRAL			
						
			if($fcentral==1){
				if ($uvtcentral == 1){
					if (@aux[0] ne @tc[0]){
						$imprimo = 0;					
					}
				}
				if ($uvtcentral == 2){
					if ((@aux[0] ne @tc[0]) &&
        				    (@aux[0] ne @tc[1]) &&
					    (@aux[0] ne @tc[2])){$imprimo =0;}
					
				}
			}
				
			#AGENTE
			#print"@aux[1] ";
			#print"@ta[0]\n";
			if($fagente==1){
				if ($uvtagente == 1){
					if (@aux[1] ne @ta[0]){
						$imprimo = 0;					
					}
				}
				if ($uvtagente == 2){
					if ((@aux[1] ne @ta[0]) &&
        				    (@aux[1] ne @ta[1]) &&
					    (@aux[1] ne @ta[2])){$imprimo =0;}
					
				}

			} 
			
			#UMBRAL
			if($fumbral==1){
				if ($uvtumbral == 1){
					if (@aux[2] ne @tu[0]){
						$imprimo = 0;					
					}
				}
				if ($uvtumbral == 2){
					if ((@aux[2] ne @tu[0]) &&
        				    (@aux[2] ne @tu[1]) &&
					    (@aux[2] ne @tu[2])){$imprimo =0;}
					
				}
			}
	
			#TIPO
			if($ftipo==1){
				if ($uvttipo == 1){
					if (@aux[3] ne @tt[0]){
						$imprimo = 0;					
					}
				}
				if ($uvttipo == 2){
					if ((@aux[3] ne @tt[0]) &&
        				    (@aux[3] ne @tt[1])){$imprimo =0;}
					
				}
				
			}
	
			#TIEMPO
			if($ftiempo ==1){
				if ($ttiempo > @aux[5]){
					$imprimo =0;
				}
			}

			#NUMA
			if($fnuma==1){
				if ($uvtnuma == 1){
					if ((@aux[6] ne @tar[0])||(@aux[2] ne @tn[0])){
						$imprimo = 0;					
					}
				}
				if ($uvtnuma == 2){
					if ((@aux[6] ne @tar[0])||(@aux[7] ne @tn[0]) &&
        				    (@aux[6] ne @tar[1])||(@aux[7] ne @tn[0]) &&
					    (@aux[6] ne @tar[2])||(@aux[7] ne @tn[0])){$imprimo =0;}
					
				}
				
			}
		if ($grabar == 1){
			if ($imprimo){
				print FICH $peligro; 				
			}
		}
		else{
			if ($imprimo == 1){
				print "$peligro";
			}
		}
			
		}
		close (ARCH);
	}
	closedir(DIR);	
	close(FICH);
}

sub pregunta{
	$inicBusq = -1;
	system("clear");
	print "Elegir Filtros\n";
	print "Si desea salir apretar e\n";
	print "Filtro por central: ";		
	print "$rescentral";
	$aux = "("."$rescentral2".")\n";
	print "$aux";
	print "Filtro por agente: ";	
	print "$resagente";
	$aux = "("."$resagente2".")\n";
	print "$aux";
	print "Filtro por umbral: ";	
	print "$resumbral";
	$aux = "("."$resumbral2".")\n";
	print "$aux";	
	print "Filtro por tipo: ";	
	print "$restipo";			
	$aux = "("."$restipo2".")\n";
	print "$aux";
	print "Filtro por tiempo: ";
	print "$restiempo";	
	$aux = "("."$ttiempo".")\n";
	print "$aux";			
	print "Filtro por num A: ";
	print "$resnuma";	
	$aux = "("."$resnuma2".")\n";
	print "$aux";			
	
	print "¿Desea iniciar la busqueda con estos filtros? [s/n] ";

	$opc = <STDIN>;
	chop($opc);
	if($opc eq "s"){
		$inicBusq = 1;
		iniciarBusqueda();
	}	
	if($opc eq "n"){
		$inicBusq = 0;  	
	}	

	while (($inicBusq == -1) && ($opc ne "e")){
		
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
		print "$rescentral";
		$aux = "("."$rescentral2".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "$resagente";
		$aux = "("."$resagente2".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "$resumbral";
		$aux = "("."$resumbral2".")\n";
		print "$aux";	
		print "Filtro por tipo: ";	
		print "$restipo";			
		$aux = "("."$restipo2".")\n";
		print "$aux";
		print "Filtro por tiempo: ";
		print "$restiempo";	
		$aux = "("."$ttiempo".")\n";
		print "$aux";			
		print "Filtro por num A: ";
		print "$resnuma";	
		$aux = "("."$resnuma2".")\n";
		print "$aux";			
					
		print "¿Desea iniciar la busqueda con estos filtros? [s/n] ";

		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			$inicBusq = 1;
			iniciarBusqueda();
					
		}	
		if($opc eq "n"){
			$inicBusq =0;
		}	
	}


}

sub ElegFiltros{
	$fcentral = -1;
	$rescentral = "";
	$rescentral2 = "";
	$uvtcentral = -1;
		
	$fagente = -1;
	$resagente= "";
	$resagente2= "";
	$uvtagente = -1;
	
	$fumbral = -1;
	$resumbral = "";
	$resumbral2= "";
	$uvtumbral = -1;

	$ftipo = -1;
	$restipo= "";
	$restipo2= "";
	$uvttipo = -1;

	$ftiempo = -1;
	$restiempo = "";
	$restiempo2 = "";
	$ttiempo =-1;

	$fnuma = -1;
	$resnuma= "";
	$resnuma2= "";
	$uvtnuma = -1;
	
	filtroCent();
	if ($opc ne "e"){	
		filtroAgente();
		if ($opc ne "e"){
			filtroUmbral();			
			if ($opc ne "e"){
				filtroTipo();
				if($opc ne "e"){
					filtroTiempo();
					if ($opc ne "e"){
						filtroNuma();	
						if ($opc ne "e"){
							pregunta();
						}
					}
				}
			}
		}	
	}
	while ($opc ne "e" && ($fcentral+$fagente+$fumbral+$ftiempo+$ftipo+$fnuma < 1)) {
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n";
 		
		$fcentral = -1;
		$rescentral = "";
		$uvtcentral = -1;
	
		$fagente = -1;
		$resagente= "";
		$uvtagente = -1;
	
		$fumbral = -1;
		$resumbral = "";
		$uvtumbral = -1;
	
		$ftipo = -1;
		$restipo= "";
		$uvttipo = -1;
	
		$ftiempo = -1;
		$restiempo = "";
		$uvttiempo = -1;
	
		$fnuma = -1;
		$resnuma= "";
		$uvtnuma = -1;
	
		filtroCent();
		if ($opc ne "e"){	
			filtroAgente();
			if ($opc ne "e"){
				filtroUmbral();			
				if ($opc ne "e"){
					filtroTipo();
					if($opc ne "e"){
						filtroTiempo();
						if ($opc ne "e"){
							filtroNuma();	
							if($opc ne "e"){
								pregunta();
							}
						}
					}
				}
			}	
		}
	}
}
	

sub Menur {
	system("clear");
	print "Menu de consultas\n";
	print "Si desea filtrar los archivos a leer ingresar 1\n";			
	print "Si desea comenzar la eleccion de filtros ingresar 2\n";			
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Menu de consultas\n";
		print "Si desea filtrar los archivos a leer ingresar 1\n";			
		print "Si desea comenzar la eleccion de filtros ingresar 2\n";			
		print "Si desea salir apretar s\n";
		if ($opc == 1){
			IngresarInput();
		}
		else{
			if ($opc == 2){
				ElegFiltros();
			}
		}
 		$opc = <STDIN>;
 		chop($opc);
	}
	MenuPal(); 			
}
sub DarRankCent{
	system("clear");
	print "Top 5 de centrales con más llamadas peligrosas\n";
	top5Centrales();
	print "Si desea salir apretar s\n";		
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de centrales con más llamadas peligrosas\n";
		top5Centrales();
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
}
sub DarRankOfic{
	system("clear");
	print "Top 5 de oficinas con más llamadas peligrosas\n";
	top5Oficinas();
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de oficinas con más llamadas peligrosas\n";
		top5Oficinas();		
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
}
sub DarRankAgen{
	system("clear");
	print "Top 5 de Agentes con más llamadas peligrosas\n";
	top5Agentes();
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de Agentes con más llamadas peligrosas\n";
		top5Agentes();		
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}

}
sub DarRankDest{
	system("clear");
	print "Top 5 de Destinos con más llamadas peligrosas\n";
	top5Areas();
	top5Paises();
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de Destinos con más llamadas peligrosas\n";
		top5Areas();
		top5Paises();		
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}

}
sub DarRankUmbr{
	system("clear");
	print "Top 5 de umbrales con más llamadas peligrosas\n";
	top5Umbrales();
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de umbrales con más llamadas peligrosas\n";
		top5Umbrales();	
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}

}
	
sub Menus {
	system("clear");
	print "Menu de estadisticas de llamadas peligrosas\n";
	print "marque 1 si desea obtener el ranking con las centrales con más llamadas peligrosas\n";
	print "marque 2 si desea obtener el ranking con las oficinas con más llamadas peligrosas\n";
	print "marque 3 si desea obtener el ranking con los agentes con más llamadas peligrosas\n";
	print "marque 4 si desea obtener el ranking con los destinos con más llamadas peligrosas\n";
	print "marque 5 si desea obtener el ranking con los umbrales con más llamadas peligrosas\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		
		if ($opc == 1) {
			DarRankCent();
		}
		else{
			if ($opc == 2) {
				DarRankOfic();
			}
			else{
				if ($opc == 3){
					DarRankAgen();				
				}
				else{
					if ($opc == 4){
						DarRankDest();
					}
					else{
						if ($opc == 5){
							DarRankUmbr();
						}
						else{
							system("clear");
	print "Menu de estadisticas de llamadas peligrosas\n";
	print "marque 1 si desea obtener el ranking con las centrales con más llamadas peligrosas\n";
	print "marque 2 si desea obtener el ranking con las oficinas con más llamadas peligrosas\n";
	print "marque 3 si desea obtener el ranking con los agentes con más llamadas peligrosas\n";
	print "marque 4 si desea obtener el ranking con los destinos con más llamadas peligrosas\n";
	print "marque 5 si desea obtener el ranking con los umbrales con más llamadas peligrosas\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);				
						}			
					}																		
				}
			}
		}
	}
	MenuPal(); 			
}

sub Menue {
	system("clear");
	}


#--------------------------------------------------------------------------------
# TOP 5         CENTRALES
#--------------------------------------------------------------------------------

sub top5Centrales{
	# se tiene un array de centrales
	
	my @valores = [];	
	@claves=keys(%hashcentrales);
	my $arrSize = @claves;
	
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashcentrales{@claves[$p]}};
	
		$tripleta = "@aux[2]|@aux[0]|@aux[1]";		
		push(@valores,$tripleta);
			
	}
	@ordencentrales = sort { $a <=> $b } @valores;
	pop(@ordencentrales); 
	@ordencentrales=reverse(@ordencentrales);

	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordencentrales){
			if ($i<6){		
				($cantVeces,$id,$nom) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." es decir,"."$nom";
				print FICH $aux; 		
			 	print FICH "\n";
			}
			$i=$i+1;
		}
		close (FICH); 
	}

	else{
		foreach	$variable (@ordencentrales){
			if ($i<6){		
				($cantVeces,$id,$nom) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." es decir,"."$nom";
				print"$aux\n";
			}
			$i=$i+1;
		}	
	}
}	


#--------------------------------------------------------------------------------
# TOP 5         AGENTES
#--------------------------------------------------------------------------------

sub top5Agentes{
	# se tiene un array de agentes
	my @valores = [];	
	@claves=keys(%hashagentes);
	my $arrSize = @claves;

	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashagentes{@claves[$p]}};
		$sexteta = "@aux[5]|@aux[0]|@aux[1]|@aux[2]|@aux[3]|@aux[4]";				
		push(@valores,$sexteta);
		#print "$sexteta\n";
			
	}
	@ordenagentes = sort { $a <=> $b } @valores; 
	pop(@ordenagentes);
	@ordenagentes=reverse(@ordenagentes);

	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordenagentes){
			if ($i<6){		
				($cantVeces,$id,$nom,$ap,$ofi,$correo) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." cuyo nombre es,"."$nom"." y su correo es "."$correo";
				print FICH $aux; 		
			 	print FICH "\n";
			}
			$i=$i+1;
		}
		close (FICH); 
	}

	else{
		foreach	$variable (@ordenagentes){
			if ($i<6){		
				#print "$variable\n";
				($cantVeces,$id,$nom,$ap,$ofi,$correo) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." cuyo nombre es,"."$nom"." y su correo es "."$correo";
				print"$aux\n";		
			}
			$i=$i+1;
		}
	}
}	

#--------------------------------------------------------------------------------
# TOP 5         OFICINAS 
#--------------------------------------------------------------------------------

sub top5Oficinas{
	
	# se tiene un array de oficinas
	my @valores = [];
	@claves=keys(%hashoficinas);
		
	my $arrSize = @claves;
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashoficinas{@claves[$p]}};
		#print "$arrSize\n";		
		$dupla = "@aux[1]|@aux[0]";				
		push(@valores,$dupla);
		#print "$dupla\n";
	}
	@ordenoficinas = sort { $a <=> $b } @valores; 
	pop(@ordenoficinas);
	@ordenoficinas=reverse(@ordenoficinas);
	
	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordenoficinas){
			if ($i<6){		
				($cantVeces,$id) = split(/\|/,$variable);
				$aux = "La oficina numero "."$i"." del ranking es "."$id";		
				print FICH $aux; 		
			 	print FICH "\n";
			}
			$i=$i+1;
		}
		close (FICH); 
	}

	else{
		foreach	$variable (@ordenoficinas){
			if ($i<5){		
				#print "$variable\n";
				($cantVeces,$id) = split(/\|/,$variable);
				$a = $i +1;
				$aux = "La oficina numero "."$a"." del ranking es "."$id";		
				print "$aux\n";		
			}
			$i=$i+1;
		}
	}
}

#--------------------------------------------------------------------------------
# TOP 5         UMBRALES
#--------------------------------------------------------------------------------

sub top5Umbrales{
	# se tiene un array de agentes
	my @valores = [];	
	@claves=keys(%hashumbrales);
	my $arrSize = @claves;
	#print "$arrSize\n";
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashumbrales{@claves[$p]}};
		$octeto = "@aux[7]|@aux[0]|@aux[1]|@aux[2]|@aux[3]|@aux[4]|@aux[5]|@aux[6]";
		#print "$octeto";		
		push(@valores,$octeto);
		#print "$octeto\n";
	}
	@ordenumbrales = sort { $a <=> $b } @valores; 
	pop(@ordenumbrales);
	@ordenumbrales=reverse(@ordenumbrales);
			
	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordenumbrales){
			if ($i<6){		
				($cantVeces,$id,$codOrig,$numOrig,$tipo,$codDest,$tope,$estado) = split(/\|/,$variable);
				if ($cantVeces > 0){
					$aux = "El numero "."$i"." del ranking tiene la id "."$id";
					print FICH $aux; 		
			 		print FICH "\n";	
				}
			}
			$i=$i+1;
		}
		close (FICH); 
	}

	else{

		foreach	$variable (@ordenumbrales){
			if ($i<6){
				#print "$variable\n";
				($cantVeces,$id,$codOrig,$numOrig,$tipo,$codDest,$tope,$estado) = split(/\|/,$variable);
				if ($cantVeces > 0){
					$aux = "El numero "."$i"." del ranking tiene la id "."$id";
					print "$aux\n";	
				}

				#print"$id\n";		
			}
			$i=$i+1;
		}
	}
}	

#--------------------------------------------------------------------------------
# TOP 5         PAISES
#--------------------------------------------------------------------------------

sub top5Paises{
	# se tiene un array de agentes
	my @valores = [];	
	@claves=keys(%hashpaises);
	my $arrSize = @claves;
	#print "$arrSize\n";
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashpaises{@claves[$p]}};
		$terna = "@aux[2]|@aux[0]|@aux[1]";
		push(@valores,$terna);
		#print "$terna\n";
			
	}
	@ordenpaises = sort { $a <=> $b } @valores; 
	pop(@ordenpaises);
	@ordenpaises=reverse(@ordenpaises);
	
	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordePAISES){
			if ($i<6){		
				($cantVeces,$id,$nom) = split(/\|/,$variable);
				print FICH $aux; 		
		 		print FICH "\n";	
			}
			$i=$i+1;
		}
		close (FICH); 
	}
	
	else{
		print "Top 5 de paises\n";
		foreach	$variable (@ordenpaises){
			if ($i<5){		
			#	print "$variable\n";
				($cantVeces,$id,$nom) = split(/\|/,$variable);
				$a = $i+1;
				print"$El numero "."$a"." del ranking es "."$nom\n";		
			}
			$i=$i+1;
		}
	}
}	

#--------------------------------------------------------------------------------
# TOP 5         AREAS
#--------------------------------------------------------------------------------

sub top5Areas{
	# se tiene un array de agentes
	my @valores = [];	
	@claves=keys(%hashareas);
	my $arrSize = @claves;
	#print "$arrSize\n";
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashareas{@claves[$p]}};
		$terna = "@aux[2]|@aux[0]|@aux[1]";
		push(@valores,$terna);
		#print "$terna\n";
			
	}
	@ordenareas = sort { $a <=> $b } @valores; 
	pop(@ordenareas);
	@ordenareas=reverse(@ordenareas);

	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
				$it = $it +1;
				$nom = "$GRABDIR"."$it".".txt";
			} 
			else {
	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordenareas){
			if ($i<6){		
				($cantVeces,$nom,$id) = split(/\|/,$variable);
				print FICH $aux; 		
		 		print FICH "\n";	
			}
			$i=$i+1;
		}
		close (FICH); 
	}
	
	else{
		print "Top 5 de areas\n";
		foreach	$variable (@ordenareas){
			if ($i<5){		
				#print "$variable\n";
				($cantVeces,$nom,$id) = split(/\|/,$variable);
			#	print"$id\n";	

				$a = $i+1;
				print"$El numero "."$a"." del ranking es "."$nom\n";	
			}
			$i=$i+1;
		}
	}
}	

#------------------------------------------------------------------
# main
#------------------------------------------------------------------

# SE REALIZA EL HASH DE CENTRALES: hashcentrales (ID central, Arrary:(ID CENTRAL, CENTRAL, cantVecesVisto))
	
	$direcCentrales="$ENV{'MAEDIR'}"."/CdC.mae";
	open (CENTRALES,$direcCentrales);
	#Añadimos cada línea de éste en la matriz. 
	@registros=<CENTRALES>; 
	my $hashcentrales={};

	# Mostramos los datos en pantalla 
	foreach $central (@registros){
		chomp($central);
		@aux=split(";",$central);
		push (@aux, 0);

		#print "$aux[1]";		
		@{$hashcentrales{$aux[0]}} = @aux;

		#my @arr = @{$hashcentrales{$aux[0]}};
		#print "$arr[1]\n";
	

	} 
	
	

	# Cerramos el fichero abierto 
	close (CENTRALES);

#---------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE OFICINAS: hashoficinas (ID oficina; ID oficina cantVeces visto)
	
	$direcAgentes="$ENV{'MAEDIR'}"."/agentes.mae";
	open (AGENTES,$direcAgentes);
	#Añadimos cada línea de éste en la matriz. 
	@registros=<AGENTES>; 
	my $hashoficinas={};

	# Mostramos los datos en pantalla 
	foreach $agente (@registros){
		chomp($agente);		
		@aux=split(";",$agente);
		push (@aux, 0);		
		if (exists($hashoficinas{"@aux[3]"})){
		}	
		else{
			@aux2[0] = @aux[3];			
			@aux2[1] = 0;
			@{$hashoficinas{$aux[3]}} = @aux2;				
			#my @arr = @{$hashoficinas{$aux[3]}};
			#print "$arr[1]\n";
			#print "$aux[3]\n";
			
		} 	

	}
	 
	# Cerramos el fichero abierto 
	close (AGENTES);

#--------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE AGENTES: hashagentes  (ID agente, Arrary:(ID AGENTE, NOM,AP,OFICINA,CORREO, cantVecesVisto))

	$direcAgentes="$ENV{'MAEDIR'}"."/agentes.mae";
	open (AGENTES,$direcAgentes);
	#Añadimos cada línea de éste en la matriz. 
	@registros=<AGENTES>; 
	my $hashagentes={};

	# Mostramos los datos en pantalla 
	foreach $agente (@registros){
		chomp($agente);
		@aux=split(";",$agente);		
		push (@aux, 0);		
		#print "@aux\n";
		@{$hashagentes{$aux[2]}} = @aux;				
	 	#print "$hashagentes{@aux[2]}";
		#my @arr = @{$hashagentes{$aux[2]}};
		#print "$arr[4]\n";
	
	}
 
	# Cerramos el fichero abierto 
	close (AGENTES);


#--------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE UMBRALES: hashumbrales 

	$direcUmbrales="$ENV{'MAEDIR'}"."/umbral.tab";
	open (UMBRALES,$direcUmbrales);
	#Añadimos cada línea de éste en la matriz. 
	@registros=<UMBRALES>; 
	my $hashumbrales ={};

	# Mostramos los datos en pantalla 
	foreach $umbral (@registros){
		chomp($umbral);
		#print "$umbral\n";		
		@aux=split(";",$umbral);
		push (@aux, 0);				
		@{$hashumbrales{$aux[0]}} = @aux;	 	
		#my @arr = @{$hashumbrales{$aux[0]}};
		#print "$arr[0]\n";
		#print "$aux[0]\n";
	
	}
	@claves=keys(%hashumbrales);
	close (UMBRALES);


#--------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE DESTINOS: hashpaises y hashareas

	# PAISES

	$direcPaises="$ENV{'MAEDIR'}"."/CdP.mae";
	open (PAISES,$direcPaises);
	#Añadimos cada línea de éste en la matriz. 
	@registros=<PAISES>; 
	my $hashpaises={};

	# Mostramos los datos en pantalla 
	foreach $pais (@registros){
		chomp($pais);		
		@aux=split(";",$pais);
		push (@aux, 0);	
		@{$hashpaises{$aux[0]}} = @aux;
	 	#print "$hashpaises{@aux[0]}\n";

	} 
	# Cerramos el fichero abierto 
	close (PAISES);

	# AREAS

	$direcAreas="$ENV{'MAEDIR'}"."/CdA.mae";
	open (AREAS,$direcAreas);
	#Añadimos cada línea de éste en la matriz. 
	@registros=<AREAS>; 
	my $hashareas={};

	# Mostramos los datos en pantalla 
	foreach $area (@registros){
		chomp($area);
		@aux=split(";",$area);
		push (@aux, 0);		
		@{$hashareas{$aux[1]}} = @aux;	
	
		#my @arr2 = @{$hashareas{$aux[1]}};
		#print "@arr2[1]\n";			 	
	} 
	# Cerramos el fichero abierto 
	close (AREAS);


#--------------------------------------------------------------------------------------
#BUCLE PPAL DE LLAMADAS PELIGROSAS 
	
	opendir(DIR, "$direcPeligrosas");
	@FILES = readdir(DIR);
	foreach $file (@FILES) {
		#print "nom: $file\n";

		open (PELIGROSAS,"$direcPeligrosas/$file");
		@registros=<PELIGROSAS>;
		#print "reg: @registros[0]\n";


		# Mostramos los datos en pantalla 
		foreach $peligro (@registros){
			@aux=split(";",$peligro);
			#print "aux: @aux[0]\n";
			
			#INICIAN LOS CHEQUEOS:
		
			# CENTRALES 
			if (exists($hashcentrales{"@aux[0]"})){	

				my @auxreg = @{$hashcentrales{@aux[0]}};
				@auxreg[2] = @auxreg[2] +1;
				@{$hashcentrales{$aux[0]}} = @auxreg;
				#my @arr = @{$hashcentrales{$aux[0]}};
				#print "$arr[2]\n";
			}
		
			# AGENTES
			if (exists($hashagentes{"@aux[1]"})){			
				my @auxreg1 = @{$hashagentes{@aux[1]}};
				@auxreg1[5] = @auxreg1[5] +1;
				@{$hashagentes{$aux[1]}} = @auxreg1;
				my @arr2 = @{$hashagentes{$aux[1]}};
				#print "$arr2[6]\n";
				
				# OFICINAS
				if (exists($hashoficinas{"@auxreg1[3]"})){
					my @auxreg11 = @{$hashoficinas{@auxreg1[3]}};
					@auxreg11[1] = @auxreg1[1] +1;
					@{$hashoficinas{$auxreg1[3]}} = @auxreg11;
					#my @arr2 = @{$hashoficinas{$auxreg1[3]}};
					#print "$arr2[0]\n";
				}	
			}
	
			# PAISES
			if (exists($hashpaises{"@aux[8]"})){			
				my @auxreg3 = @{$hashpaises{@aux[8]}};
				#print "$auxreg3[2]\n";				
				@auxreg3[2] = @auxreg3[2] +1;
				@{$hashpaises{$aux[8]}} = @auxreg3;
				
				#my @arr2 = @{$hashpaises{$aux[8]}};
				#print "$arr2[1]\n";
					
		
			}
	
			# AREAS
			if (exists($hashareas{"@aux[9]"})){			
				my @auxreg4 = @{$hashareas{@aux[9]}};
				#print "$auxreg4[0]\n";				
				@auxreg4[2] = @auxreg4[2] +1;
				@{$hashareas{$aux[9]}} = @auxreg4;
				#my @arr2 = @{$hashareas{$aux[2]}};
				#print "$arr2[2]\n";
					
		
			}
			# UMBRALES 
			if (exists($hashumbrales{"@aux[2]"})){			
				my @auxreg6 = @{$hashumbrales{@aux[2]}};
				@auxreg6[7] = @auxreg[7] +1;
				#print "@auxreg6[5]\n";
				@{$hashumbrales{$aux[2]}} = @auxreg6;
				my @arr = @{$hashumbrales{$aux[2]}};
				#print "$arr[0]\n";
			}
			
		

		} 
		# Cerramos el fichero abierto 
		close (PELIGROSAS);
	}
	closedir(DIR);		

MenuPal();

} else {
	print "[ERROR] El entorno ya ha sido configurado. No se puede inicializar el entorno 2 veces en una misma sesión\n";
}