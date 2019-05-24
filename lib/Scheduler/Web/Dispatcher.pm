package Scheduler::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Time::Piece;

any '/' => sub {
    my ($c) = @_;

    my @schedules = $c->db->search('schedules');
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

1;
