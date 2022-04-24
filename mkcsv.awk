#
# mkcsv.awk, 24 Apr 22

BEGIN {
	trait["wikipedia"]=1
	trait["keyword"]=1
	trait["comment"]=1
	trait["white-space"]=1
	trait["identifier"]=1
	trait["literal"]=1
	trait["control-flow"]=1
	trait["expression"]=1
	trait["ternary-operator"]=1
	trait["binary-operator"]=1
	trait["unary-operator"]=1
	trait["function-definition"]=1
	trait["statement"]=1
	trait["declaration"]=1
	trait["comment"]=1

	in_trait=""
	in_operator=0
	# print "language,trait,value"
	}

NF == 0 { # a blank line
	next
	}

$1 == "#" { # a comment line
	next
	}

trait[$1] == 1 {
	in_trait=$1
	in_operator=((trait["ternary-operator"]==1) ||
			(trait["binary-operator"]==1) ||
			(trait["unary-operator"]==1))
	prec_str=$1
	sub("operator", "precedence", prec_str)
	next
	}

	{
	print lang "," in_trait "," $1
	if (in_operator && ($2 != "") && ($2 != "#"))
	   print lang "," prec_str "," $2
	next
	}

