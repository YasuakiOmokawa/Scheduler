package Scheduler::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Time::Piece;

any '/' => sub {
    my ($c) = @_;

    return $c->render('index.tx');
};

get '/user' => sub {
    my ($c) = @_;

    my ($name, $sex, $birthday) = qw(おもかわ 男 1985/06/06);
    return $c->render('user.tx', {
        name     => $name,
        sex      => $sex,
        birthday => $birthday
    });
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
