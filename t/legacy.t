use strict;
use warnings FATAL => 'all';

use Test::Without::Module 'Cpanel::JSON::XS';
use Test::More;
use JSON::MaybeXS qw/:legacy/;



my $in = '[1, 2, 3, 4]';


my $arr = from_json($in);
my $j = to_json($arr);
is($j, '[1,2,3,4]');
is(ref($arr), 'ARRAY');

done_testing;

__END__

  to_json
       $json_text = to_json($perl_scalar)

    Converts the given Perl data structure to a json string.

    This function call is functionally identical to:

       $json_text = JSON->new->encode($perl_scalar)

  from_json
       $perl_scalar = from_json($json_text)

    The opposite of "to_json": expects a json string and tries to parse it,
    returning the resulting reference.

    This function call is functionally identical to:

        $perl_scalar = JSON->decode($json_text)
