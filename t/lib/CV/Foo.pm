package CV::Foo;
use Dancer2 appname => 'CV';

use Exporter qw(import);
our @EXPORT = qw( before_feedback after_feedback );

sub echo {
  my $arg = shift;
  return $arg;
}

sub before_feedback {
  my $vars = @_;
  debug('in before_feedback sub');
  session 'feedback_given' => 1;
  redirect '/thanks?foo=1';
}

sub after_feedback {
  my $vars = @_;
}


1;


=pod

=head1 NAME

CV::Foo - Test library

=cut
