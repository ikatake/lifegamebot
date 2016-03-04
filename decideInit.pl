use strict;
use warnings;
use utf8;
use Encode;
use File::Copy 'copy';

my ($fnew) = $ARGV[0];
my ($finim) = $ARGV[1];
my ($finif) = $ARGV[2];
my ($fstat) = './status.txt';
my $step;
my $gene;
my $isInit = '';
my @column;
my $initter = '';
my $ifh;

die 'no text' unless defined $fnew;
$fnew = decode('utf-8', $fnew);
die 'no text' unless defined $finim;
$finim = decode('utf-8', $finim);
die 'no text' unless defined $finif;
$finif = decode('utf-8', $finif);

#checkFrozen.plの結果を読み取る
open($ifh, "<", $finif)
  or die "Cannot open $finif: $!";
while(my $line = readline($ifh) ){
  chomp($line);
  if( $line eq 'frozen' ){
    $isInit = 'frozen';
  }
}
close $ifh;

#checkMention.plの結果を読み取る
open($ifh, "<", $finim)
  or die "Cannot open $finim: $!";
while( my $line = readline($ifh) ){
  chomp($line);
  @column = split(/\t/, $line);
  if( $column[0] eq 'init'){
    $isInit = 'user';
    $initter = "\@$column[1]";
  }
}
close $ifh;

print '';
if($isInit ne '') { #初期化するようにstatus.txt、state.newに記載。
  #state.newからgeneとstepを読み取る
  open($ifh, "<", $fnew)
    or die "Cannot open $fnew: $!";
  while( my $line = readline($ifh) ){
    chomp($line);
    @column = split(/\t/, $line);
    if( $column[0] eq 'gene'){
      $gene = int($column[1]);
    }
    elsif( $column[0] eq 'step' ){
      $step = int($column[1]);
    }
  }
close $ifh;
	print "gene\t${gene}\n";
	print "step\t${step}\n";
	print "init\t${isInit}\t${initter}\n";
	open (my $outfh, '>>', $fnew)
		or die qq{Can't open file "$fnew": $!};
	print $outfh 'init';
	close $outfh;
}

