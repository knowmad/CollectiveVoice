package CV::Foo;
use Dancer2 appname => 'CV';

sub do_something {
  my $self = shift;
  my $argv = shift || \@ARGV;

  return 1;
}

1;

=pod

=head1 NAME

CV::Foo - Test library

=cut
