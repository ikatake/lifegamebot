use utf8;
use Encode qw/encode decode/;

use strict;
use warnings;

use File::Path qw/mkpath/;
use Compress::Zlib qw/crc32 compress/;

sub PNGCHUNK
{
	my($type, $data) = ($_[0], $_[1]);
	my($result);
	
	return pack('NA4A*N', length($data), $type, $data, crc32("$type$data"));
}

my($statefilename, $targetgene, $targetstep) = ("", 0, 0);
$statefilename = decode('utf-8', $ARGV[0]);

die('no text') unless defined($statefilename);
die('no exist file') unless -e encode('utf-8', $statefilename);

# settings
my($imagewidth, $imageheight, $xblock, $yblock) = (100, 100, 10, 10);
my($pngdir) = ('./pngs');

# check settings
die('invalied imagewidth or X-block') if ($imagewidth % $xblock != 0);
die('invalied imageheight or Y-block') if ($imageheight % $yblock != 0);

# parse input statefile
my(@statelines) = ();
my($stategene, $statestep) = (0, 0);
open(my $statefile, '<:utf8', encode('utf-8', $statefilename));
while (my $stateline = <$statefile>) {
	chomp($stateline);
	if ($stateline =~ m/^\d+$/) {
		# stateline
		die('invalied state line-length at '.scalar(@statelines))
			if length($stateline) != $xblock;
		push(@statelines, $stateline);
	}
	elsif ($stateline =~ m/^gene/i) {
		# gene
		($stategene) = $stateline =~ m/(\d+)$/;
	}
	elsif ($stateline =~ m/^step/i) {
		# step
		($statestep) = $stateline =~ m/(\d+)$/;
	}
}
close($statefile);
die('invalied state lines') if scalar(@statelines) != $yblock;
die('undefined gene') if !defined($stategene) || $stategene+0 == 0;
die('undefined step') if !defined($statestep);

# PNG generate
my($pngbuf); #png data buffer
$pngbuf  = "\x89PNG\r\n\x1a\n";
# IHDR/PLTE
# 暫定でパレット方式(0:白1:黒)の8bitdepth
$pngbuf .= PNGCHUNK('IHDR', pack('N2C5', $imagewidth, $imageheight, 8, 3, 0, 0, 0));
$pngbuf .= PNGCHUNK('PLTE', pack('C6', 255,255,255, 0,0,0));
# IDAT
# 暫定でフィルタ無し。2でも0の方が軽かった
my($datbuf) = (""); #data pre-compress buffer
foreach my $stateline (@statelines) {
	my($datlinebuf) = pack('C', 0);
	foreach (split(//, $stateline)) {
		$datlinebuf .= pack('C', $_) x ($imagewidth/$xblock);
	}
	$datbuf .= $datlinebuf x ($imageheight/$yblock);
}
$pngbuf .= PNGCHUNK('IDAT', compress($datbuf, Compress::Zlib::Z_BEST_COMPRESSION));
# IEND
$pngbuf .= PNGCHUNK('IEND', '');

# File writedown.
mkpath(encode('utf-8', sprintf("$pngdir/%08d", $stategene)))
	unless -e encode('utf-8', sprintf("$pngdir/%08d", $stategene));
open(my $pngout, '>:raw', encode('utf-8', sprintf("$pngdir/%08d/%08d.png", $stategene, $statestep)))
 or die("$!");
binmode($pngout);
print($pngout $pngbuf);
close($pngout);