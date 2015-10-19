#!/bin/perl

#-------------------------------------------------------------------#
#                          VARIABLES                                #
#-------------------------------------------------------------------#

#agente = 0
#central = 1
#umbral = 2
#tipo = 3
#numa = 4
#oficina = 5
#año/mes filtros= 6
#año/mes estadistica =7

$GRABDIR_CONSULTAS = "$ENV{'REPODIR'}/consulta";
$GRABDIR_RANKING = "$ENV{'REPODIR'}/estadistica";
$Dir= "$ENV{'BINDIR'}";
$direcPeligrosas="$ENV{'PROCDIR'}"."/";

$cantFilt = 9;
$grabar = 0;   #contiene info sobre si se va a grabar la prox busqueda 1=si, 0=no
@uvt = (-1,-1,-1,-1,-1,-1,-1,-1); # uno vario o todos 
@tieneFiltro = (-1,-1,-1,-1,-1,-1,-1,-1); 
@resuvt = ("","","","","","","",""); #en palabras el res de uvt "uno" "varios" "todos"
@resFiltro = ("","","","","","","",""); #en palabras el res de Tiene filtro "si" "no"

$ftiempo = -1;
$restiempo = "";
$ttiempo = -1;

$tiempoCantidad = 1;

#-------------------------------------------------------------------#
#-                     RUTINAS GRAFICAS                             #
#-------------------------------------------------------------------#

sub MenuPal {
	do{
		print "AFRALIST\n\n";
		system("clear");
		print "MenuPPAL\n";
		print "________\n\n";
		print "Ingrese '-h' para pedir ayuda\n";
		print "Ingrese '-w' para grabar\n";
		print "Ingrese '-r' para realizar una consulta\n";
		print "Ingrese '-s' para ver estadisticas\n";
		print "Ingrese '-e' para salir\n";
		$menu = <STDIN>;
		chomp($menu);
		if ($menu eq "-h") { Menuh();} 
		else {
			if ($menu eq "-w") { Menuw();} 
			else {
				if ($menu eq "-r") { Menur();} 
				else {
					if ($menu eq "-s") { Menus();} 					
				}
			}	
		}	
	}while($menu ne "-e");
}

sub Menuh {
	do{
		system("clear");
		print "Menu de ayuda\n";
		print "Si desea salir apretar s\n\n";
	
		print "Se cuenta con un archivo default.txt\n";
		print "El filtrado por una id particular implica obtener registros que contienen dicho campo\n";
		print "En el mismo, cada linea representa los filtros de id de centrales, agentes, umbrales, tipo de llamada, area ,numero de linea, oficinas y año mes\n";
		print "Es indispensable tener al menos un filtro por linea\n\n";
		print "Se pueden agregar la cantidad de campos que se quieran siempre y cuando se los separe por ;\n";
		print "Cada linea del archivo default.txt debe terminar con un ;\n";
		print "Se debera cambiar de forma manual el archivo\n\n";
		print "Ante el filtro uno, se utilizara el primer id de cada campo\n";
		print "Ante el filtro varios, se utilizaran todos los ids de cada campo\n";
		print "Ante el filtro todos, utilizara todos los ids conocidos\n\n";
		$opc = <STDIN>;
		chomp($opc);
	
	}while( $opc ne "s" );	
}

sub Menuw {
	my $listo = 0;	
	do{
		system("clear");
		print "Menu de Grabacion\n";
		print "Si desea salir apretar e\n\n";
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
	}while(($opc ne "e") && ($listo != 1));
}

sub Menur {
	do{
		system("clear");
		print "Menu de consultas\n";
		print "Si desea salir apretar s\n\n";
		print "Si desea filtrar los archivos a leer 1\n";			
		print "Si desea comenzar la eleccion de filtros 2\n";			

		if ($opc == 1){ FiltrarArchConsultas();} else{
		if ($opc == 2){	ElegFiltrosConsultas(); }}
 		$opc = <STDIN>;
 		chop($opc);
	}while($opc ne "s");
}

sub Menus{
	do{
		system("clear");
		print "Si desea salir apretar s\n\n";
		print "1 si desea elegir como filtrar los archivos a rankear\n";
		print "2 si quiere ir al menu de rankings\n";
		$opc = <STDIN>;
		chomp($opc);	
		if($opc==1){ElegirRankTiempoCant();}
		if($opc==2){Rankings();}
	}while($opc ne "s");
}
	
sub Rankings {
	do{
		system("clear");
		LlenarPeligrosas();
		print "Si desea salir apretar s\n\n";
		print "Menu de estadisticas de llamadas peligrosas\n";
		print "marque 1 si desea obtener el ranking con las centrales con más llamadas peligrosas\n";
		print "marque 2 si desea obtener el ranking con las oficinas con más llamadas peligrosas\n";
		print "marque 3 si desea obtener el ranking con los agentes con más llamadas peligrosas\n";
		print "marque 4 si desea obtener el ranking con los destinos con más llamadas peligrosas\n";
		print "marque 5 si desea obtener el ranking con los umbrales con más llamadas peligrosas\n";
		$opc = <STDIN>;
		chomp($opc);
		if ($opc == 1) {DarRankCent();}
		if ($opc == 2) {DarRankOfic();}
		if ($opc == 3) {DarRankAgen();}
		if ($opc == 4) {DarRankDest();}
		if ($opc == 5) {DarRankUmbr();}
	}while($opc ne "s");	
}

