# The perl script used to identify LTR-RTs gene chimera based on LTR-Retrotransposons localization in genome sequence. The Perl script compared the gene start and end with the start and end of LTR-RT within the genome. LTR-RT was considered a LTR-RT gene chimera if it was located within the gene start and end coordinates provided by the gene annotation in the GFF files.
# How to use "perl LTR-RT-gene-chimera.pl LTR-RTs_Table  genes.gff plant_name "
# LTR-RTs_Table file structure column 1 (LTR-RTs id) column 2 (pseudomolecules/scaffolds Accession Number) column 3 (LTR-RTs start) column 4 (LTR-RTs end)
# genes.gff file structure column 1 (pseudomolecules/scaffolds Accession Number) column 2 (LTR-RTs start) column 3 (LTR-RTs end) column 4 (gene features)
# note in the LTR-RTs_Table and genes.gff files the columns separated by tab delimited.
use strict;
my $searchfile = $ARGV[0];
my $searchfor  = $ARGV[1];
my $processid  = $ARGV[2];
my $OUT = $ARGV[3];
my @parray;
open (OUT,">$OUT/LTR_inside_genes.table.2");
open (PFILE,"<$searchfile");
while (<PFILE>) {
    chomp();
    if (/(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
        my $id1   = $1;
        my $id2   = $2;
        my $id3   = $3;
        my $id4   = $4;    
        push( @parray, [ $id1, $id2, $id3, $id4] );
    }
}
close PFILE;
open (GFILE,"<$searchfor");

while (<GFILE>) {
    chomp();
    if (/(\S+)\s+(\S+)\s+(\S+)\s+([\S|\s]+)/) {
        my $contig  = $1;
        my $start    = $4;
        my $end    = $5;
        my $features    = $6;

        for my $i ( 0 .. $#parray ) {

      if($contig eq $parray[$i][1]&&$start <= $parray[$i][2]&& $end >= $parray[$i][3])
         {                       
        print OUT "$parray[$i][0]\t$parray[$i][1]\t$parray[$i][2]\t$parray[$i][3]\t$start\t$end\t$features\n";   
         } 
        }
    }
}
close GFILE;
