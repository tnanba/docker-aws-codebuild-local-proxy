#!/bin/env perl
use strict;
use warnings;
use YAML::Tiny;

sub main {

	local $/ = undef;
	my $yml = Load(<STDIN>);

	foreach my $service_name (qw/agent build/) {

		my $service = $yml->{services}->{$service_name};
		my $env = $service->{environment};

		# Add proxy configuration to "services/(agent|build)/environment"
		push(@$env, qw/http_proxy https_proxy HTTP_PROXY HTTPS_PROXY/);

		# Exclude link names from proxy
		my $links = $service->{links};
		my @link_names;

		foreach my $link (@$links) {
			if ($link =~ /^(.+):(.+)$/) {
				push(@link_names, $2);
			} else {
				push(@link_names, $link);
			}
		}

		if (scalar(@link_names) != 0) {
			my $no_proxy = join(',', @link_names);
			push(@$env, "$_=$no_proxy") foreach qw/no_proxy NO_PROXY/;
		}
	}

	# Add volume "/var/run/docker.sock" to build service volumes.
	# (to build docker image)
	my $volumes = $yml->{services}->{build}->{volumes} || [];
	push(@$volumes, '/var/run/docker.sock:/var/run/docker.sock');
	$yml->{services}->{build}->{volumes} = $volumes;

	print Dump($yml);
}

main;
