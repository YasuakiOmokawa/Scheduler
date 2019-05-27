package Scheduler::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Time::Piece;

any '/' => sub {
    my ($c) = @_;

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

1;
