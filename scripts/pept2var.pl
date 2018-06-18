#!/usr/bin/perl -w
use strict;


my $file_name = $ARGV[0];
open(IN, "< $file_name") || die "can't open file: $file_name\n";
while(<IN>) {
    chomp;
    my ($pept, $fsh, $var) = (split(/\t/))[0,1,2];
    my $altframe = 0;
    if ($fsh ne '-') {
	my $altframe = 0;
	if ($fsh !~ m/\|-|-\|/) {
	    $altframe = 1;
	}
        my @fsh = split(/\|/, $fsh);
        my %paths = ();
        for my $fsh (@fsh) {
            $paths{$fsh} = 1;
        }
        my $chain_n = 0;
        for my $fsh_chain (keys %paths) {
            $chain_n++;
            if ($var ne '-') {
                my @var = split(/&/, $var);
                for my $invar (@var) {
                    for my $varvar (split(/,/, $invar)){
                        while ($varvar =~ m/([^\(\).]+):[^\(\)]+\((alt|ref)\)(\]?)/g) {
                            if ($3) {
                        	print join("\t", $pept, $chain_n, $1, $2, 0, 'in', $altframe), "\n";
			    } else {
				print join("\t", $pept, $chain_n, $1, $2, 1, 'in', $altframe), "\n"; # nonsynonymous
			    }
                        }
                    }
                }
            }
            for my $fsh_var (split(/,/, $fsh_chain)){
                while ($fsh_var =~ m/([^\(\).]+):[^\(\)]+\(alt\)/g) {
                    print join("\t", $pept, $chain_n, $1, 'alt', 1, 'up', $altframe), "\n";
                }
            }
        }
    } else {
        if ($var ne '-') {
            my @var = split(/&/, $var);
            for my $invar (@var) {
                for my $varvar (split(/,/, $invar)){
                    #while ($varvar =~ m/([^\(\).]+):[^\(\)]+\((alt|ref)\)(&|$)/g) {
		    while ($varvar =~ m/([^\(\).]+):[^\(\)]+\((alt|ref)\)(\]?)/g) {
                        if ($3) {
			    print join("\t", $pept, 0, $1, $2, 0, 'in', $altframe), "\n";
			} else {
			    print join("\t", $pept, 0, $1, $2, 1, 'in', $altframe), "\n"; # nonsynonimous
			}
                    }
                }
            }
        }
    }
}
