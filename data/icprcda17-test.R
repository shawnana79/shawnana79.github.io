### test
  usecda <- function(x){
  data <- data.frame(read.dta(deparse(substitute(x))))
  return(data)
}
