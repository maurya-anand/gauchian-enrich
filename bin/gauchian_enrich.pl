#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;
use Cwd 'abs_path';
use Data::Dumper;
use Parallel::ForkManager;

my $nprocs = `grep -c ^processor /proc/cpuinfo`;
chomp($nprocs);

if (!$nprocs) { $nprocs = 10; }

my $max_procs = int($nprocs * 0.75);
my $pm = Parallel::ForkManager->new($max_procs);

my $gauchian_tsv = $ARGV[0];
my $annotated_tsv = $ARGV[1];

my $GBAP1_like_variant_exon9_11 = "GBAP1-like_variant_exon9-11";
my $other_unphased_variants_col = "other_unphased_variants";

my %header_map;
my @gauchian_rec;
my %var_ann;

my $input_filename = basename($gauchian_tsv);
$input_filename =~ s/\.[^.]+$//;

if (!defined($annotated_tsv) || $annotated_tsv eq "") {
    $annotated_tsv = $input_filename.".annotated.tsv";
}

open(TSV,"$gauchian_tsv") or die "can't open the tsv input $gauchian_tsv\n";
my $header = <TSV>; chomp $header;
my @header_tmp = split("\t",$header);
for(my $i=0;$i<=$#header_tmp;$i++){
    $header_map{$header_tmp[$i]} = $i;
}

open(OUT,">$annotated_tsv") or die "can't write to $annotated_tsv";
print OUT "$header\tinput\ttranscript\tgene\tstrand\tcoordinates(gDNA/cDNA/protein)\tregion\tinfo\tCHROM\tPOS\tREF\tALT\n";

while(my $rec=<TSV>){
    chomp $rec;
    my @tmp = split("\t",$rec);
    my $all_vars = "$tmp[$header_map{$GBAP1_like_variant_exon9_11}],$tmp[$header_map{$other_unphased_variants_col}]";
    my @all_vars_tmp = split(/[\,\/]/,$all_vars);
    my %seen;
    my @uniq_vars = grep { $_ ne 'None' && !$seen{$_}++ } @all_vars_tmp;
    push @gauchian_rec, $rec;
    foreach my $p_change (@uniq_vars) {
        $pm->start and next;
        rev_annotate($p_change,$rec);
        $pm->finish();
    }
}
$pm->wait_all_children;

my $absolute_path = abs_path($annotated_tsv);

print "Output written to $absolute_path\n";

sub rev_annotate {
    my ($var,$rec) = (@_);
    my $comm = `transvar panno -i GBA:$var --refversion hg38 --refseq --gseq --longest --reference /ref/hg38.fa`;
    chomp $comm;
    my @rows = split("\n",$comm);
    for(my $i=1; $i<=$#rows;$i++){
        print OUT "$rec\t$rows[$i]\n";
    }
}
