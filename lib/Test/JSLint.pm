package Test::JSLint;

use 5.006;

use Mouse;
use English qw( -no_match_vars );
use File::Slurp qw( slurp );
use JS;
use JS::JSLint;

our $VERSION = '0.01';

extends 'Test::Builder::Module';

has engine => (
    is      => 'ro',
    isa     => 'Str',
    default => 'js',
);

has lib => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { (JS->new->find_js_path('jslint'))[0] },
);

has errors => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

sub ok {
    my ($self, $path, $arg_ref) = @_;
    my $name = "JSLint test for $path";
    my $test = __PACKAGE__->builder;

    if ( !$self->_jslint($path, $arg_ref) ) {
        $test->ok(0, $name);

        for my $error ( @{$self->errors} ) {
            $test->diag($error);
        }

        $self->errors([]);
        return;
    }

    $test->ok(1, $name);
    return 1;
}

sub all_ok {
}

sub _jslint {
    my ($self, $path, $arg_ref) = @_;

    my $source = eval { slurp $path };

    if ($EVAL_ERROR) {
        push @{$self->errors}, $EVAL_ERROR;
        return;
    }

    if (!$source) {
        push @{$self->errors}, "$path empty";
        return;
    }

    return 1;
}

sub _test_js {
    my ($self) = @_;
    my $engine = $self->engine;
    return `$engine -? 2>&1`;
}

__PACKAGE__->meta->make_immutable;

1;
