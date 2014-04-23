use strict;
use warnings FATAL => 'all';
use Test::More;
use JSON::MaybeXS;

unless ( eval { require Cpanel::JSON::XS; 1 } ) {
    plan skip_all => 'No Cpanel::JSON::XS';
    done_testing;
    exit;
}

is( JSON, 'Cpanel::JSON::XS', 'Correct JSON class' );

is( \&encode_json,
    \&Cpanel::JSON::XS::encode_json,
    'Correct encode_json function'
);

is( \&decode_json,
    \&Cpanel::JSON::XS::decode_json,
    'Correct encode_json function'
);

done_testing;
