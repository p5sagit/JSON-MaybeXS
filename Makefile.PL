use strict;
use warnings FATAL => 'all';
use 5.008001;
use ExtUtils::MakeMaker;
(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

WriteMakefile(
  NAME => 'JSON::MaybeXS',
  VERSION_FROM => 'lib/JSON/MaybeXS.pm',
  PREREQ_PM => {
    'JSON::PP' => '2.27202',
    'Test::Without::Module' => '0.17',
    (can_xs()
      ? ('Cpanel::JSON::XS' => '2.3310')
      : ())
  },
);

# can we locate a (the) C compiler
sub can_cc {
  my @chunks = split(/ /, $Config::Config{cc}) or return;

  # $Config{cc} may contain args; try to find out the program part
  while (@chunks) {
    return can_run("@chunks") || (pop(@chunks), next);
  }

  return;
}

# check if we can run some command
sub can_run {
  my ($cmd) = @_;

  return $cmd if -x $cmd;
  if (my $found_cmd = MM->maybe_command($cmd)) {
    return $found_cmd;
  }

  require File::Spec;
  for my $dir ((split /$Config::Config{path_sep}/, $ENV{PATH}), '.') {
    next if $dir eq '';
    my $abs = File::Spec->catfile($dir, $cmd);
    return $abs if (-x $abs or $abs = MM->maybe_command($abs));
  }

  return;
}

# Can our C compiler environment build XS files
sub can_xs {
  # Do we have the configure_requires checker?
  local $@;
  eval "require ExtUtils::CBuilder; ExtUtils::CBuilder->VERSION(0.27)";
  if ( $@ ) {
    # They don't obey configure_requires, so it is
    # someone old and delicate. Try to avoid hurting
    # them by falling back to an older simpler test.
    return can_cc();
  }

  # Do we have a working C compiler
  my $builder = ExtUtils::CBuilder->new(
    quiet => 1,
  );
  unless ( $builder->have_compiler ) {
    # No working C compiler
    return 0;
  }

  # Write a C file representative of what XS becomes
  require File::Temp;
  my ( $FH, $tmpfile ) = File::Temp::tempfile(
    "compilexs-XXXXX",
    SUFFIX => '.c',
  );
  binmode $FH;
  print $FH <<'END_C';
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

int main(int argc, char **argv) {
    return 0;
}

int boot_sanexs() {
    return 1;
}

END_C
  close $FH;

  # Can the C compiler access the same headers XS does
  my @libs   = ();
  my $object = undef;
  eval {
    local $^W = 0;
    $object = $builder->compile(
      source => $tmpfile,
    );
    @libs = $builder->link(
      objects     => $object,
      module_name => 'sanexs',
    );
  };
  my $result = $@ ? 0 : 1;

  # Clean up all the build files
  foreach ( $tmpfile, $object, @libs ) {
    next unless defined $_;
    1 while unlink;
  }

  return $result;
}
