#!perl
use strict;
use warnings;
use Test::More;

eval 'use Test::JSLint';
plan skip_all => 'Test::JSLint not installed; skipping' if $@;

my $jslint = Test::JSLint->new;

$jslint->ok('foo.js');
$jslint->ok('bar.js');
$jslint->ok('baz.js');

diag $jslint->_test_js;

done_testing();
