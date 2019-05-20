use strict;
use warnings;
use Test::More;


use Scheduler;
use Scheduler::Web;
use Scheduler::Web::View;
use Scheduler::Web::ViewFunctions;

use Scheduler::DB::Schema;
use Scheduler::Web::Dispatcher;


pass "All modules can load.";

done_testing;
