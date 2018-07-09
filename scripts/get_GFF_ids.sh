perl -ne 'chomp; s/;+$//; @fields = split(/\t/); if($#fields == 8){$n++; for $item (split(/;/, $fields[-1])){print(join("\t", ($n, @fields[2], split(/=/, $item))), "\n")}}' $1
