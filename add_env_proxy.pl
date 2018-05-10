#!/bin/env perl
use strict;
use warnings;
use YAML qw/Dump Load/;

sub main {

	local $/ = undef;
	my $yml = Load(<STDIN>);

	foreach my $service (qw/agent build/) {
		my $env = $yml->{services}->{$service}->{environment};
		push(@$env, qw/http_proxy https_proxy HTTP_PROXY HTTPS_PROXY/);
	}

	print Dump($yml);
}

main;
