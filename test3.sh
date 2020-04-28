if [ -z "$(/usr/bin/vboxmanage list runningvms)" ] ;
then
echo "No vm" ; 
else
echo "vm got" ;
fi;