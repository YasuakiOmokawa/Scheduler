package Scheduler::Web::Plugin::Session;
use strict;
use warnings;
use utf8;

use Amon2::Util;
use HTTP::Session2::ClientStore2;
use Crypt::CBC;

sub init {
    my ($class, $c) = @_;

    # Validate XSRF Token.
    $c->add_trigger(
        BEFORE_DISPATCH => sub {
            my ( $c ) = @_;
            if ($c->req->method ne 'GET' && $c->req->method ne 'HEAD') {
                my $token = $c->req->header('X-XSRF-TOKEN') || $c->req->param('XSRF-TOKEN');
                unless ($c->session->validate_xsrf_token($token)) {
                    return $c->create_simple_status_page(
                        403, 'XSRF detected.'
                    );
                }
            }
            # return $c->redirect('/login') unless $c->session->get('user_id'); # need login
            return;
        },
    );

    Amon2::Util::add_method($c, 'session', \&_session);

    # Inject cookie header after dispatching.
    $c->add_trigger(
        AFTER_DISPATCH => sub {
            my ( $c, $res ) = @_;
            if ($c->{session} && $res->can('cookies')) {
                $c->{session}->finalize_plack_response($res);
            }
            return;
        },
    );
}

# $c->session() accessor.
my $cipher = Crypt::CBC->new({
    key => '6mq3P9ew4x3_PvcwGz5vp_vo6TP4IHpB',
    cipher => 'Rijndael',
});
sub _session {
    my $self = shift;

    if (!exists $self->{session}) {
        $self->{session} = HTTP::Session2::ClientStore2->new(
            env => $self->req->env,
            secret => 'RU2wnauxnpTrM4ZMX1AwFkam6Fta_C4X',
            cipher => $cipher,
        );
    }
    return $self->{session};
}

1;
__END__

=head1 DESCRIPTION

This module manages session for Scheduler.
