use strict;
use warnings;
use utf8;
use FindBin;
use lib "${FindBin::Bin}/extlib/lib/perl5", "${FindBin::Bin}/extlib/lib/perl5/i386-freebsd-64int";
use Net::Twitter::Lite::WithAPIv1_1;
use Encode;

my $gene = 0;
my $step = 0;
my $name = "";
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
	ssl 		=> 1,
);

open( my $fh, "<", $text)
	or die "Cannot open $text: $!";
while( my $line = readline($fh)){
	my @column = split(/\t/, $line);
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

my $profile = {};
$name = "LifeGameBot($gene 代目$step 歩目)";
$name = decode_utf8($name);
$profile->{name} = $name;
$tw->update_profile($profile);

