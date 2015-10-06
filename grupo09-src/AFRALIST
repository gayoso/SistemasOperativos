#!/bin/perl

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
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Menu de ayuda\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
	MenuPal(); 			
}

sub Menuw {
	system("clear");
	print "Grabando...\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Grabando...\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
	MenuPal(); 			
}

sub IngresarInput{
	system("clear");
	print "Ingresar archivo\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Ingresar archivo\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
}
sub ElegFiltros{
	system("clear");
	print "Elegir Filtros\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Elegir Filtros\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
}
	

sub Menur {
	system("clear");
	print "Menu de consultas\n";
	print "Si desea ingresar un archivo nuevo ingresar 1\n";			
	print "Si desea comenzar la eleccion de filtros ingresar 2\n";			
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Menu de consultas\n";
		print "Si desea ingresar un archivo nuevo ingresar 1\n";			
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
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de centrales con más llamadas peligrosas\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
}
sub DarRankOfic{
	system("clear");
	print "Top 5 de oficinas con más llamadas peligrosas\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de oficinas con más llamadas peligrosas\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}
}
sub DarRankAgen{
	system("clear");
	print "Top 5 de Agentes con más llamadas peligrosas\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de Agentes con más llamadas peligrosas\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}

}
sub DarRankDest{
	system("clear");
	print "Top 5 de Destinos con más llamadas peligrosas\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de Destinos con más llamadas peligrosas\n";
		print "Si desea salir apretar s\n";
 		$opc = <STDIN> ;
 		chop($opc);
	}

}
sub DarRankUmbr{
	system("clear");
	print "Top 5 de umbrales con más llamadas peligrosas\n";
	print "Si desea salir apretar s\n";
	$opc = <STDIN>;
	chomp($opc);
	while ($opc ne "s") {
		system("clear");
		print "Top 5 de umbrales con más llamadas peligrosas\n";
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
		else {
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

MenuPal();

#------------------------------------------------------------------
# main
#------------------------------------------------------------------

# SE REALIZA EL HASH DE CENTRALES: hashcentrales (ID central, Arrary:(ID CENTRAL, CENTRAL, cantVecesVisto))


	open (CENTRALES,"centrales.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<CENTRALES>; 
	my $hashcentrales={};

	# Mostramos los datos en pantalla 
	foreach $central (@registros){
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
# SE REALIZA EL HASH DE OFICINAS: hashoficinas 

	open (AGENTES,"agentes.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<AGENTES>; 
	my %hashoficinas;

	# Mostramos los datos en pantalla 
	foreach $agente (@registros){
		@aux=split(";",$agente);
		push (@aux, 0);		
		if (exists($hashoficinas{"@aux[3]"})){
		}	
		else{
			@aux2[0] = @aux[3];			
			@aux2[1] = 0;
			@{$hashoficinas{$aux[3]}} = @aux2;				
			#print "$hashoficinas{@aux[3]}\n";
			
		} 	

	}
	 
	# Cerramos el fichero abierto 
	close (AGENTES);

#--------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE AGENTES: hashagentes  (ID agente, Arrary:(ID AGENTE, NOM,AP,OFICINA,CORREO, cantVecesVisto))

#	id agente, oficina q pertence correoelectronico

	open (AGENTES,"agentes.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<AGENTES>; 
	my $hashagentes={};

	# Mostramos los datos en pantalla 
	foreach $agente (@registros){
		@aux=split(";",$agente);		
		push (@aux, 0);		
		#print "@aux\n";
		@{$hashagentes{$aux[2]}} = @aux;				
	 	#print "$hashagentes{@aux[2]}";
		#my @arr = @{$hashagentes{$aux[2]}};
		#print "$arr[2]\n";
	
	}
 
	# Cerramos el fichero abierto 
	close (AGENTES);


#--------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE UMBRALES: hashumbrales 

	open (UMBRALES,"umbrales.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<UMBRALES>; 
	my %hashumbrales;

	# Mostramos los datos en pantalla 
	foreach $umbral (@registros){
		@aux=split(";",$umbral);
		push (@aux, 0);				
		@{$hashumbrales{$aux[0]}} = @aux;	 	
		#print "$hashumbrales{@aux[0]}";

	} 
	# Cerramos el fichero abierto 
	close (UMBRALES);


#--------------------------------------------------------------------------------------
# SE REALIZA EL HASH DE DESTINOS: hashpaises y hashareas

	# PAISES

	open (PAISES,"CdP.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<PAISES>; 
	my %hashpaises;

	# Mostramos los datos en pantalla 
	foreach $pais (@registros){
		@aux=split(";",$pais);
		push (@aux, 0);	
		@{$hashpaises{$aux[0]}} = @aux;
	 	#print "$hashpaises{@aux[0]}\n";

	} 
	# Cerramos el fichero abierto 
	close (PAISES);

	# AREAS

	open (AREAS,"CdA.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<AREAS>; 
	my %hashareas;

	# Mostramos los datos en pantalla 
	foreach $area (@registros){
		@aux=split(";",$area);
		push (@aux, 0);		
		@{$hashareas{$aux[2]}} = @aux;	
	 	#print "$hashareas{@aux[2]}\n";
		print "$aux[1]\n";
	} 
	# Cerramos el fichero abierto 
	close (AREAS);


#--------------------------------------------------------------------------------------
#BUCLE PPAL DE LLAMADAS PELIGROSAS 


	open (PELIGROSAS,"peligrosas.csv");
	#Añadimos cada línea de éste en la matriz. 
	@registros=<PELIGROSAS>; 

	# Mostramos los datos en pantalla 
	foreach $peligro (@registros){
		@aux=split(";",$peligro);
		
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
			#my @arr2 = @{$hashagentes{$aux[1]}};
			#print "$arr2[5]\n";
				
	
		}

		# PAISES
		if (exists($hashpaises{"@aux[8]"})){			
			my @auxreg3 = @{$hashpaises{@aux[8]}};
			#print "$auxreg3[2]\n";				
			@auxreg3[2] = @auxreg3[2] +1;
			@{$hashagentes{$aux[8]}} = @auxreg3;
			
			#my @arr2 = @{$hashagentes{$aux[8]}};
			#print "$arr2[1]\n";
				
	
		}

		# AREAS
		#print "@aux[9]\n";
		if (exists($hashareas{"@aux[9]"})){			
			my @auxreg4 = @{$hashareas{@aux[9]}};
			#print "$auxreg4[0]\n";				
			#@auxreg4[7] = @auxreg2[7] +1;
			#@{$hashagentes{$aux[2]}} = @auxreg4;
			#my @arr2 = @{$hashagentes{$aux[2]}};
			#print "$arr2[0]\n";
				
	
		}
	

	} 
	# Cerramos el fichero abierto 
	close (PELIGROSAS);
	
