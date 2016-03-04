use strict;
use warnings;
use utf8;
use Encode;

my $state_file = $ARGV[0];
my $conf_file = $ARGV[1];
my $tweet = '';
my $width = 10;
my $height = 10;
my $linecnt = 0;
my $gene = 0;
my $step = 0;

my $conf = do $conf_file or die "$!$@";

open( my $fh, "<", $state_file)
	or die "Canno Open State File $state_file: $!";
while( my $line = readline($fh)){
# chomp($line);
  if($linecnt < 10) {
    $line =~ s/0/$conf->{chr0}/g;
    $line =~ s/1/$conf->{chr1}/g;
    $tweet .= $line;
    $linecnt++;
  }
  else{	
    my @column = split(/\t/, $line);
    if( $column[0] eq 'step') {
      $step = int($column[1]);
    }
    elsif( $column[0] eq 'gene') {
      $gene = int($column[1]);
    }
  }
}
close $fh;

$tweet .= "g:$gene s:$step";
print $tweet;

