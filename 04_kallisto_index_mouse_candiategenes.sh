for gene in Ncs1 gria1 gria2 dlg4 grm1 grm2 grm3 grm4 grm5 "|arc|" "|fmr1|" prkcz prkci "|fos|" creb1 camk2a "|rpl19|" rn18s "|igf2|" sypl hdac1 hdac2
do
#grep -i $gene gencode.vM7.transcripts.fa 
grep -i -A 1 $gene gencode.vM7.transcripts.fa | wc -l
grep -i -A 1 $gene gencode.vM7.transcripts.fa >> gencode.vM7.transcripts_candidategenes.fa
done



for i in 14*
do
echo $i
cd $i
grep -i -v "-nan" abundance.tsv
cd ..
done
