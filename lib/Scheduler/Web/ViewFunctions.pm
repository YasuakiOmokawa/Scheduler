package Scheduler::Web::ViewFunctions;
use strict;
use warnings;
use utf8;
use parent qw(Exporter);
use Module::Functions;
use File::Spec;

use Data::Dumper;

our @EXPORT = get_public_functions();

sub commify {
    local $_  = shift;
    1 while s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s;
    return $_;
}

sub c { Scheduler->context() }
sub uri_with { Scheduler->context()->req->uri_with(@_) }
sub uri_for { Scheduler->context()->uri_for(@_) }

sub get_user_id {
    return Scheduler->context()->session->get('user_name');
}


{
    my %static_file_cache;
    sub static_file {
        my $fname = shift;
        my $c = Scheduler->context;
        if (not exists $static_file_cache{$fname}) {
            my $fullpath = File::Spec->catfile($c->base_dir(), $fname);
            $static_file_cache{$fname} = (stat $fullpath)[9];
        }
        return $c->uri_for(
            $fname, {
                't' => $static_file_cache{$fname} || 0
            }
        );
    }
}

1;
