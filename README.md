# check_ttfb
Nagios/Icinga Plugin to get website time to first byte (TTFB) using libCURL API interface

# Installation
1. Clone this repository and copy the check_ttfb.pl script to your plugin directory for example 

    /usr/lib/nagios/plugins/
 
2. Install (if not already present) the build-dependencies for WWW::Curl - debian example: 

    apt-get install libcurl4-openssl-dev
  
3. Install the WWW::Curl perl module

  cpan install WWW::Curl

# Usage

    check_ttfb.pl <URL> <TTFB_WARN> <TTFB_CRIT>

URL: HTTP/HTTPS website to perform the check on

TTFB_WARN: Issue a WARNING result after the server need this time to sent the first byte, in seconds

TTFB_CRIT: Issue a CRITICAL result after the server need this time to sent the first byte, in seconds


# Example

    check_ttfb.pl http://example.com 1.2 4.1

This check will issue WARNING if the ttfb is longer than 1.2 seconds and issue CRITICAL if it's longer than 4 seconds.

# pnp4nagios screenshot

this is the output if you use the perfdata of nagios in tools like pnp4nagios

![pnp4nagios screenshot](Screenshot_pnpnagios.png?raw=true "pnp4nagios Screenshot")
