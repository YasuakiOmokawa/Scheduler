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

    return $c->render('index.tx', { schedules => \@schedules });
};

post '/post' => sub {
    my ($c) = @_;

    my $title = $c->req->parameters->{title};
    my $date  = $c->req->parameters->{date};

    my $date_epoch = Time::Piece->strptime($date, '%Y/%m/%d')->epoch;

    $c->db->insert(schedules => {
        title => $title,
        date  => $date_epoch,
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
