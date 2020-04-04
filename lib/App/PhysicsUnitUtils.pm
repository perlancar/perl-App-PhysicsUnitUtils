package App::PhysicsUnitUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{convert_unit} = {
    v => 1.1,
    summary => 'Convert a physical quantity from one unit to another',
    description => <<'_',

If target unit is not specified, will show all known conversions.

_
    args => {
        quantity => {
            # schema => 'physical::quantity*', # XXX Perinci::Sub::GetArgs::Argv is not smart enough to coerce from string
            schema => 'str*',
            req => 1,
            pos => 0,
        },
        to_unit => {
            schema => 'physical::unit',
            pos => 1,
        },
    },
    examples => [
        {args=>{quantity=>'m/s'}, summary=>'Show all possible conversions for speed'},
        {args=>{quantity=>'40 m/s', to_unit=>'kph'}, summary=>'Convert from meters/sec to kilometers/hour'},
    ],
};
sub convert_unit {
    require Physics::Unit;

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @units;
        # XXX make it more efficient
        for my $u (Physics::Unit::ListUnits()) {
            push @units, $u if $quantity->type eq Physics::Unit::GetUnit($u)->type;
        }

        my @rows;
        for my $u (@units) {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

1;
#ABSTRACT: Utilities related to Physics::Unit

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

L<Physics::Unit>

=cut
