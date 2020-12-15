package CV::Base;

use parent 'Import::Base';

# Modules that are always imported
our @IMPORT_MODULES = (
    'strict',
    'warnings',
    'utf8',
    'Carp'    => [qw( croak confess )],
    'open'    => [qw( :std :utf8 )],
    'feature' => [qw( signatures :5.30 )],
    # Put this last to make sure nobody else can re-enable this warning
    '>-warnings' => [qw( experimental::signatures )],
);
 
# Optional bundles
our %IMPORT_BUNDLES = (
    CLI    => [ qw( Getopt::Long )],
    WebApp => [ qw( Dancer2 Dancer2::Plugin::Minify Dancer2::Plugin::Deferred 
        Dancer2::Plugin::Adapter Dancer2::Plugin::Syntax::GetPost Email::SendGrid::V3 )],
    Object => [ qw( Moo )],
    Test   => [ qw( Test::Most )],
);

1;

=pod

=head1 NAME

CV::Base - Import standard sets of modules into CollectiveVoice

=head1 SYNOPSIS

    use CV::Base;
    use CV::Base qw( CLI Test );
    
=head1 DESCRIPTION

C<CV::Base> makes it easy to include commonly used bundles of 
modules. These bundles will help to avoid boilerplate, and make it easier
to update to newer versions of Perl and modules by centralizing many
use directives in one spot.

=head1 BUNDLES

All bundles include the following modules and language features:

=over 4

=item * Perl 5.30 (strict, warnings, say, and more)

=item * Subroutine signatures

=item * UTF-8

=back

=head2 CLI

Modules used for CLI programs.

=head2 Object

Modules used when constructing objects.

=head2 Test

Used by all test programs.

=head2 WebApp

Used by any web-based applications.

=head1 SEE ALSO

=over 4

=item * L<Import::Base>

=item * L<https://perldoc.perl.org/feature.html>

=back

=cut
