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
my @column;
my @field;
my $gene = 0;
my $step = 0;
my $pxcell = 10;

open( my $fh, "<", $text)
	or die "Cannot open $text: $!";
while( my $line = readline($fh)){
	chomp($line);
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

#SVGのヘッダ書き込み
print << "EOS";
<?xml version="1.0" encoding="UTF-8" ?>
<svg xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        height="@{[$height*$pxcell]}px" width="@{[$width*$pxcell]}px">
EOS
print "<title>lifegamebot gene$gene step$step</title>";

for(my $y = 0; $y < $height; $y++)
{
	for(my $x = 0; $x < $width; $x++)
	{
		if( $field[$x + $y * $width] == 1)
		{
			print << "EOS";
<rect x="@{[$x*$pxcell]}px" y="@{[$y*$pxcell]}px" width="${pxcell}px" height="${pxcell}px" stroke-width="0" stroke="black" />
EOS
		}
	}
	print("\n");
}
print "</svg>";
