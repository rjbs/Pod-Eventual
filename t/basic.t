use strict;
use warnings;

use Pod::Eventual;

use IO::File;

my $file = IO::File->new('test.pod');

Pod::Eventual->read_handle($file);
