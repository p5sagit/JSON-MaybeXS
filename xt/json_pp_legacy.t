#!/usr/bin/env perl
use warnings;
use strict;
use FindBin qw/$Bin/;
$ENV{PERL_JSON_BACKEND} = 'JSON::PP';
require "$Bin/json_pm_legacy.t";
