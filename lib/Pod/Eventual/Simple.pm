use strict;
use warnings;
package Pod::Eventual::Simple;
use Pod::Eventual;
BEGIN { our @ISA = 'Pod::Eventual' }
# ABSTRACT: just get an array of the stuff Pod::Eventual finds

=head1 SYNOPSIS

  use Pod::Eventual::Simple;

  my $output = Pod::Eventual::Simple->read_file('awesome.pod');

This subclass just returns an array reference when you use the reading methods.
The arrayref contains all the Pod events and non-Pod content.  Non-Pod content
is given as hashrefs like this:

  {
    type       => 'nonpod',
    content    => "This is just some text\n",
    start_line => 162,
  }

For just the POD events, grep for C<type> not equals "nonpod"

=begin Pod::Coverage

  new

=end Pod::Coverage

=cut

sub new {
  my ($class) = @_;
  bless [] => $class;
}

sub read_handle {
  my ($self, $handle, $arg) = @_;
  $self = $self->new unless ref $self;
  $self->SUPER::read_handle($handle, $arg);
  return [ @$self ];
}

sub handle_event {
  my ($self, $event) = @_;
  push @$self, $event;
}

BEGIN { *handle_blank = \&handle_event; }

sub handle_nonpod {
  my ($self, $line, $ln) = @_;
  push @$self, { type => 'nonpod', content => $line, start_line => $ln };
}

1;
