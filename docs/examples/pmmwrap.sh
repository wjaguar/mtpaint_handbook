#!/bin/sh
eval FNM=\${$#}
cat << PMM
P7
#MTPAINT#
WIDTH `cat "$FNM" | wc -c`
HEIGHT 1
DEPTH 1
MAXVAL 255
TUPLTYPE ${*%$FNM}
ENDHDR
PMM
cat "$FNM"
