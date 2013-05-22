package JSON::MaybeXS;

use strict;
use warnings FATAL => 'all';
use base qw(Exporter);

BEGIN {
  our $JSON_Class;

  our @err;

  if (eval { require Cpanel::JSON::XS; 1; }) {
    $JSON_Class = 'Cpanel::JSON::XS';
  } else {
    push @err, "Error loading Cpanel::JSON::XS: $@";
    if (eval { require JSON::PP; 1; }) {
      $JSON_Class = 'JSON::PP';
    } else {
      push @err, "Error loading JSON::PP: $@";
    }
  }
  unless ($JSON_Class) {
    die join("\n", "Couldn't load a JSON module:", @err);
  }
  $JSON_Class->import(qw(encode_json decode_json));
}

our @EXPORT = qw(encode_json decode_json JSON);

sub JSON () { our $JSON_Class }

1;
