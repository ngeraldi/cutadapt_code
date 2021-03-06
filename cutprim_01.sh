#!/usr/bin/env bash

################################################################################
# Read in primers and create reverse complements.
################################################################################
#  1) Save this script in txt writer (TextEdit on macs, DO NOT use Windows based software!!!) as "cutprim_01.sh"
#  2) set primers Lines 20-28
#  3) Set folders line 13- where folders of miseq run are and line 14 - ouput folder
#  4) run script in terminal with following (change file.path to specific file path in your computer):
#           bash file.path/cutprim_01.sh
##########################################################################
#### set directories
CURRENT_LIB='/media/sf_Dropbox/eDNA_db/GL_plants_sarah_euk02/Lane1/version_01'
d_out='/media/sf_Dropbox/eDNA_db/GL_plants_sarah_euk02/primer_cut'
	mkdir "${d_out}"
cd "${CURRENT_LIB}"
##########################################################################
################################################################################
##    Set forward (PRIMER1) and reverse (PRIMER2) primers uses one without # infront of
## vert primer??   
#PRIMER1=ACTGGGATTAGATACCCC
#PRIMER2=TAGAACAGGCTCCTCTAG
#  metazoanCO1    313   
#PRIMER1=GGWACWGGWTGAACWGTWTAYCCYCC
#PRIMER2=TAIACYTCIGGRTGICCRAARAAYCA
#  euka02 primer from Taberlet 2018 bootk
PRIMER1="TTTGTCTGSTTAATTSCG"
PRIMER2="CACAGACCTGTTATTGC"
# mini rbcl
#PRIMER1=GTTGGATTCAAAGCTGGTGTTA
#PRIMER2=CVGTCCAMACAGTWGTCCATGT
## 18s v4 universal durate lab
#PRIMER1=CCAGCASCYGCGGTAATTCC 
#PRIMER2=ACTTTCGTTCTTGATYRA 


 echo 'Primer sequences:' "${PRIMER1}" "${PRIMER2}"

# Reverse complement primers   !! not currently used  !!!
PRIMER1RC=$( echo ${PRIMER1} | tr "[ABCDGHMNRSTUVWXYabcdghmnrstuvwxy]" "[TVGHCDKNYSAABWXRtvghcdknysaabwxr]" | rev )
PRIMER2RC=$( echo ${PRIMER2} | tr "[ABCDGHMNRSTUVWXYabcdghmnrstuvwxy]" "[TVGHCDKNYSAABWXRtvghcdknysaabwxr]" | rev )
echo 'Reverse compl Primer sequences:' "${PRIMER1RC}" "${PRIMER2RC}"
PRIMER2C=$( echo ${PRIMER2} | tr "[ABCDGHMNRSTUVWXYabcdghmnrstuvwxy]" "[TVGHCDKNYSAABWXRtvghcdknysaabwxr]" )
echo 'compl Primer sequences:'"${PRIMER2C}"

### make variables
runlanes=96
number=1
#raw_files= ls -v *R1*.fastq*   # to get file names  # cuts before _  and sorts and -u removes unique
# added "-2" to "-f1" to include double name, or matching multiple samples
sam=`ls -v *.fastq* | cut -d_ -f1-2 | sort -u`

echo ${sam}
#####
cd "${d_out}"
############################  start cutting primer - look line 21
for f in ${sam}
do 
	# Identify the forward and reverse fastq files.

         READ1=$(find "${CURRENT_LIB}" -name $f"*R1_001.fastq*")
	 READ2=$(find "${CURRENT_LIB}" -name $f"*R2_001*fastq*")

	CR1="${d_out}"/"${f}"_R1_cut.fastq
        CR2="${d_out}"/"${f}"_R2_cut.fastq

cutadapt -g "$PRIMER1" -G "$PRIMER2" -m 20 -o "${CR1}" -p "${CR2}" --discard-untrimmed   "${READ1}" "${READ2}"
#  see cutadapt documents for more details  
#    https://cutadapt.readthedocs.io/en/stable/
# example uses a and A    a is 3 prime and g is 5 prime

   done