#SALIDA
sub Menue {
	system("clear");
}

#SE FILTRAN LOS ARCH QUE SE LEEN EN LAS CONSULTAS
sub FiltrarArchConsultas(){
	do{
		system("clear");
		print "Filtrar archivos para consultas\n";
		print "Si desea salir apretar s\n\n";
		print "¿Cuantos filtros de oficina  desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){@uvt[5] = 1;}
		if($opc == 2){@uvt[5] = 2;}
		if($opc == 3){@uvt[5] = 3;}

	}while((@uvt[5] == -1)&& ($opc ne "s"));
	if($opc eq "s"){MenuPal();}
	do{
		system("clear");
		print "Filtrar archivos input\n";
		print "Si desea salir apretar s\n\n";	
		print "¿Cuantos filtros de año/mes  desea tener(1=uno/2=varios/3=todos)?\n";
		$opc = <STDIN>;
		chop($opc);
		if($opc == 1){@uvt[6] = 1;}
		if($opc == 2){@uvt[6] = 2;}
		if($opc == 3){@uvt[6] = 3;}

	}while((@uvt[6] == -1)&& ($opc ne "s"));
	if($opc ne "s"){ElegFiltrosConsultas();}
}
								
sub ElegFiltrosConsultas{
	do{
		my $num = 3; # aca puede ir cualquier num mayor a 1
		my $i = 0;
		# es 5 ya q no se desea tocar ni oficina ni año/mes
		while($i < 5){@uvt[$i]=-1;$i=$i+1;}
		$i = 0;			
		while($i < 5){@tieneFiltro[$i]=-1;$i=$i+1;}
		$i = 0;		
		while($i < 5){@resuvt[$i]="";$i=$i+1;}
		$i = 0;
		while($i < 5){@resFiltro[$i]="";$i=$i+1;}
	
		$ftiempo = -1;
		$restiempo = "";
		$ttiempo = -1;

		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n\n";
		
		if ($num<1){print "Se debe tener al menos un filtro para poder filtrar!\n";}
		filtroCent(); if ($opc ne "e"){	
		 filtroAgente(); if ($opc ne "e"){
		  filtroUmbral(); if ($opc ne "e"){
		   filtroTipo(); if ($opc ne "e"){
		    filtroTiempo(); if ($opc ne "e"){
		     filtroNuma(); if ($opc ne "e"){
		      pregunta(); 
		     }else{MenuPal();}
		    }else{MenuPal();}
		   }else{MenuPal();}
		  }else{MenuPal();}
		 }else{MenuPal();}
		}else{MenuPal();}
	$num = @tieneFiltro[0]+@tieneFiltro[1]+@tieneFiltro[2]+@tieneFiltro[3]+$ftiempo+@tieneFiltro[5];
	}while (($opc ne "e") && ($num < 1));
}

sub filtroCent{
	do{
		system("clear");
		print "Elegir Filtros\n";		
		print "Si desea salir apretar e\n\n";
		print "¿Desea filtrar por central? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			@tieneFiltro[0] = 1;
			@resFiltro[0] ="si";
			do{				
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n\n";
				print "Filtro por central: ";	
				print "@resFiltro[0]\n";
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){@uvt[0] = 1; @resuvt[0]="uno";}
				if($opc == 2){@uvt[0] = 2; @resuvt[0]="varios";}
				if($opc == 3){@uvt[0] = 3; @resuvt[0]="todos";}
			}while((@uvt[0] == -1)&& ($opc ne "e"));
		}	
		if($opc eq "n"){
			@tieneFiltro[0] = 0;
			@resFiltro[0] ="no";
		}	
	}while((@tieneFiltro[0] == -1) && ($opc ne "e"));
}

sub filtroAgente{
	do{
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n\n";
		print "Filtro por central: ";	
		print "@resFiltro[0]";
		$aux = "("."@resuvt[0]".")\n";
		print "$aux";
		print "¿Desea filtrar por agente? [s/n] ";
	
		$opc = <STDIN>;
		chop($opc);
		if ($opc eq "s"){
			@tieneFiltro[1] = 1;
			@resFiltro[1] = "si";
			do{
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n\n";
				print "Filtro por central: ";	
				print "@resFiltro[0]";
				$aux = "("."@resuvt[0]".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "@resFiltro[1]\n";	
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){@uvt[1] = 1;@resuvt[1] = "uno";}
				if($opc == 2){@uvt[1] = 2;@resuvt[1] = "varios";}
				if($opc == 3){@uvt[1] = 3;@resuvt[1] = "todos";}

			}while((@uvt[1] == -1)&& ($opc ne "e"));
		}
		if($opc eq "n"){
			@tieneFiltro[1] = 0;
			@resFiltro[1] = "no";
		}
	}while(($fagente == -1) && ($opc ne "e"));
}

