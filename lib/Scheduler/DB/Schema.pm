package Scheduler::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'Scheduler::DB::Row';

table {
    name 'schedules';
    pk 'id';
    columns qw(id title date);
};

1;
