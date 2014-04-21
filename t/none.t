use strict;
use warnings FATAL => 'all';
use Test::Without::Module 'Cpanel::JSON::XS';
use Test::Without::Module 'JSON::XS';
use Test::Without::Module 'JSON::PP';
use Test::More;

ok(!eval { require JSON::MaybeXS; 1 }, 'Class failed to load');

# Test::Without::Module always causes 'did not return a true value' errors

like(
  $@, qr{Cpanel/JSON/XS.pm did not.*JSON/XS.pm did not.*JSON/PP.pm did not}s,
  'All errors reported'
);

done_testing;