sub filtroUmbral{
	do{
		system("clear");
		print "Elegir Filtros\n";	
		print "Si desea salir apretar e\n\n";
		print "Filtro por central: ";	
		print "@resFiltro[0]";
		$aux = "("."@resuvt[0]".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "@resFiltro[1]";
		$aux = "("."@resuvt[1]".")\n";
		print "$aux";
		print "¿Desea filtrar por umbral? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if($opc eq "s"){
			@tieneFiltro[2] = 1;
			@resFiltro[2] = "si";
			do{
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n\n";	
				print "Filtro por central: ";	
				print "@resFiltro[0]";
				$aux = "("."@resuvt[0]".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "@resFiltro[1]";
				$aux = "("."@resuvt[1]".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "@resFiltro[2]";
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){@uvt[2] = 1;@resuvt[2] ="uno";}
				if($opc == 2){@uvt[2] = 2;@resuvt[2] ="varios";}
				if($opc == 3){@uvt[2] = 3;@resuvt[2] ="todos";}
			
			}while((@uvt[2] == -1)&& ($opc ne "e"));
		}
		if($opc eq "n"){
			@tieneFiltro[2] = 0;
			@resFiltro[2] = "no";
		}
	}while((@tieneFiltro[2] == -1) && ($opc ne "e"));
}

sub filtroTipo{
	do{
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n\n";
		print "Filtro por central: ";	
		print "@resFiltro[0]";
		$aux = "("."@resuvt[0]".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "@resFiltro[1]";
		$aux = "("."@resuvt[1]".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "@resFiltro[2]";
		$aux = "("."@resuvt[2]".")\n";
		print "$aux";			
		print "¿Desea filtrar por tipo? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if($opc eq "s"){
			@tieneFiltro[3] = 1;
			@resFiltro[3] = "si";
			do{
				system("clear");
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n\n";
				print "Filtro por central: ";	
				print "@resFiltro[0]";
				$aux = "("."@resuvt[0]".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "@resFiltro[1]";
				$aux = "("."@resuvt[1]".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "@resFiltro[2]";
				$aux = "("."@resuvt[2]".")\n";
				print "$aux";		
				print "Filtro por tipo: ";	
				print "@resFiltro[3]\n";
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){@uvt[3] = 1;@resuvt[3] ="uno";}
				if($opc == 2){@uvt[3] = 2;@resuvt[3] ="varios";}
				if($opc == 3){@uvt[3] = 3;@resuvt[3] ="todos";}
			}while((@uvt[3] == -1)&& ($opc ne "e"));
		}
		if($opc eq "n"){
			@tieneFiltro[3] = 0;
			@resFiltro[3] = "no";
		}
	}while((@tieneFiltro[3] == -1) && ($opc ne "e"));
}

sub filtroTiempo{
	do{
		system("clear");
		$tvalido = -1;
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n\n";
		print "Filtro por central: ";	
		print "@resFiltro[0]";
		$aux = "("."@resuvt[0]".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "@resFiltro[1]";
		$aux = "("."@resuvt[1]".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "@resFiltro[2]";
		$aux = "("."@resuvt[2]".")\n";
		print "$aux";	
		print "Filtro por tipo: ";	
		print "@resFiltro[3]";			
		$aux = "("."@resuvt[3]".")\n";
		print "$aux";			
		print "¿Desea filtrar por tiempo? [s/n] ";
		$opc = <STDIN>;
		chop($opc);

		if($opc eq "s"){
			$ftiempo = 1;
			$restiempo = "si";		
			do{
				system("clear");
				print "Elegir Filtros\n\n";
				print "Si desea salir apretar e\n";
				print "Filtro por central: ";	
				print "@resFiltro[0]";
				$aux = "("."@resuvt[0]".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "@resFiltro[1]";
				$aux = "("."@resuvt[1]".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "@resFiltro[2]";
				$aux = "("."@resuvt[2]".")\n";
				print "$aux";	
				print "Filtro por tipo: ";	
				print "@resFiltro[3]";			
				$aux = "("."@resuvt[3]".")\n";
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
			}while(($tvalido == -1)&& ($opc ne "e"));
		}
		if($opc eq "n"){
			$ftiempo = 0;
			$restiempo = "no";
		}
	}while(($ftiempo == -1) && ($opc ne "e"));
}
			
sub filtroNuma{
	do{
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n\n";
		print "Filtro por central: ";	
		print "@resFiltro[0]";
		$aux = "("."@resuvt[0]".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "@resFiltro[1]";
		$aux = "("."@resuvt[1]".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "@resFiltro[2]";
		$aux = "("."@resuvt[2]".")\n";
		print "$aux";	
		print "Filtro por tipo: ";	
		print "@resFiltro[3]";			
		$aux = "("."@resuvt[3]".")\n";
		print "$aux";
		print "Filtro por tiempo: ";
		print "$restiempo";	
		$aux = "("."$ttiempo".")\n";
		print "$aux";		

		print "¿Desea filtrar por num A? [s/n] ";
		$opc = <STDIN>;
		chop($opc);
		if($opc eq "s"){
			@tieneFiltro[4] = 1;
			@resFiltro[4] = "si";
			do{
				system("clear");	
				print "Elegir Filtros\n";
				print "Si desea salir apretar e\n\n";
				print "Filtro por central: ";
				print "@resFiltro[0]";
				$aux = "("."@resuvt[0]".")\n";
				print "$aux";
				print "Filtro por agente: ";	
				print "@resFiltro[1]";
				$aux = "("."@resuvt[1]".")\n";
				print "$aux";
				print "Filtro por umbral: ";	
				print "@resFiltro[2]";
				$aux = "("."@resuvt[2]".")\n";
				print "$aux";	
				print "Filtro por tipo: ";	
				print "@resFiltro[3]";			
				$aux = "("."@resuvt[3]".")\n";
				print "$aux";
				print "Filtro por tiempo: ";
				print "$restiempo";	
				$aux = "("."$ttiempo".")\n";
				print "$aux";			
				print "Filtro por numa: ";	
				print "@resFiltro[4]\n";			
				print "¿Cuantos filtros desea tener(1=uno/2=varios/3=todos)?\n";
				$opc = <STDIN>;
				chop($opc);
				if($opc == 1){@uvt[4] = 1;@resuvt[4]="uno";}
				if($opc == 2){@uvt[4] = 2;@resuvt[4]="varios";}
				if($opc == 3){@uvt[4] = 3;@resuvt[4]="todos";}
			}while((@uvt[4] == -1)&& ($opc ne "e"));
		}
		if($opc eq "n"){
			@tieneFiltro[4] = 0;
			@resFiltro[4] = "no";	
		}
	}while((@tieneFiltro[4] == -1) && ($opc ne "e"));
}

