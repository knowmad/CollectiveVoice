package CV;

use CV::Base qw( WebApp );
use Dancer2::Plugin::Debugger;
use Try::Tiny;
use Email::Valid;
use Number::Phone;

# Semantic versioning FTW
our $VERSION = '1.0.2';

# Layout MUST be set no later than the before hook!
hook 'before' => sub {
    my $ajax = request_header 'X-Requested-With';
    if( defined $ajax and $ajax eq 'XMLHttpRequest' ) {
        set layout => undef;
        var ajax => 1;
    } else {
        set layout => 'main';
        var ajax => 0;
    }
};
hook on_route_exception => sub {
    my ($app, $error) = @_;
    if ( ($error =~ /undefined value/) && !exists(config->{ review_sites }) ) {
      my $confdir = $ENV{DANCER_CONFDIR} || '';
      error ("ERROR: Have you defined review_sites in your config file and given the path to DANCER_CONFDIR ($confdir)? [", $error, ']')
    }
    else {
      error("Oops: ", $error);
    }
};

get '/'  => sub {
    my @sites    = config->{ review_sites }->@*;
    my $top_site = shift @sites;
    render( 'index', {
        'meta_title'       => config->{'meta_title'},
        'company_name'     => config->{'company_name'},
        'company_logo'     => config->{'company_logo'},
        'page_title'       => config->{'page_title'},
        'page_description' => config->{'page_description'},
        'ratings'          => config->{ ratings },
        'top_review_site'  => $top_site,
        'review_sites'     => \@sites,
        'logos'            => config->{ logos },
    });
};

post '/feedback' => sub {
    # Trap the bots in an accessible way
    my $spam_1 = body_parameters->get( 'go' );
    my $spam_2 = body_parameters->get( 'away' );

    redirect 'https://en.wikipedia.org/wiki/Three_Laws_of_Robotics'
        if $spam_1 || $spam_2;

    # Ok, we seem to be a real human, so generate some feedback
    my %errors;

    my $name = body_parameters->get( 'full_name' );
    $errors{ no_name } = 'Please enter your full name.' unless $name;

    my $email_address = body_parameters->get( 'email_address' );
    if( defined $email_address and $email_address ne '' ) {
        $errors{ bad_email } = 'Please enter a valid email address (i.e., foo@bar.com).'
            unless Email::Valid->address( $email_address );
    } else {
        $errors{ no_email } = 'Please enter your email address.';
    }

    my $phone_number = body_parameters->get( 'phone_number' );
    my $phone;
    if( $phone_number ) {
        $phone = Number::Phone->new( 'US', $phone_number );
        if( !defined $phone or not $phone->is_valid ) {
            $errors{ bad_phone } = 'Please enter a valid phone number.';
        }
    }

    my $feedback = body_parameters->get( 'feedback' );
    $errors{ no_feedback } = 'Please provide some feedback.' unless $feedback;

    if( %errors ) {
        status 400;
        send_as JSON => \%errors;
    } else {
        my $result;
        try {
            my $sg  = Email::SendGrid::V3->new( api_key => config->{ sendgrid }{ api_key } );
            $result =
                $sg->from( config->{ sendgrid }{ from } )
                   ->subject( "[CollectiveVoice] You've received new feedback!" )
                   ->add_content( 'text/plain',
                        template 'email_feedback', {
                            full_name     => $name,
                            email_address => $email_address,
                            phone_number  => $phone,
                            feedback      => $feedback,
                            company_name  => config->{'company_name'},
                        },{ layout => undef }
                    )
                   ->add_envelope( to => \@{ config->{ contact_email } } )
                   ->send;

            die $result->{ reason } unless $result->{ success };
        } catch {
            my $error_msg = "Couldn't send feedback email: $_";
            error $error_msg;
            status 400;
            $errors{ err_message } = $_;
            $errors{ no_email_send } = 1;
            send_as JSON => \%errors;
        };
        # $result->{ success };
        session 'feedback_given' => 1;
    }
};

#
# I was going to make this a modal, but I am leaving this as a full page render for
# now. It makes for a slightly different workflow from the software we are emulating,
# and I think it helps ensure that we can't easily double-submit the same form. This
# just seems really clean.
#
# We can make this a modal again easily enough.
#
get '/thanks' => sub {
    # TODO (later): disable reviews once feedback form is submitted.
    if( session->read( 'feedback_given' ) || params->{'review'} ){
        app->destroy_session;
        render( 'thanks', {
            title        => 'Collective Voice',
            company_name => config->{ company_name },
            company_url  => config->{ company_url },
            company_logo => config->{ company_logo },
            brand_color  => config->{ brand_color },
        });
    } else {
        my $fb = session->read( 'feedback_given') || '';
        error ("User is trying to access the /thanks page with improper credentials. Are sessions setup accurately? (feedback_given = $fb)");
        redirect '/';
    }
};

# Conditionally minify page
hook after_layout_render => sub( $ref_content ) {
    if( $ENV{ DANCER_ENVIRONMENT } && $ENV{ DANCER_ENVIRONMENT } eq 'production' ) {
        my $content = ${ $ref_content };
        $content = minify( html => $content, {
            remove_comments     => 1,
            remove_newlines     => 1,
            no_compress_comment => 1,
            html5               => 1,
            do_javascript       => 'best',
            do_stylesheet       => 'minify'
        });
        ${ $ref_content } = $content;
    }
};

# Send an AJAX-y (or non-AJAX-y) response
sub render( $template, $args ) {
    croak "render(): No template specified!" unless $template;

    my $ajax = var 'ajax' // 0;
    my $html = template( $template, $args );

    if( $ajax ) {
        send_as 'JSON' => {
            content          => $html,
            page_title       => $args->{ page_title },
            page_description => $args->{ page_description },
        };
    } else {
        return $html;
    }
}

true;

__END__

=pod

=encoding UTF-8

=head1 NAME

Collective Voice (CV) - a Dancer2 app to generate online reviews

=head1 VERSION

version 1.0.0

=head1 DESCRIPTION

Collective Voice is a Dancer2 application built to help companies generate more
positive online reviews.

=head1 AUTHOR

William McKee (knowmad)

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by William McKee.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

=cut
