use strict;
use warnings;
use utf8;
use Encode;

my $step = 0;
my $gene = 0;
my ($fstats) = @ARGV;
my @column;
my $dir;

die 'no text' unless defined $fstats;
$fstats = decode('utf-8', $fstats);

open(my $ifh, "<", $fstats)
  or die "Cannnot open $fstats: $!";
while( my $line = readline($ifh) ){
  chomp($line);
  @column = split(/\t/, $line);
  if( $column[0] eq 'gene'){
     $gene = int($column[1]);
  }
}
close $ifh;	

$dir = sprintf("./stateLogs/%08d", $gene+1);
unless( -d $dir) {
  mkdir $dir
    or die "Can't create directory $dir:$!";
}
#dir www
$dir = sprintf("/home/ikatake/www/wetsteam/lifegamebot/stateLogs/%08d", $gene+1);
unless( -d $dir) {
  mkdir $dir
    or die "Can't create directory $dir:$!";
}
