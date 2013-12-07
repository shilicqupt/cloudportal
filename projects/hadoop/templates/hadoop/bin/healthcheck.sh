#! /bin/bash
a=`free | grep 'Swap:' | sed -e 's/Swap:[[:blank:]]*//' -e 's/[[:blank:]][[:blank:]]*/:/g'`
totalSwap=`echo $a|cut -d : -f 1`
usedSwap=`echo $a|cut -d : -f 2`
usedSwapRatio=$((usedSwap*100/totalSwap))
if [ "$usedSwapRatio" -ge 20 ]
then
printf "ERROR:Swap used ratio %d%%\n" "$usedSwapRatio"
fi
