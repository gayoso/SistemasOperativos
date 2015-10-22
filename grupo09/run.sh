#! /bin/bash
# if [[ "$ENTORNO_CONFIGURADO" == true ]]; then
# 	chmod +x Detener.sh
# 	./Detener.sh AFRARECI.sh
# 	exit
# fi
rm -r aceptadas bin conf log mae novedades rechazadas reportes sospechosas
./AFRAINST.sh #&& cd bin #&& . AFRAINIC.sh