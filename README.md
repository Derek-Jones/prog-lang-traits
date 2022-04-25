Basic information about programming languagei traits that can be used to create a phylogenetic tree showing language similarity (based on some trait), such as the one below.

Blog post [discussing the issues and decisions.](https://shape-of-code.com/2022/04/24/programming-language-similarity-based-on-their-traits/)

New language trait files go in: lang-info

To regenerate the lang.csv file (read by the code that generates the trees), run:

mkcsv.sh > lang-info/lang.csv

The R code contains some consistency checks on the file contents, e.g., look for binary operator counts being lower/higher than the corresponding operators (such as there being more pluses than minuses).

If a new trait is created, the mkcsv.awk file needs to be updated to recognise it.

![Language similarity based on their keywords](https://www.shape-of-code.com/images/keyword-phylo.png)

and

![based on their binary operators](https://www.shape-of-code.com/images/binop-phylo.png)
