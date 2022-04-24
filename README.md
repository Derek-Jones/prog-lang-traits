Basic information about programming languages that can be used to create a phylogenetic tree showing language similarity (based on some trait), such as the one below.

Add language information to lang-info

To regenerate the lang.csv file, read by the R code, run

mkcsv.sh > lang-info/lang.csv

The R code contains some consistency checks on the file
contents, e.g., look for binary operator counts being lower/higher
than the corresponding operators (such as there being more pluses
than minuses).

If a new trait is created, the mkcsv.awk file needs to be updated to recognise it.

![Language similarity based on their keywords](https://myoctocat.com/assets/images/base-octocat.svg)

