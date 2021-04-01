package CV::Foo;
use Dancer2 appname => 'CV';

sub echo {
  my $arg = shift;
  return $arg;
}

sub before_feedback {
  my $vars = @_;
}

sub after_feedback {
  my $vars = @_;
}


1;


=pod

=head1 NAME

CV::Foo - Test library

=cut
