echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '    parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
echo '   identity "1"' >> $MOSCRIPT
echo '    moType Mbms' >> $MOSCRIPT
echo '    exception none' >> $MOSCRIPT
echo '    nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

COUNT=1
while [ "$COUNT" -le "$NUMOFRBS" ]
do

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,Mbms=1"' >> $MOSCRIPT
  echo '   identity "'$COUNT'"' >> $MOSCRIPT
  echo '    moType MbmsServiceArea' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 1' >> $MOSCRIPT
  echo '    sac Integer '$COUNT >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done

