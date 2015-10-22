#a
./AFRAINST.sh
#b
cd conf
cat AFRAINST.log | tail -n 30
cat AFRAINST.conf
#c
cd ../mae
cat agentes.mae | head -n 10
cat CdA.mae | head -n 10
cat CdC.mae | head -n 10
cat CdP.mae | head -n 10
cat tllama.tab | head -n 10
cat umbral.tab | head -n 10
#d
cd ../bin
. AFRAINIC.sh #Permitir que arranque AFRARECI
cd ../log
cat AFRAINIC.log
#e
cd ..
cp Datos/BEL_20150803 novedades && cp Datos/COS_20150703 novedades
#g
cat Datos/BEL_20150803 | head -n 10
cat Datos/COS_20150703 | head -n 10
cd bin
./Detener.sh AFRARECI.sh

cd ../log
cat AFRARECI.log
#h
cat AFRAUMBR.log
cd ../sospechosas
# Primeros 10 registros de cada uno de los archivos validados.
for archivo in `ls`; do
	if [ ! -f "$archivo" ]; then
		continue
	fi
	echo "$archivo"
	cat "$archivo" | head -n 10
done
# cat xxx | head -n 10 --> Esto sera lo que piden?
#i
cd ../bin
./Arrancar.sh AFRALIST.pl
#ingresar con la opción de ayuda (-h)
#j
#ingresar opción de consulta y filtre por oficina, grabando el reporte en un archivo
#k
#ingresar opción de estadística y filtre por período, grabando el reporte en un archivo
