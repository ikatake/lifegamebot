use strict;
use warnings;
use utf8;
use FindBin;
use lib "${FindBin::Bin}/extlib/lib/perl5", "${FindBin::Bin}/extlib/lib/perl5/i386-freebsd-64int";
use Net::Twitter::Lite::WithAPIv1_1;
use Encode;

my $conf_file = "conf.pl";
my $conf = do $conf_file or die "$!$@";

my $tw = Net::Twitter::Lite::WithAPIv1_1->new(
	consumer_key        => $conf->{consumer_key},
	consumer_secret     => $conf->{consumer_secret},
	access_token        => $conf->{access_token},
	access_token_secret => $conf->{access_token_secret},
	apiurl             => 'https://api.twitter.com/1.1',
	legacy_lists_api    => 0,
	ssl 			=> 1,
);

my $since_id = &get_since_id;
#print( "$since_id\n");
#$tw->update('testing...');
my $mentions = $tw->mentions({since_id => $since_id});
if( defined( $mentions->[0]->{id})){
	&set_since_id($mentions->[0]->{id});
}

#出力先ファイルを空にしておく
print '';

foreach my $mention (@{$mentions}){
	if( defined( $mention->{text})){
#		print "text:$mention->{text}\n";
#		print "scnm:$mention->{user}->{screen_name}\n";
		next if $mention->{text} =~ /RT/;
#作者のみ判定。今のところ外しておく。
#		next if $mention->{user}->{screen_name} eq 'ikatake';
		my $scnm = $mention->{user}->{screen_name};
		my $text = $mention->{text};
		$text =~s/\@_lifegamebot //g;
		if( $text eq 'init' or $text eq 'いにっと' ){
		#new指示があったとき、
			print "init\t${scnm}\n";
		}
		else{
			print "comment\t${scnm}\t${text}\n";
		}
	}
}

sub get_since_id{
	open my $infh, '<' , './since_id.txt' or die "$!";
	my $since_id = 0;
	while( my $line = <$infh>){
		last if $since_id ne 0;
		$since_id = $line;
	}
	close($infh);
	return $since_id;
}

sub set_since_id{
	my $since_id = shift;
	open my $outfh, '>', './since_id.txt' or die "$!";
	if($since_id ne ''){
		print $outfh $since_id. "\n"
	}
}

