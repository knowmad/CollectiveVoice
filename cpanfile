=comment

Install all dependencies with:

    cpanm --installdeps . --with-develop --with-all-features

Note on version specification syntax:

    # Any version of My::Module equal or higher than 0.01 is required
    requires 'My::Module' => '0.01';

    # ditto
    requires 'My::Module' => '>= 0.01';

    # Exactly My::Module v0.01 is required
    requires 'My::Module' => '== 0.01';

See https://metacpan.org/pod/CPAN::Meta::Spec#VERSION-NUMBERS for details.

=cut

requires 'perl', '5.30.0';
requires 'YAML';
requires 'YAML::XS';
requires 'Text::CSV';
requires "Dancer2" => "0.300000";
requires 'CBOR::XS';
requires 'Import::Base';
requires 'Scope::Guard';
requires 'Scope::Upper';
requires 'Class::XSAccessor';
requires 'Cpanel::JSON::XS';
requires 'URL::Encode::XS';
requires 'CGI::Deurl::XS';
requires 'Type::Tiny::XS';
requires 'HTTP::Parser::XS';
requires 'HTTP::XSCookies';
requires 'HTTP::XSHeaders';
requires 'MooX::TypeTiny';
requires 'Math::Random::ISAAC::XS';
requires 'Crypt::URandom';
requires 'Template';
requires 'Plack';
requires 'Plack::Middleware::ReverseProxy';
requires 'Plack::Middleware::ConditionalGET';
requires 'AnyEvent';
requires 'Twiggy';
requires 'Server::Starter';
requires 'Daemon::Control';
requires 'Dancer2::Logger::Log4perl';
requires 'Dancer2::Plugin::Deferred';
requires 'Dancer2::Plugin::Minify';
requires 'Dancer2::Plugin::Syntax::GetPost';
requires 'Dancer2::Session::Cookie';
requires 'Dancer2::Plugin::Adapter';
requires 'Starlet';
requires 'Server::Starter';
requires 'Email::Valid';
requires 'Email::Sender::Simple';
requires 'Email::Simple';
requires 'Authen::SASL';
requires 'Number::Phone';
requires 'Number::Phone::NANP';

# Expect this list to get pruned, not sure how some are different than others
on 'develop' => sub {
    requires 'App::Ack';
    requires 'Dancer2::Debugger';
    requires 'Plack::Middleware::DebugLogging';
    requires 'Plack::Middleware::Debug::Log4perl';
    requires 'Plack::Middleware::Debug::Template';
};

on 'test' => sub {
    requires 'Test::Most';
    requires 'HTTP::Request::Common';
    requires 'Test::WWW::Mechanize::PSGI';
};
