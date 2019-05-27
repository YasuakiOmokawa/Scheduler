package Scheduler::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;
use Time::Piece;

base_row_class 'Scheduler::DB::Row';

table {
    name 'schedules';
    pk 'id';
    columns qw(id title date);

    inflate 'date' => sub {
        my $col_value = shift;
        Time::Piece->strptime($col_value, '%s');
    };

    deflate 'date' => sub {
        my $col_value = shift;
        Time::Piece->strptime($col_value, '%Y/%m/%d')->epoch;
    };
};

1;
