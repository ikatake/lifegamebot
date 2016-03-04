use strict;
use warnings;
use utf8;
use FindBin;
use lib "${FindBin::Bin}/extlib/lib/perl5", "${FindBin::Bin}/extlib/lib/perl5/i386-freebsd-64int";
use Net::Twitter::Lite::WithAPIv1_1;
use Encode 'decode';

my $tweet;
my ($text) = @ARGV;
die 'no text'  unless defined $text;

my $conf_file = "conf.pl";
my $conf = do $conf_file or die "$!$@";

$text = decode('utf-8', $text);

my $tw = Net::Twitter::Lite::WithAPIv1_1->new(
	consumer_key        => $conf->{consumer_key},
	consumer_secret     => $conf->{consumer_secret},
	access_token        => $conf->{access_token},
	access_token_secret => $conf->{access_token_secret},
	apiurl             => 'https://api.twitter.com/1.1',
	legacy_lists_api    => 0,
	ssl			=> 1,
);

open( my $fh, "<", $text)
	or die "Cannot open $text: $!";
while( my $line = readline($fh)){
	$line = decode( 'UTF-8', $line);
	$tweet .= $line;
}
close $fh;
$tw->update($tweet);

