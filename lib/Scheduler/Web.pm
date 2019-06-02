package Scheduler::Web;
use strict;
use warnings;
use utf8;
use parent qw/Scheduler Amon2::Web/;
use File::Spec;

use Log::Minimal;
use Data::Dumper;

# dispatcher
use Scheduler::Web::Dispatcher;
sub dispatch {

    # do action first of all
    # if (Scheduler::Web::Dispatcher->can('before_action')) {
    #     Scheduler::Web::Dispatcher->before_action($_[0]);
    # }
    # return (Scheduler::Web::Dispatcher->can('before_action')->($_[0]) or die "before_action response is not generated");

    return (Scheduler::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::JSON',
    '+Scheduler::Web::Plugin::Session',
);

# setup view
use Scheduler::Web::View;
{
    sub create_view {
        my $view = Scheduler::Web::View->make_instance(__PACKAGE__);
        no warnings 'redefine';
        *Scheduler::Web::create_view = sub { $view }; # Class cache.
        $view
    }
}

__PACKAGE__->add_trigger(

    # is login?
    # BEFORE_ACTION => sub {
    #     my ( $c ) = @_;

    #     return $c->redirect('/login') unless $c->session->get('user_id');
    # },

    # for your security
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

1;
