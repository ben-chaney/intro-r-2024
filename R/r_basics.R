#### R Basics ####
# "A foolish consistency is the hobgoblin of 
#   little minds"   -Ralph Waldo Emerson 

# Literals ----
"This is a string literal" # this is a comment.  A bit of a footnote with plot.
'This is also a string literal' # double quotes are preferred in R but not required.
T
F
TRUE
FALSE



# Starting with a comment
# And we continued
# 

# Operators ----
## Arithmitic 
2 + 3 # look at my fancy calculator. Note the spaces around the operator, it's just legibility.
5 * 23 # note that multiplication is not an "x"

2 ** 3 # note this is a power
2 ^ 3 # okay that's more standard for power

## Comparison
# Let's learn some logic... it's kinda different from other languages

2 == 2 # equality test is double equals.  Not if they're identical.
"Ben" == "ben" # R is case sensitive
2 == 1 + 1 # Standard order of operations evaluates each side of the test first.
2 == (1 + 1) # better for clarity
2 != 1 # ! is "not" for most contexts.  not equal to, here.

## Truth
TRUE == 1 # 1 is interpreted as true when evaluated with a truth comparison. 0 as false
isTRUE(TRUE) # This is True
isTRUE(1) # This is not true.

2 < 3 & 1 < 2 # note that the "and" logical operator is an ampersand, not the word "and"
# That's different from Python.

TRUE | FALSE # this is an "or" statement.

## Types
"Ben" # this is a string, or character type.
typeof("Ben")
typeof(42)
typeof(42.)
typeof(TRUE)

42 == "42" # This is true.  Equality can cross types where unambigious. But don't count on it.

identical(42, "42") # type matters for identical()  function

# variables ----
a <- "wow i'm a variable" # assignment operator is a legacy from S
typeof(a) # this returns the type of the assigned value.

# data structures ----
# vectors have a single dimension, like a column or row of data

a <- c(1,2,3) # c() stands for "collect" what's inside. 
a + 1 # many basic functions are "vectorized" so they apply to every element of a vector
b <- c(1, 2, 3, "4") # R will auto-type to a type that makes everything work if possible.
# R is not strictly typed (statically typed) so you have to keep your eyes on it.

a < 3 # some functions evaluate element-wise and return a vector.

any(a < 3) # evaluates the vector. tests whether any comparison is true.
all(a < 3) # evaluates the vector too. tests if all comparisons are true.

3 %in% a # special operator to test membership. Like in SQL
!(3 %in% a) # not operator is a bit odd in here.



# data frames - the key structure for data science, multi-dimensional
#   collections of vectors

df <- data.frame(a = c(1, 2, 3),
                 b = c("joe", "tammy", "matt")) # collection of vectors. place in vector is linking them together


df # the whole data frame
df$a # a specific vector (column) in the data frame

df$mode <- c("bike", "max", "unicycle") # adding a column

summary(df) # summarizes y column including type, length, num stats if applicable

# Special type: factors, and putting it all together ----
# factors are categorical variables with a fixed set of
#   potential values


