perl -ne 'if(!m/^chrom/){s/\+[^\t]+//g;@f=split(/\t/); print(join("\t",("\\N",@f[0..1,5..9]),length($f[9])), "\n")}' virtual.pept.csv > virtual.pept.sql
perl -pe 's/^/\\N\t/;s/virtual\t1\t1\t//' variations.csv > variations.sql

