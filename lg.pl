use strict;
use warnings;
use utf8;
use Encode;

my ($text) = @ARGV;
die 'no text'  unless defined $text;
$text = decode('utf-8', $text);

my $width = 10;
my $height = 10;
my $readline = 0;
my $gene = 0;
my $step = 0;
my $isInit = 0;
my @column;
my @field;
my @field2;

if( $text eq "new" ){
	&refresh;
	&show;
	exit(0);
}

open( my $fh, "<", $text)
	or die "Cannot open $text: $!";
while( my $line = readline($fh)){
	chomp($line);
	if($line eq 'init'){
		#初期化指令があった時
		$isInit = 1;
	}
	if($readline  < 10)
	{
		for(my $i = 0; $i < $width; $i++)
		{
			my $c = substr($line, $i, 1);
			push(@field, int $c);
		}
		$readline++;
	}
	else{	
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
}
close $fh;
if($isInit == 1){
	#初期化指令があった時
	&refresh;
	&show;
	exit(0);
}else{
	#print( "before\n");
	#&show;
	&update;
	#print( "after\n");
#	if(&isFrozen == 1)
#	{
#		#print "field is frozen\n";
#		&refresh;
#		&show;
#		exit(0);
#	}
	&show2;
	exit(0);
}


sub show {
	for(my $y = 0; $y < $height; $y++)
	{
		for(my $x = 0; $x < $width; $x++)
		{
			print($field[$x + $y * $width]);
		}
		print("\n");
	}
	print( "gene\t$gene\n" );
	print( "step\t$step\n" );
}
sub refresh {
	for( my $i = 0; $i < $width*$height; $i++)
	{
		$field[$i] = int( rand(2) );
	}
	$gene++;
	$step = 0;
}
sub update {
	for( my $y = 0; $y < $height; $y++)
	{
		my $w = ($y - 1 + $height) % $height;
		my $s = ($y + 1) % $height;
		for( my $x = 0; $x < $width; $x++)
		{
			my $lvnb = 0;
			my $a = ($x - 1 + $width) % $width;
			my $d = ($x + 1) % $width;
			my $c = $field[$x + $y * $width];
			$lvnb += $field[$a + $w * $width];
			$lvnb += $field[$x + $w * $width];
			$lvnb += $field[$d + $w * $width];
			$lvnb += $field[$a + $y * $width];
			$lvnb += $field[$d + $y * $width];
			$lvnb += $field[$a + $s * $width];
			$lvnb += $field[$x + $s * $width];
			$lvnb += $field[$d + $s * $width];
			if($c == 1 && ($lvnb == 2 || $lvnb == 3) )
			{
				$field2[$x + $y * $width] = 1;
			}
			elsif($c == 0 && $lvnb == 3)
			{
				$field2[$x + $y * $width] = 1;
			}
			else
			{
				$field2[$x + $y * $width] = 0;
			}
		}
	}
	$step++;
}

sub show2 {
	for(my $y = 0; $y < $height; $y++)
	{
		for(my $x = 0; $x < $width; $x++)
		{
			print($field2[$x + $y * $width]);
		}
		print("\n");
	}
	print( "gene\t$gene\n" );
	print( "step\t$step\n" );
}
