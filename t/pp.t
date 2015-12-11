use strict;
use warnings;

use Test::Without::Module 'Cpanel::JSON::XS', 'JSON::XS';
use if !eval { require JSON::PP; 1; }, 'Test::More', skip_all => 'No JSON::PP';
use Test::More;
use JSON::MaybeXS;

diag 'Using JSON::PP ', JSON::PP->VERSION;

is(JSON, 'JSON::PP', 'Correct JSON class');

is(
  \&encode_json, \&JSON::PP::encode_json,
  'Correct encode_json function'
);

is prototype \&decode_json, '$',
  'decode_json has correct prototype';

is_deeply decode_json '[]', [],
  'decode_json works as expected';

eval { decode_json undef }; my $msg = ' at ' . __FILE__ . ' line ' . __LINE__;
like $@, qr/\Q$msg\E/,
  'decode_json reports error at correct location';

require 't/lib/is_bool.pm';

done_testing;
