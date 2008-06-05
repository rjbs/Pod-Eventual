use strict;
use warnings;

use Test::More tests => 1;
use Pod::Eventual;

my @events;
{
  package Test::Pod::Eventual;
  our @ISA = 'Pod::Eventual';
  sub handle_event { push @events, $_[1] }
}

Test::Pod::Eventual->read_file('eg/test.pod');

my $want = [
  {
    type    => 'command',
    command => 'pod',
    content => "\nsay 3;\n",
  },
  {
    type    => 'command',
    command => 'cut',
    content => "\n",
  },
  {
    type    => 'command',
    command => 'head1',
    content => "NAME\n",
  },
  {
    type    => 'text',
    content => "This is a test of the NAME header.\n",
  },
  {
    type    => 'command',
    command => 'head2',
    content => "Extended\n"
      . "This is all part of the head2 para, whether you believe it or not.\n",
  },
  {
    type    => 'text',
    content => "Then we're in a normal text paragraph.\n",
  },
  {
    type    => 'text',
    content => "Still normal!\n",
  },
  {
    type    => 'verbatim',
    content => "  This one is verbatim.\n",
  },
  {
    type    => 'text',
    content => "Then back to normal.\n",
  },
  {
    type    => 'verbatim',
    content => "  And then verbatim\n"
      . "Including a secondary unindented line.  Oops!  Should still work.\n",
  },
  {
    type    => 'command',
    command => 'cut',
    content => "\n",
  },
];

is_deeply(\@events, $want);
