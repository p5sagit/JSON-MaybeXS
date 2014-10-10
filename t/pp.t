use strict;
use warnings FATAL => 'all';
use Test::Without::Module 'Cpanel::JSON::XS', 'JSON::XS';
use if !eval { require JSON::PP; 1; }, 'Test::More', skip_all => 'No JSON::PP';
use Test::More;
use JSON::MaybeXS;

is(JSON, 'JSON::PP', 'Correct JSON class');

is(
  \&encode_json, \&JSON::PP::encode_json,
  'Correct encode_json function'
);

is(
  \&decode_json, \&JSON::PP::decode_json,
  'Correct encode_json function'
);

require 't/lib/is_bool.pm';

done_testing;
