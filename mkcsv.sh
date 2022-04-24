#
# mkcsv.sh, 24 Apr 22

echo "language,trait,value"
for f in lang-info/*.txt
   do
   LANG=`basename $f .txt`
   awk -f mkcsv.awk -v lang=$LANG < "$f"
   done

