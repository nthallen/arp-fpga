#! /usr/bin/perl -w
use strict;

my %sig;
my %param;
my %valueless;

while (<>) {
  s/\s+$//; # Remove EOL
  my $line = $_;
  next if m/^\s*(?:#.*)?$/;
  if ( s/^\s*Net\s+(\S+)\s+//i ) {
    my $net = dequote($1);
    $sig{$net} ||= {};
    my $netref = $sig{$net};
    while ( 1 ) {
      if ( s/^(\S+)\s*=\s*([^ ;|]+)\s*// ) {
        my $param = $1;
        my $value = dequote($2);
        $param{$param} = 1;
        warn "Unexpected value for param $param: '$line'\n"
          if $valueless{$param};
        warn "Redefinition of $net $param\n" if defined $netref->{$param};
        $netref->{$param} = $value;
      } elsif ( s/^([^ ;|]+)\s*// ) {
        my $param = $1;
        warn "Expected value for param $param: '$line'\n"
          if $param{$param};
        $valueless{$param} = 1;
        $netref->{$param} = 1;
      } else {
        last;
      }
      last unless s/^\|\s*//;
    }
    warn "Unrecognized stuff at EOL: '$line' at '$_'\n"
      unless m/^;\s*(?:#.*)?$/;
  } else {
    warn "Unrecognized line: '$line'\n";
  }
}

# print "Params: ", join(' ', sort keys %param), "\n";
# print "Valueless Params: ", join(' ', sort keys %valueless), "\n";
my @params = sort keys %param;
my @valueless = sort keys %valueless;
print join("\t", "Net", @params, "Other" ), "\n";
for my $net ( sort keys %sig ) {
  my $netref = $sig{$net};
  print join( "\t", $net, map( $netref->{$_} || '', @params ),
    join(' | ', grep( $netref->{$_}, @valueless ) ) ), "\n";
}

sub dequote {
  my $arg = shift(@_);
  $arg =~ s/^"([^"]*)"$/$1/;
  return $arg;
}
