#! /usr/bin/perl -w
my @ignore = qw(N Other FPGANet BoardNet Notes);
my %ignore;
for my $hdr ( @ignore ) {
  $ignore{$hdr} = 1;
}
my $line = <>;
$line =~ s/\s*$//;
my @headers = split(/\t/,$line);
my %header;
my @valparam;
for my $i ( 0 .. $#headers ) {
  my $hdr = $headers[$i];
  $header{$hdr} = $i;
  push( @valparam, $i ) unless $ignore{$hdr};
}
for my $hdr ( qw(FPGANet BoardNet) ) {
  die "No $hdr column\n" unless defined $header{$hdr};
}
my $Neti = $header{FPGANet};
my $BNeti = $header{BoardNet};
my $Otheri = $header{Other} || @headers;
my $Notei = $header{Notes} || @headers;
while ($line = <>) {
  $line =~ s/\s*$//;
  my @flds = split(/\t/,$line);
  next unless $flds[$BNeti];
  if ( $flds[$Neti] ) {
    print "Net $flds[$Neti]";
  } else {
    print "#Net $flds[$BNeti]";
  }
  my @pi = grep $flds[$_], @valparam;
  print join " |", map " $headers[$_] = $flds[$_]", @pi;
  if ( $flds[$Otheri] ) {
    print " |" if @pi;
    print $flds[$Otheri];
  }
  print "; #";
  print " $flds[$BNeti]" if $flds[$Neti];
  print " $flds[$Notei]" if $flds[$Notei];
  print "\n";
}
