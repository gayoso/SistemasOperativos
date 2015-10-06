mipath=$(pwd)

rm -rf $mipath/grupo09/
cp -rf $mipath/grupo09-src/ $mipath/grupo09/
cd grupo09
./AFRAINST.sh
. AFRAINIC.sh

