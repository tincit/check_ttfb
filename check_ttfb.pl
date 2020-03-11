#!/usr/bin/perl

# 10.11.2016, Daniel Bienert / dbienert@tincit.de / https://blog.tincit.de
# check_ttfb.pl: Get website time to first byte using libCURL API interface
# v1.0.0

use FileHandle;
use WWW::Curl::Easy;

if($ARGV[0] eq '--help' || $ARGV[0] eq '-h'){
	print ("\n\n10.11.2016, Daniel Bienert / dbienert\@tincit.de / https://blog.tincit.de\n");
	print ("check_ttfb.pl: Get website time to first byte using libCURL API interface\n");
	print ("v1.0.0\n\n");

	print "Usage:\n";
	print "check_ttfb.pl <URL> <TTFB_WARN> <TTFB_CRIT>\n\n";
	print "Example:\n";
	print "check_ttfb.pl http://example.com 1.2 4\n\n";
	print "Arguments:\n";
	print "URL: HTTP/HTTPS website to perform the check on\n";
	print "TTFB_WARN: Issue a WARNING result after the server need this time to sent the first byte, in seconds\n";
	print "TTFB_CRIT: Issue a CRITICAL result after the server need this time to sent the first byte, in seconds\n";
	print "Remarks:\n";
	print "There is no check of the server response code (so this check does not distinguish between 200 - OK and 404 NOT FOUND for example)";
	print "This plugin does use libCURL https://curl.haxx.se/libcurl/";
	
	resultUNKNOWN("Called with --help / -h");
}

$pageUrl = $ARGV[0];
$ttfbWarn = $ARGV[1];
$ttfbCrit = $ARGV[2];

if( length($pageUrl) < 1 || $ttfbWarn == 0 || $ttfbCrit == 0){
	resultUNKNOWN("Wrong or missing check arguments");
}

my $curl = WWW::Curl::Easy->new;
my $null = FileHandle->new("> /dev/null");
if(!$null){
	resultUNKNOWN("Could not open /dev/null");
}

$curl->setopt(CURLOPT_URL, $pageUrl);
$curl->setopt(CURLOPT_HEADER,1);
$curl->setopt(CURLOPT_WRITEDATA,$null);

my $retCode = $curl->perform;

if ($retCode == 0) {
	my $ttfb = $curl->getinfo(CURLINFO_STARTTRANSFER_TIME);
	if($ttfb >= $ttfbCrit){
		resultCRIT("TTFB: $ttfb;|TTFB=$ttfb;$ttfbWarn;$ttfbCrit\n");
	} elsif ($ttfb >= $ttfbWarn){
		resultWARN("TTFB: $ttfb|TTFB=$ttfb;$ttfbWarn;$ttfbCrit\n");
	} else{
		resultOK("TTFB: $ttfb|TTFB=$ttfb;$ttfbWarn;$ttfbCrit\n");
	}
} else {
	resultUNKNOWN($curl->strerror($retCode) . " [Code $retCode]");
}

$null->close; 

sub resultOK {
	$mesg = shift;
	print "OK - $mesg";
	exit 0;
}

sub resultWARN {
	$mesg = shift;
	print "WARNING - $mesg";
	exit 1;
}

sub resultCRIT {
	$mesg = shift;
	print "CRITICAL - $mesg";
	exit 2;
}

sub resultUNKNOWN {
	$mesg = shift;
	print "UNKNOWN - $mesg";
	exit 3;
}