sub pregunta{
	do{
		$inicBusq = -1;
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar e\n\n";
		print "Filtro por central: ";		
		print "@resFiltro[0]";
		$aux = "("."@resuvt[0]".")\n";
		print "$aux";
		print "Filtro por agente: ";	
		print "@resFiltro[1]";
		$aux = "("."@resuvt[1]".")\n";
		print "$aux";
		print "Filtro por umbral: ";	
		print "@resFiltro[2]";
		$aux = "("."@resuvt[2]".")\n";
		print "$aux";	
		print "Filtro por tipo: ";	
		print "@resFiltro[3]";			
		$aux = "("."@resuvt[3]".")\n";
		print "$aux";
		print "Filtro por tiempo: ";
		print "$restiempo";	
		$aux = "("."$ttiempo".")\n";
		print "$aux";			
		print "Filtro por num A: ";
		print "@resFiltro[4]";	
		$aux = "("."@resuvt[4]".")\n";
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
	}while(($inicBusq == -1) && ($opc ne "e"));
}

#SE PIDE EL PERIODO 
sub Setearperiodo{
	do{	
		system("clear");
		print "setear periodo\n";
		print "Si desea salir apretar e\n\n";
		print "seleccione cuantos filtros desea tener (1=uno/2=varios/3=todos)\n";		
		$opc = <STDIN>;
		chomp($opc);
		if ($opc ==1){@uvt[7]=1;Menus();}
		if ($opc ==2){@uvt[7]=2;Menus();}
		if ($opc ==3){@uvt[7]=3;Menus();}
	}while($opc ne "e");	
}

#SE PIDE RANKING TIEMPO
sub ElegirRankTiempoCant{
	do{
		system("clear");
		print "Elegir tener el ranking segun tiempo o cantidad\n";
		print "Si desea salir apretar e\n\n";
		print "Si se quiere el ranking por cantidad 1\n";
		print "Si se quiere el ranking por tiempo 2\n";
		print "Si se quiere el ranking por cantidad y tiempo 3\n";
		$opc = <STDIN>;
		chomp($opc);
		if ($opc ==1){$tiempoCantidad=1;Menus();}
		if ($opc ==2){$tiempoCantidad=2;Setearperiodo();}
		if ($opc ==3){$tiempoCantidad=3;Setearperiodo();}	
	}while($opc ne "e");
}

#----------------------------------------------------------------------------#
#                          busqueda y filtrado                               #
#----------------------------------------------------------------------------#

