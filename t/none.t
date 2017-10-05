use strict;
use warnings;

my @BACKENDS;
BEGIN {
    @BACKENDS = ('Cpanel/JSON/XS.pm', 'JSON/XS.pm', 'JSON/PP.pm');
}

# hide Cpanel::JSON::XS, JSON::XS, JSON::PP
use lib map {
    my $m = $_;
    sub { return unless $_[1] eq $m; die "Can't locate $m in \@INC (hidden).\n" };
} @BACKENDS;

use Test::More 0.88;

ok(!eval { require JSON::MaybeXS; 1 }, 'Class failed to load');

my $re_string = join '.*', map quotemeta("Can't locate $_"), @BACKENDS;
like(
  $@, qr{$re_string}s,
  'All errors reported'
);

done_testing;
