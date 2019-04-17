####  DCP 1 ####

#Given a list of numbers and a number k, return whether any two numbers from the list add up to k.

vector <- c(10,15,3,7)
k <- 17

my_func <- function(vector,k) {

seq <- length(vector)-1

for (i in 1:seq) {
  j = i+1
  for (j  in j:length(vector)) {
    if (vector[i]+vector[j] == k) {
      print(paste("TRUE", vector[i], "+", vector[j]))
    }
  } 
}
  }

vector2 <- c(10,3,2,8,9,13)

my_func(vector2, 5)


