package JSON::MaybeXS;

use strict;
use warnings FATAL => 'all';
use base qw(Exporter);

our $VERSION = '1.000000';

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

=head1 NAME

JSON::MaybeXS - use L<Cpanel::JSON::XS> with a fallback to L<JSON::PP>

=head1 SYNOPSIS

  use JSON::MaybeXS;

  my $data_structure = decode_json($json_input);

  my $json_output = encode_json($data_structure);

  my $json = JSON->new;

=head1 DESCRIPTION

This module tries to load L<Cpanel::JSON::XS>, and if that fails instead
tries to load L<JSON::PP>. If neither is available, an exception will be
thrown.

It then exports the C<encode_json> and C<decode_json> functions from the
loaded module, along with a C<JSON> constant that returns the class name
for calling C<new> on.

=head1 EXPORTS

All of C<encode_json>, C<decode_json> and C<JSON> are exported by default.

To import only some symbols, specify them on the C<use> line:

  use JSON::MaybeXS qw(encode_json decode_json); # functions only

  use JSON::MaybeXS qw(JSON); # JSON constant only

=head2 encode_json

This is the C<encode_json> function provided by the selected implementation
module, and takes a perl data stucture which is serialised to JSON text.

  my $json_text = encode_json($data_structure);

=head2 decode_json

This is the C<decode_json> function provided by the selected implementation
module, and takes a string of JSON text to deserialise to a perl data structure.

  my $data_structure = decode_json($json_text);

=head2 JSON

The C<JSON> constant returns the selected implementation module's name for
use as a class name - so:

  my $json_obj = JSON->new; # returns a Cpanel::JSON::XS or JSON::PP object

and that object can then be used normally:

  my $data_structure = $json_obj->decode($json_text); # etc.

=head1 AUTHOR

mst - Matt S. Trout (cpan:MSTROUT) <mst@shadowcat.co.uk>

=head1 CONTRIBUTORS

None yet. Well volunteered? :)

=head1 COPYRIGHT

Copyright (c) 2013 the C<JSON::MaybeXS> L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
