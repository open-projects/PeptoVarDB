#!/usr/bin/perl -w
use strict;

use CGI qw/:standard/;
use DBI;

$CGI::LIST_CONTEXT_WARN = 0;

my $DEBUG = 0;

my $host = '192.168.1.2';
#my $host = '127.0.0.1';
my $port = '3306';
my $user = 'www';
my $pass = 'wwwtrnimmuno';
my $db   = 'PeptoVar';

my $qdata = param('query_text');
my $qtype = param('query_type');
my @qlen = param('peptlen[]');

$qdata =~ s/[ ,;].*//; # no multiple queries!

print header();

my $result = '<p id="query_message"><strong>The query: </strong>';
$result .= "$qtype = $qdata; peptide_length(s) = ".join(", ", @qlen)."</p>\n";
$result .= table_header();
my @data = ();

my $dsn = "DBI:mysql:$db:$host:$port";
my $dbh = DBI->connect($dsn, $user, $pass);
if (!$dbh) {
    $result .= '<tr><td>DATABASE CONNECTION ERROR</td><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td></tr>';
} else {
    if ($qtype eq 'sequence' && $qdata !~ m/[^A-Z]/i) {
        if (@qlen == 0) {
            push(@qlen, length($qdata));
        }
        for my $len (@qlen) {
            my $pos = 0;
            while (my $seq = substr($qdata, $pos++, $len)) {
                last if length($seq) != $len;
                get_pep($seq);
            }
        }
    } elsif ($qtype eq 'isoform_ID' && $qdata !~ m/[^A-Z0-9_:#-]/i) {
        if (@qlen == 0) {
            push(@qlen, 9); # default_value = 9
        }
        for my $len (@qlen) {
            get_trn($qdata, $len);
        }
    } elsif ($qtype eq 'variation_ID' && $qdata !~ m/[^A-Z0-9_:#-]/i) {
        if (@qlen == 0) {
            push(@qlen, 9); # default_value = 9
        }
        for my $len (@qlen) {
            get_var($qdata, $len);
        }
    } else {
        $result .= '<tr><td>QUERY ERROR</td><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td></tr>';
    }
    
    if (@data) {
        $result .= '<tr>'.join("</tr>\n<tr>", @data).'</tr>';
    } else {
        $result .= '<tr><td>NO ENTRIES</td><td> </td><td> </td><td> </td><td> </td><td> </td><td> </td></tr>';
    }
    
    if ($DEBUG) {
        open(LOG, ">/tmp/log.txt");
        print LOG '<tr>'.join("</tr>\n<tr>", @data).'</tr>';
        close(LOG);
    }
}
$result .= table_footer();
print $result;

1;

###################### subs #############################
sub get_pep {
    my $select_peptide = $dbh->prepare(qq/
        SELECT GROUP_CONCAT(DISTINCT transcript_id SEPARATOR ' '),
        chrom, beg, end, upstream_fshifts, variations, peptide
        FROM peptides
        WHERE peptide = ?
        GROUP BY chrom, beg, end, upstream_fshifts, variations, peptide
        ORDER BY chrom, beg, end
    /);
    $select_peptide->execute(shift);
    while (my ($transcript_id, $chrom, $beg, $end, $upstr, $vars, $pept) = $select_peptide->fetchrow_array()) {
        push @data, table_row($transcript_id, $chrom, posclean($beg), posclean($end), upstrclean($upstr), varclean($vars), $pept);
    }
    return
}

sub get_trn {
    my $select_transcript = $dbh->prepare(qq/
        SELECT transcript_id,
        chrom, beg, end, upstream_fshifts, variations, peptide
        FROM peptides
        WHERE transcript_id = ? AND length = ?
	GROUP BY transcript_id, chrom, beg, end, upstream_fshifts, variations, peptide
        ORDER BY length, chrom, beg, end
    /);
    $select_transcript->execute(shift, shift);
    while (my ($transcript_id, $chrom, $beg, $end, $upstr, $vars, $pept) = $select_transcript->fetchrow_array()) {
        push @data, table_row($transcript_id, $chrom, posclean($beg), posclean($end), upstrclean($upstr), varclean($vars), $pept);
    }
}

sub get_var {
    my $select_variation = $dbh->prepare(qq/
        SELECT GROUP_CONCAT(DISTINCT transcript_id SEPARATOR ' '),
        chrom, beg, end, upstream_fshifts, variations, peptide
        FROM peptides AS t1 INNER JOIN var2pept AS t2 USING(pept_id)
        WHERE snp_id = ? AND length = ?
        GROUP BY chrom, beg, end, upstream_fshifts, variations, peptide
        ORDER BY chrom, beg, end
    /);
    $select_variation->execute(shift, shift);
    while (my ($transcript_id, $chrom, $beg, $end, $upstr, $vars, $pept) = $select_variation->fetchrow_array()) {
        push @data, table_row($transcript_id, $chrom, posclean($beg), posclean($end), upstrclean($upstr), varclean($vars), $pept);
    }
}

sub table_header {
    my $header = '<table class="table table-condensed">
        <thead>
        <tr>
        <th>Transcript_ID</th>
        <th>Chrom</th>
        <th>Beg</th>
        <th>End</th>
        <th>Upstream frame shits</th>
        <th>Variations inside</th>
        <th>Peptide</th>
        </tr>
        </thead>
        <tbody>'."\n";
    return $header;
}

sub table_footer {
    return "\n</tbody></table>";
}

sub table_row {
    if (@_) {
        return '<td>'.join('</td><td>', @_).'</td>';
    }
    return '';
}

sub posclean {
    my $field = shift;
    $field =~ s/\.0$//;
    return $field;
}

sub upstrclean {
    my $field = shift;
    my %fields = ();
    for my $path (split(/\|/, $field)) {
        $fields{$path} = 1;
    }
    $field = join('<strong> OR <\/strong>', keys %fields);
    return $field;
}

sub varclean {
    my $field = shift;
    $field =~ s/&/, /;
    return $field;
}

# CGI
#my $name = param('name');
#print header;
#print start_html;
#print "Hello, $name!";
#print end_html;

