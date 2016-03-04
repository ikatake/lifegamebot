use strict;
use warnings;
use utf8;
use Encode;
use File::Copy 'copy';

my $frmtxt = $ARGV[0];
my $frmsvg = $ARGV[1];


my $width = 10;
my $height = 10;
my $readline = 0;
my $step = 0;
my $gene = 0;
my @column;
my @field;

open( my $fh, "<", $frmtxt)
	or die "Cannot open $frmtxt: $!";
while( my $line = readline($fh)){
	@column = split(/\t/, $line);
	if( $column[0] eq 'step')
	{
		$step = int($column[1]);
	}
	elsif( $column[0] eq 'gene')
	{
		$gene = int($column[1]);
	}
}
close $fh;

my $dir = sprintf("./stateLogs/%08d", $gene);
my $totxt = sprintf("$dir/%08d.txt", $step);
copy($frmtxt, $totxt)
	or die "Can't copy $frmtxt to $totxt:$!";

open($fh, "<", $frmsvg)
	or die "Cannot open $frmsvg: $!";
my $tosvg = sprintf("$dir/%08d.svg", $step);
copy($frmsvg, $tosvg)
	or die "Can't copy $frmsvg to $tosvg:$!";

#copy to ~/www directory
$dir = sprintf("/home/ikatake/www/wetsteam/lifegamebot/stateLogs/%08d", $gene);
$totxt = sprintf("$dir/%08d.txt", $step);
copy($frmtxt, $totxt)
	or die "Can't copy $frmtxt to $totxt:$!";
$tosvg = sprintf("$dir/%08d.svg", $step);
copy($frmsvg, $tosvg)
	or die "Can't copy $frmsvg to $tosvg:$!";


exit(0);