sub iniciarBusqueda{
	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_CONSULTAS"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_CONSULTAS"."$it".".txt";
			} 
			else {$termine = 1;}
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
		if ($it1==6){@to=split(";",$t);}
		if ($it1==7){@tam=split(";",$t);}
		$it1 = $it1+1;	
	}
	close(DEFAULT);	
	
	opendir(DIR, "$direcPeligrosas");
	@FILES = readdir(DIR);
	foreach $file (@FILES) {
		
		#NOMAUX CONTIENE OFICINA _ AÑO/MES
		@nomaux = split("_",$file);
		$todook =1;
		
		#CHEQUEO DE ARCHIVOS DE OFICINAS
		if (@uvt[5]==1){
			if (@nomaux[0] ne @to[0]){			
				$todook=0;
			}
		}
		if (@uvt[5] == 2){
			$arrSize = @to;
			$i=0;
			$ok=1;
			while($i<=$arrSize){
				$todook=(@nomaux[0] ne @to[$i]) && $todook;
				$i=$i+1;				
			}
		}

		#CHEQUEO DE ARCHIVOS DE AÑO/MES
		if (@uvt[6] == 1){
			if (@nomaux[1] ne @tam[0]){			
				$todook=0;
			}
		}		
		if (@uvt[6] == 2){
			$arrSize = @to;
			$i=0;
			$ok=1;
			while($i<=$arrSize){
				$todook=(@nomaux[1] ne @tam[$i]) && $todook;
				$i=$i+1;				
			}
		}
		if ($todook==1){
		open (ARCH,"$direcPeligrosas/$file");
		@registros=<ARCH>;

		foreach $peligro (@registros){
			@aux=split(";",$peligro);
			$imprimo = 1;

			#CENTRAL									
			if(@tieneFiltro[0]==1){
				if (@uvt[0] == 1){
					if (@aux[0] ne @tc[0]){
						$imprimo = 0;					
					}
				}
				if (@uvt[0] == 2){
					$arrSize = @tc;
					$i=0;
					$ok=1;
					while($i<=$arrSize){
						$ok=(@aux[0] ne @tc[$i]) && $ok;
						$i=$i+1;				
					}
				}
			if ($ok){$imprimo =0;}
			}
				
			#AGENTE
			if(@tieneFiltro[1]==1){
				if (@uvt[1] == 1){
					if (@aux[1] ne @ta[0]){
						$imprimo = 0;					
					}
				}
				if (@uvt[1] == 2){
					$arrSize = @ta;
					$i=0;
					$ok=1;
					while($i<=$arrSize){
						$ok=(@aux[1] ne @ta[$i]) && ok;				
						$i=$i+1;
					}
					if ($ok){$imprimo =0;}
				}
			} 
			
			#UMBRAL
			if(@tieneFiltro[2]==1){
				if (@uvt[2] == 1){
					if (@aux[2] ne @tu[0]){
						$imprimo = 0;					
					}
				}

				if (@uvt[2] == 2){
					$arrSize = @tu;
					$i=0;
					$ok=1;
					while($i<=$arrSize){
						$ok=(@aux[2] ne @tu[$i]) && ok;				
						$i=$i+1;
					}
					if ($ok){$imprimo =0;}
				}
			}
	
			#TIPO
			if(@tieneFiltro[3]==1){
				if (@uvt[3] == 1){
					if (@aux[3] ne @tt[0]){
						$imprimo = 0;					
					}
				}
				if (@uvt[3] == 2){
					$arrSize = @tu;
					$i=0;
					$ok=1;
					while($i<=$arrSize){
						$ok=(@aux[3] ne @tt[$i]) && ok;				
						$i=$i+1;
					}
					if ($ok){$imprimo =0;}
				}
			}
	
			#TIEMPO
			if($ftiempo ==1){
				if ($ttiempo > @aux[5]){
					$imprimo =0;
				}
			}

			#NUMA
			if(@tieneFiltro[4]==1){
				if (@uvt[4] == 1){
					if ((@aux[6] ne @tar[0])||(@aux[2] ne @tn[0])){
						$imprimo = 0;					
					}
				}

				if (@uvt[4] == 2){
					$arrSize = @tu;
					$i=0;
					$ok=1;
					while($i<=$arrSize){
				 	        $ok=((@aux[6] ne @tar[$i])||(@aux[7] ne @tn[$i])) && $ok;
						$i=$i+1;
					}
					if ($ok){$imprimo =0;}
				}
			}
			if ($grabar == 1){
				if ($imprimo){print FICH $peligro;}
			}else{
				if ($imprimo == 1){print "$peligro";}
			}
		}
		close (ARCH);
		}
	}
	closedir(DIR);	
	close(FICH);
	print "Ingrese una tecla para continuar\n";
	$opc = <STDIN>;
}

#-----------------------------------------------------------------------------#
#                                   DAR RANKING                               #
#-----------------------------------------------------------------------------#

# RANKING CENTRALES HAY DE TIEMPO Y DE CANTIDAD
sub DarRankCent{
	if ($tiempoCantidad==1){
		do{
			system("clear");
			print "Si desea salir apretar s\n\n";
			print "Top 5 de centrales con más cantidad de llamadas peligrosas\n";
			top5CentralesCantidad();
	 		$opc = <STDIN> ;
	 		chop($opc);
		}while($opc ne "s");
	}
	if($tiempoCantidad==2){
		do{
			system("clear");
			print "Top 5 de centrales con más tiempo de llamadas peligrosas\n";
			print "Si desea salir apretar s\n\n";
			top5CentralesTiempo();
	 		$opc = <STDIN> ;
	 		chop($opc);
		}while($opc ne "s");
	}
	if($tiempoCantidad==3){
		do{
			system("clear");
			print "Si desea salir apretar s\n\n";
			print "Top 5 de centrales con más tiempo de llamadas peligrosas\n";
			top5CentralesTiempo();
			print "Top 5 de centrales con más cantidad de llamadas peligrosas\n";
			top5CentralesCantidad();
			$opc = <STDIN>;
			chomp($opc);
		}while ($opc ne "s");
	}
}

#RANKING DE OFICINA HAY DE TIEMPO Y DE CANTIDAD
sub DarRankOfic{
	if ($tiempoCantidad==1){
		do{					
			system("clear");
			print "Si desea salir apretar s\n\n";			
			print "Top 5 de oficinas con más cantidad de llamadas peligrosas\n";
			top5OficinasCantidad();
			$opc = <STDIN>;
			chomp($opc);	
		}while($opc ne "s");
	}
	if ($tiempoCantidad==2){
		do{
			system("clear");
			print "Si desea salir apretar s\n\n";
			print "Top 5 de oficinas con más tiempo de llamadas peligrosas\n";
			top5OficinasTiempo();
			$opc = <STDIN>;
			chomp($opc);			
		}while($opc ne "s");
	}
	if ($tiempoCantidad==3){
		do{
			system("clear");
			print "Si desea salir apretar s\n\n";
			print "Top 5 de oficinas con más tiempo de llamadas peligrosas\n";
			top5OficinasTiempo();
			print "Top 5 de oficinas con más cantidad de llamadas peligrosas\n";
			top5OficinasCantidad();			
			$opc = <STDIN>;
			chomp($opc);			
		}while($opc ne "s");
	}	
}

