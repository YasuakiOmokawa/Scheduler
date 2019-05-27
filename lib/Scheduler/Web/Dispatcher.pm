package Scheduler::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Time::Piece;

any '/' => sub {
    my ($c) = @_;

    return $c->redirect('/login') unless $c->session->get('user_id');

    my $order = $c->req->parameters->{order};
    my $order_arg = ($order and $order eq 'reverse') ? 'date' : 'date DESC';
    my @schedules = $c->db->search('schedules', {}, {order_by => $order_arg});

    my $today = Time::Piece->localtime();

    return $c->render('index.tx', {
        schedules => \@schedules,
        today => $today});
};

post '/post' => sub {
    my ($c) = @_;

    $c->db->insert(schedules => {
        title => $c->req->parameters->{title},
        date  => $c->req->parameters->{date},
    });

    return $c->redirect('/');
};

post '/schedules/:id/delete' => sub {
    my ($c, $args) = @_;

    my $id = $args->{id};
    $c->db->delete('schedules' => {id => $id});
    return $c->redirect('/');
};

get '/login' => sub {
    my ($c) = @_;

    return $c->render('login.tx');
};

my $users = {
    1 => { pass => 11111 },
    2 => { pass => 22222 }
};

post '/login' => sub {
    my ($c) = @_;

    my $id = $c->req->parameters->{id};
    my $password = $c->req->parameters->{password};

    if ($users->{$id}->{pass} eq $password) {

        $c->session->regenerate_id(); # to prevent session fixation attacks
        $c->session->set('user_id' => $id);
    } else {

        return $c->redirect('/login');
    }

    return $c->redirect('/');
};

1;
