#
# mkphylo.R, 24 Apr 22
#
# Build phylogenetic trees from one or more traits in lang.csv
# Uses a distance matrix approach

library("ape")
library("colorspace")
library("reshape2")

pal_col=rainbow(2)

phylo_plot=function(l_info, info_str="")
{
k_data=dcast(l_info, value ~ language, length)
k_data$value=NULL
k_adj=as.matrix(k_data)

key_dist=dist(t(k_adj))

key_phy=nj(key_dist)
plot(key_phy, cex=1.3, tip.color=pal_col[1], edge.color=pal_col[2], main=info_str)

return(key_dist)
}


# Generate num_iter variants of each language
boot_lang=function(l_info, num_iter=100)
{
# Generate for one language
boot_trait=function(lang_col)
   {
   # Add 5% new traits, rounded up
   num_new_trait=trunc(0.5+0.05*sum(k_adj[ , lang_col]))
   new_tree=function()
      {
      # A random sample of new trait values drawn from all possible values
      new_traits=sample(1:num_traits, num_new_trait)
      mod_adj=k_adj
      mod_adj[new_traits, lang_col]=1 # ignore the possibility that trait is already present

      # Build tree
      key_dist=dist(t(mod_adj))
      t=NULL # otherwise any global t will be used :-O
      t[[1]]=nj(key_dist) # using as.list does not have the desired effect
      return(t)
      }
   return(replicate(num_iter, new_tree())) # Build lots of variants
   }

# Build adjacency matrix and modify this
k_data=dcast(l_info, value ~ language, length)
k_data$value=NULL # remove value column
k_adj=as.matrix(k_data) # convert to adjacency matrix

num_langs=ncol(k_adj)
num_traits=nrow(k_adj)

t=sapply(1:num_langs, boot_trait) # iterate over all languages
return(t)
}

# Plot tree with bootstrapped percentages
phylo_boot_plot=function(l_info, info_str="")
{
k_data=dcast(l_info, value ~ language, length)
k_data$value=NULL
k_adj=t(as.matrix(k_data))

tree=nj(dist(k_adj))

## the 'genetric' specific bootstrap function
# bstrees=boot.phylo(tree, k_adj, fun, B=1000, trees = TRUE)$trees

bstrees=boot_lang(l_info)
## get proportions of each clade:
clad=prop.clades(tree, bstrees, rooted = FALSE)
## get proportions of each bipartition:
# boot=prop.part(tree, bstrees)

plot(tree, cex=1.3, tip.color=pal_col[1], edge.color=pal_col[2], main=info_str)
# drawSupportOnEdges(boot)
nodelabels(trunc(100*clad/(nrow(k_adj)*100)), frame="none") # Display percentage

return(dist(k_adj))
}


linf=read.csv("lang-info/lang.csv", as.is=TRUE)


par(mar=c(1, 1, 1, 1))

lkey=subset(linf, trait == "keyword")
lbinop=subset(linf, trait == "binary-operator")
lbinprec=subset(linf, trait == "binary-precedence")
lfundef=subset(linf, trait == "function-definition")

# Check for suspicious counts
# sort(table(lbinop$value))
# Check for duplicates
# t=ddply(lkey, .(language), function(df) count(df$value))
# t[which(t$freq > 1), ]
# t=ddply(lbinop, .(language), function(df) count(df$value))
# t[which(t$freq > 1), ]
# t=ddply(lfundef, .(language), function(df) count(df$value))
# t[which(t$freq > 1), ]

par(mfcol=c(1, 3))

key_dist=phylo_plot(lkey)

binop_dist=phylo_plot(lbinop)

key_dist=phylo_boot_plot(lkey, "Keywords")
binop_dist=phylo_boot_plot(lbinop, "Binary operators")

bprec_dist=phylo_boot_plot(lbinprec, "Binary precedence")

# Combine multiple distance matrices
# Range of distance values will depend on the number of attributes.
# Normalise by dividing by distance mean.
comb_dist=as.matrix(binop_dist)/mean(binop_dist)+0.2*as.matrix(bprec_dist/mean(bprec_dist))
comb_phy=nj(comb_dist)
plot(comb_phy, cex=1.3, tip.color=pal_col[1], edge.color=pal_col[2],
				main="Binary operators+precedence")

bprec_dist=phylo_plot(lbinop)
func_dist=phylo_plot(lfundef)

# Extract language information based on keywords shared with C
c_keywords=subset(lkey, language=="c90")$value
c_like=subset(lkey, value %in% c_keywords)

clike_dist=phylo_plot(c_like, "C-likeness (keywords)")