#RANKING DE AGENTES HAY DE TIEMPO Y DE CANTIDAD
sub DarRankAgen{
	if ($tiempoCantidad==1){
		do{					
			system("clear");
			print "Si desea salir apretar s\n\n";			
			print "Top 5 de agentes con más cantidad de llamadas peligrosas\n";
			top5AgentesCantidad();
			$opc = <STDIN>;
			chomp($opc);	
		}while($opc ne "s");
	}
	if ($tiempoCantidad==2){
		do{
			system("clear");
			print "Si desea salir apretar s\n\n";
			print "Top 5 de agentes con más tiempo de llamadas peligrosas\n";
			top5AgentesTiempo();
			$opc = <STDIN>;
			chomp($opc);			
		}while($opc ne "s");
	}
	if ($tiempoCantidad==3){
		do{
			system("clear");
			print "Si desea salir apretar s\n\n";
			print "Top 5 de agentes con más tiempo de llamadas peligrosas\n";
			top5AgentesTiempo();
			print "Top 5 de agentes con más cantidad de llamadas peligrosas\n";
			top5AgentesCantidad();			
			$opc = <STDIN>;
			chomp($opc);			
		}while($opc ne "s");
	}	
}

#RANKING DE DESTINOS 
sub DarRankDest{
	do{
		system("clear");
		print "Si desea salir apretar s\n\n";
		print "Top 5 de Areas con más llamadas peligrosas\n";
		top5Areas();
		print "\n";
		top5Paises();
		$opc = <STDIN>;
		chomp($opc);
	}while($opc ne "s");
}

#RANKING DE UMBRALES
sub DarRankUmbr{
	do{
		system("clear");
		print "Si desea salir apretar s\n\n";			
		print "Top 5 de umbrales con más llamadas peligrosas\n";
		top5Umbrales();
		$opc = <STDIN>;
		chomp($opc);
	}while($opc ne "s");
}

#--------------------------------------------------------------------------------
# TOP 5         CENTRALES
#--------------------------------------------------------------------------------

sub top5CentralesCantidad{
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
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
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
	}else{
		foreach	$variable (@ordencentrales){
			if ($i<6){		
				($cantVeces,$id,$nom) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." es decir,"."$nom"."y tiene $cantVeces veces visto";
				print"$aux\n";
			}
			$i=$i+1;
		}	
	}
}

sub top5CentralesTiempo{
	# se tiene un array de centrales
	my @valores = [];	
	@claves=keys(%hashcentrales);
	my $arrSize = @claves;
	
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashcentrales{@claves[$p]}};
	
		$tripleta = "@aux[3]|@aux[0]|@aux[1]";		
		push(@valores,$tripleta);	
	}
	@ordencentrales = sort { $a <=> $b } @valores;
	pop(@ordencentrales); 
	@ordencentrales=reverse(@ordencentrales);

	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordencentrales){
			if ($i<6){		
				($cantTiempo,$id,$nom) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." es decir,"."$nom";
				print FICH $aux; 		
			 	print FICH "\n";
			}
			$i=$i+1;
		}
		close (FICH); 
	}else{
		foreach	$variable (@ordencentrales){
			if ($i<6){		
				($cantTiempo,$id,$nom) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." es decir,"."$nom"."y tiene $cantTiempo min vistos";
				print"$aux\n";
			}
			$i=$i+1;
		}	
	}
}	

#--------------------------------------------------------------------------------
# TOP 5         AGENTES
#--------------------------------------------------------------------------------

sub top5AgentesCantidad{
	# se tiene un array de agentes
	my @valores = [];	
	@claves=keys(%hashagentes);
	my $arrSize = @claves;

	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashagentes{@claves[$p]}};
		$sexteta = "@aux[5]|@aux[0]|@aux[1]|@aux[2]|@aux[3]|@aux[4]";				
		push(@valores,$sexteta);
	}
	@ordenagentes = sort { $a <=> $b } @valores; 
	pop(@ordenagentes);
	@ordenagentes=reverse(@ordenagentes);

	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
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
	}else{
		foreach	$variable (@ordenagentes){
			if ($i<6){		
				($cantVeces,$id,$nom,$ap,$ofi,$correo) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." cuyo nombre es,"."$nom"." y su correo es "."$correo"." y tiene $cantVeces cant veces visto";
				print"$aux\n";		
			}
			$i=$i+1;
		}
	}
}	

sub top5AgentesTiempo{
	# se tiene un array de agentes
	my @valores = [];	
	@claves=keys(%hashagentes);
	my $arrSize = @claves;

	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashagentes{@claves[$p]}};
		$sexteta = "@aux[6]|@aux[0]|@aux[1]|@aux[2]|@aux[3]|@aux[4]";				
		push(@valores,$sexteta);
	}
	@ordenagentes = sort { $a <=> $b } @valores; 
	pop(@ordenagentes);
	@ordenagentes=reverse(@ordenagentes);

	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordenagentes){
			if ($i<6){		
				($cantTiempo,$id,$nom,$ap,$ofi,$correo) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." cuyo nombre es,"."$nom"." y su correo es "."$correo";
				print FICH $aux; 		
			 	print FICH "\n";
			}
			$i=$i+1;
		}
		close (FICH); 
	}else{
		foreach	$variable (@ordenagentes){
			if ($i<6){		
				($cantTiempo,$id,$nom,$ap,$ofi,$correo) = split(/\|/,$variable);
				$aux = "El numero "."$i"." del ranking es: "."$id"." cuyo nombre es,"."$nom"." y su correo es "."$correo"." y tiene $cantTiempo minutos";
				print"$aux\n";		
			}
			$i=$i+1;
		}
	}
}	

