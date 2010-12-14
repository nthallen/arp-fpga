#! /usr/bin/perl -w
use strict;

my %bus;
my %sig;

# sig 2 PORT
while (<>) {
	chomp; chomp;
	next if m/^Net\t/;
	s/\s.*$//;
	if ( m/^(\w+)(?:\[(\d+)\])?$/ ) {
		if ( defined $2 ) {
			my $bus = $1;
			my $pin = $2;
			$bus{$bus} ||= {};
			if ( defined $bus{$bus}->{$pin} ) {
				warn "$bus\[$pin\] redefined\n";
			} else {
				$bus{$bus}->{$pin} = 1;
			}
		} else {
			my $sig = $1;
			if ( defined $sig{$sig} ) {
				warn "$sig redefined\n";
			} else {
				$sig{$sig} = 1;
			}
		}
	} else {
		warn "Bad pattern: '$_'\n";
	}
}

for my $bus ( sort keys %bus ) {
	my @pins = sort { $a <=> $b } keys %{$bus{$bus}};
	my $min = shift @pins;
	my $cur = $min;
	while ( @pins ) {
		my $pin = shift @pins;
		if ( $pin != $cur+1 ) {
			warn "Gap in bus $bus\[\] between $cur and $pin\n";
		}
		$cur = $pin;
	}
	print "  $bus : OUT std_logic_vector ( $cur DOWNTO $min );\n";
}

for my $sig ( sort keys %sig ) {
  print "  $sig : OUT std_ulogic;\n";
}

