use strict;
use warnings;
use utf8;
use Encode;
use File::Copy 'copy';

my ($fold) = $ARGV[0];
my ($fnew) = $ARGV[1];
my ($finim) = $ARGV[2];
my ($finif) = $ARGV[3];
my ($fstat) = './status.txt';
my @field1;
my @field2;
my $step;
my $gene;
my $numline = 0;
my $width = 10;
my $height = 10;
my @column;
my $ofh;

die 'no text' unless defined $fold;
$fold = decode('utf-8', $fold);
die 'no text' unless defined $fnew;
$fnew = decode('utf-8', $fnew);

#遷移前の状態を読み取る
open( $ofh, "<", $fold)
  or die "Cannot open $fold: $!";
while(my $line = readline($ofh)) {
	chomp($line);
	if($numline  < 10) {
		for(my $i = 0; $i < $width; $i++) {
			my $c = substr($line, $i, 1);
			push(@field1, int $c);
		}
		$numline++;
	}
	else{
		@column = split(/\t/, $line);
		if( $column[0] eq 'step'){
			$step = int($column[1]);
		}
		elsif($column[0] eq 'gene'){
			$gene = int($column[1]);
		}
	}
}
close $ofh;
$numline = 0;
#遷移後の状態を読み取る
open( $ofh, "<", $fnew)
  or die "Cannot open $fnew: $!";
while(my $line = readline($ofh)) {
	chomp($line);
	if($numline  < 10){
		for(my $i = 0; $i < $width; $i++){
			my $c = substr($line, $i, 1);
			push(@field2, int $c);
		}
		$numline++;
	}
}
close $ofh;
#状態が固まっているかを確認する
print '';

if(&isFrozen == 1){
	print 'frozen';
}

sub isFrozen {
	for( my $i = 0; $i < $width*$height; $i++) {
		if($field1[$i] != $field2[$i]) {
			return 0;
		}
	}
	return 1;
}