#--------------------------------------------------------------------------------
# TOP 5         OFICINAS 
#--------------------------------------------------------------------------------

sub top5OficinasCantidad{
	# se tiene un array de oficinas
	my @valores = [];
	@claves=keys(%hashoficinas);
		
	my $arrSize = @claves;
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashoficinas{@claves[$p]}};
		$dupla = "@aux[1]|@aux[0]";				
		push(@valores,$dupla);
	}
	@ordenoficinas = sort { $a <=> $b } @valores; 
	pop(@ordenoficinas);
	@ordenoficinas=reverse(@ordenoficinas);
	
	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
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
	}else{
		foreach	$variable (@ordenoficinas){
			if ($i<5){		
				($cantVeces,$id) = split(/\|/,$variable);
				$a = $i +1;
				$aux = "La oficina numero "."$a"." del ranking es "."$id"." y tiene $cantVeces veces visto";		
				print "$aux\n";		
			}
			$i=$i+1;
		}
	}
}

sub top5OficinasTiempo{
	# se tiene un array de oficinas
	my @valores = [];
	@claves=keys(%hashoficinas);
		
	my $arrSize = @claves;
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashoficinas{@claves[$p]}};
		$dupla = "@aux[2]|@aux[0]";				
		push(@valores,$dupla);
	}
	@ordenoficinas = sort { $a <=> $b } @valores; 
	pop(@ordenoficinas);
	@ordenoficinas=reverse(@ordenoficinas);
	
	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
  	 			$termine = 1;
			}
		}
		open (FICH,">$nom");
		foreach	$variable (@ordenoficinas){
			if ($i<6){		
				($cantTiempo,$id) = split(/\|/,$variable);
				$aux = "La oficina numero "."$i"." del ranking es "."$id";		
				print FICH $aux; 		
			 	print FICH "\n";
			}
			$i=$i+1;
		}
		close (FICH); 
	}else{
		foreach	$variable (@ordenoficinas){
			if ($i<5){		
				($cantTiempo,$id) = split(/\|/,$variable);
				$a = $i +1;
				$aux = "La oficina numero "."$a"." del ranking es "."$id"." y tiene $cantTiempo minutos hablados";		
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
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashumbrales{@claves[$p]}};
		$octeto = "@aux[7]|@aux[0]|@aux[1]|@aux[2]|@aux[3]|@aux[4]|@aux[5]|@aux[6]";
		push(@valores,$octeto);
	}
	@ordenumbrales = sort { $a <=> $b } @valores; 
	pop(@ordenumbrales);
	@ordenumbrales=reverse(@ordenumbrales);
			
	$i=1;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
 				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
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
	}else{
		foreach	$variable (@ordenumbrales){
			if ($i<6){
				($cantVeces,$id,$codOrig,$numOrig,$tipo,$codDest,$tope,$estado) = split(/\|/,$variable);
				if ($cantVeces > 0){
					$aux = "El numero "."$i"." del ranking tiene la id "."$id"." y tiene $cantVeces veces visto";
					print "$aux\n";	
				}
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
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashpaises{@claves[$p]}};
		$terna = "@aux[2]|@aux[0]|@aux[1]";
		push(@valores,$terna);
	}
	@ordenpaises = sort { $a <=> $b } @valores; 
	pop(@ordenpaises);
	@ordenpaises=reverse(@ordenpaises);
	
	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
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
	}else{
		print "Top 5 de paises\n";
		foreach	$variable (@ordenpaises){
			if ($i<5){		
				($cantVeces,$id,$nom) = split(/\|/,$variable);
				$a = $i+1;
				print"$El numero "."$a"." del ranking es "."$nom"." y tuvo  $cantVeces veces vistos\n";		
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
	for ($p=0; $p<$arrSize; $p++){
		my @aux = @{$hashareas{@claves[$p]}};
		$terna = "@aux[2]|@aux[0]|@aux[1]";
		push(@valores,$terna);
	}
	@ordenareas = sort { $a <=> $b } @valores; 
	pop(@ordenareas);
	@ordenareas=reverse(@ordenareas);

	$i=0;
	if ($grabar == 1){
		$termine = 0;
		$it = 0;
		$nom = "$GRABDIR_RANKING"."$it".".txt";
		while ($termine == 0 ){			
			if (-e "$nom") {
				$it = $it +1;
				$nom = "$GRABDIR_RANKING"."$it".".txt";
			} else {
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
	}else{
		print "Top 5 de areas\n";
		foreach	$variable (@ordenareas){
			if ($i<5){		
				($cantVeces,$nom,$id) = split(/\|/,$variable);

				$a = $i+1;
				print"$El numero "."$a"." del ranking es "."$nom"."y tuvo $cantVeces  veces vistos \n";	
			}
			$i=$i+1;
		}
	}
}	

sub inicializacionHashes{
	# SE REALIZA EL HASH DE CENTRALES: hashcentrales (ID central, Arrary:(ID CENTRAL, CENTRAL, #cantVecesVisto,cantTiempo))
	
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
		push (@aux, 0);
		@{$hashcentrales{$aux[0]}} = @aux;

		#my @arr = @{$hashcentrales{$aux[0]}};
	} 
	# Cerramos el fichero abierto 
	close (CENTRALES);

	#---------------------------------------------------------------------------------------
	# SE REALIZA EL HASH DE OFICINAS: hashoficinas (ID oficina; ID oficina cantVeces visto #cantTiempoVisto)
	
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
		push (@aux, 0);		
		if (exists($hashoficinas{"@aux[3]"})){
		} else{
			@aux2[0] = @aux[3];			
			@aux2[1] = 0;
			@{$hashoficinas{$aux[3]}} = @aux2;				
			#my @arr = @{$hashoficinas{$aux[3]}};
		} 	
	}
	# Cerramos el fichero abierto 
	close (AGENTES);

	#--------------------------------------------------------------------------------------
	# SE REALIZA EL HASH DE AGENTES: hashagentes  (ID agente, Arrary:(ID AGENTE, #NOM,AP,OFICINA,CORREO, cantVecesVisto, cantTiempoVisto))

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
		push (@aux, 0);
		@{$hashagentes{$aux[2]}} = @aux;				
		#my @arr = @{$hashagentes{$aux[2]}};
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
		@aux=split(";",$umbral);
		push (@aux, 0);				
		@{$hashumbrales{$aux[0]}} = @aux;	 	
		#my @arr = @{$hashumbrales{$aux[0]}};
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
	} 
	# Cerramos el fichero abierto 
	close (AREAS);
}


sub LlenarPeligrosas(){
	inicializacionHashes();
	opendir(DIR, "$direcPeligrosas");
	@FILES = readdir(DIR);
	foreach $file (@FILES) {
		open (PELIGROSAS,"$direcPeligrosas/$file");
		@registros=<PELIGROSAS>;
		$direcdef = "$Dir"."/default.txt";
		open (DEFAULT,$direcdef);
		@regs=<DEFAULT>;
		$it1=0;
		foreach $t (@regs){
			if ($it1==8){@tam1=split(";",$t);}
			$it1 = $it1+1;	
		}
		close(DEFAULT);	
		@nomaux = split("_",$file);
		$todook =1;
		if (@uvt[7] == 1){
			if (@nomaux[1] ne @tam1[0]){			
				$todook=0;
			}
		}		
		if (@uvt[7] == 2){
			$arrSize = @to;
			$i=0;
			$ok=1;
			while($i<=$arrSize){
				$todook=(@nomaux[1] ne @tam1[$i]) && $todook;
				$i=$i+1;				
			}
		}
		if ($todook==1){
		# Mostramos los datos en pantalla 
			foreach $peligro (@registros){
				@aux=split(";",$peligro);
				# INICIAN LOS CHEQUEOS:
				# CENTRALES 
				if (exists($hashcentrales{"@aux[0]"})){	
					my @auxreg = @{$hashcentrales{@aux[0]}};
					@auxreg[2] = @auxreg[2] +1;
					@auxreg[3] = @auxreg[3] +@aux[5];
					@{$hashcentrales{$aux[0]}} = @auxreg;
					#my @arr = @{$hashcentrales{$aux[0]}};
				}

				# AGENTES
				if (exists($hashagentes{"@aux[1]"})){			
					my @auxreg1 = @{$hashagentes{@aux[1]}};
					@auxreg1[5] = @auxreg1[5] +1;
					@auxreg1[6] = @auxreg1[6] +@aux[5];
					@{$hashagentes{$aux[1]}} = @auxreg1;
					my @arr2 = @{$hashagentes{$aux[1]}};

					# OFICINAS
					if (exists($hashoficinas{"@auxreg1[3]"})){
						my @auxreg11 = @{$hashoficinas{@auxreg1[3]}};
						@auxreg11[1] = @auxreg1[1] +1;
						@auxreg11[2] = @auxreg1[2] +@aux[5];
						@{$hashoficinas{$auxreg1[3]}} = @auxreg11;
						#my @arr2 = @{$hashoficinas{$auxreg1[3]}};
					}	
				}

				# PAISES
				if (exists($hashpaises{"@aux[8]"})){			
					my @auxreg3 = @{$hashpaises{@aux[8]}};
					@auxreg3[2] = @auxreg3[2] +1;
					@{$hashpaises{$aux[8]}} = @auxreg3;
					#my @arr2 = @{$hashpaises{$aux[8]}};
				}

				# AREAS
				if (exists($hashareas{"@aux[9]"})){			
					my @auxreg4 = @{$hashareas{@aux[9]}};
					@auxreg4[2] = @auxreg4[2] +1;
					@{$hashareas{$aux[9]}} = @auxreg4;
					#my @arr2 = @{$hashareas{$aux[2]}};
				}

				# UMBRALES 
				if (exists($hashumbrales{"@aux[2]"})){			
					my @auxreg6 = @{$hashumbrales{@aux[2]}};
					@auxreg6[7] = @auxreg[7] +1;
					@{$hashumbrales{$aux[2]}} = @auxreg6;
					my @arr = @{$hashumbrales{$aux[2]}};
				}
			} 
		}
		# Cerramos el fichero abierto 
		close (PELIGROSAS);
	}
	closedir(DIR);		
}	

#if("$ENV{'ENTORNO_CONFIGURADO'}" eq "true"){
	MenuPal();
#} else {
#	print "[ERROR] El entorno no ha sido configurado aún. Corra el script AFRAINIC.sh para configurarlo.\n"
#}
