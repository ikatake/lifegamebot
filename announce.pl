use strict;
use warnings;
use utf8;
use Encode;

my $step = 0;
my $gene = 0;
my @column;
my $dir;
my $reason;
my $initter;
my $gifadr = '';
my $pageadr = '';
my $baseadr = 'http://www.wetsteam.org/lifegamebot/';

my ($fstats) = @ARGV;
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
  if( $column[0] eq 'step'){
    $step = int($column[1]);
  }
  if( $column[0] eq 'init'){
    if( $column[1] eq 'frozen' ){
      $reason = 'field is frozen';
    }
    elsif( $column[1] eq 'user' ){
      $reason = "init command by $column[2]";
    }
  }
}
close $ifh;	

$gifadr = sprintf("%sgifs\/%08d\.gif", $baseadr,$gene);

print "LifeGameBot g:${gene} is gone at s:${step}.\n";
print "Reason : ${reason}.\n";
print "Gif : ${gifadr}\n";

