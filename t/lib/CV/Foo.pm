package CV::Foo;
use Dancer2 appname => 'CV';

use Exporter qw(import);
our @EXPORT = qw( before_feedback after_feedback );

# Method imported into the CV namespace and called at beginning of the `post /feedback` route
sub before_feedback {
  my $vars = @_;
  debug('in before_feedback sub');
  session 'feedback_given' => 1;
  redirect '/thanks?foo=1';
}

# Method imported into the CV namespace and called at end of the `post /feedback` route
sub after_feedback {
  my $vars = @_;
}

# A test method. Not used in production.
sub echo {
  my $arg = shift;
  return $arg;
}


1;


=pod

=head1 NAME

CV::Foo - Test library

=cut
