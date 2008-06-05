use strict;
use warnings;
package Pod::Eventual;

sub read_handle {
  my ($self, $handle, $arg) = @_;
  $arg ||= {};

  my $in_pod  = $arg->{in_pod} ? 1 : 0;
  my $current;

  LINE: while (my $line = $handle->getline) {
    if ($line =~ /^=cut(?:\s*(.*)|$)/) {
      my $content = $1;
      $in_pod = 0;
      $self->record_event($current) if $current;
      undef $current;
      $self->record_event({
        type    => 'command',
        command => 'cut',
        content => $content,
      });
      next LINE;
    }

    $in_pod = 1 if $line =~ /^=\S+/;
    next LINE unless $in_pod;

    if ($line =~ /^$/) {
      $self->record_event($current) if $current;
      undef $current;
      next LINE;
    }

    if ($current) {
      $current->{content} .= $line;
      next LINE;
    }

    if ($line =~ /^=(\S+)(?:\s+(.+?))\z/s) {
      my $command = $1;
      my $content = $2;
      $current = {
        type    => 'command',
        command => $command,
        content => $content,
      };
      next LINE;
    }

    if ($line =~ /^(\s+.+)\z/s) {
      my $content = $1;
      $current = {
        type    => 'verbatim',
        content => $content,
      };
      next LINE;
    }
        
    $current = { type => 'text', content => $line };
  }

  $self->record_event($current) if $current;
  return;
}

sub record_event {
  my ($self, $event) = @_;

  use Data::Dumper;
  print Dumper($event);
}

1;
