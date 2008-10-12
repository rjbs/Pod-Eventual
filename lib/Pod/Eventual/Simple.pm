use strict;
use warnings;
package Pod::Eventual::Simple;
use Pod::Eventual;
BEGIN { our @ISA = 'Pod::Eventual' }

sub new {
  my ($class) = @_;
  bless [] => $class;
}

sub read_handle {
  my ($self, $handle, $arg) = @_;
  return $self->new->read_handle($handle, $arg) unless ref $self;
  $self->SUPER::read_handle($handle, $arg);
  return [ @$self ];
}

sub handle_event {
  my ($self, $event) = @_;
  push @$self, $event;
}

sub handle_nonpod {
  my ($self, $line) = @_;
  push @$self, $line;
}

1;  
