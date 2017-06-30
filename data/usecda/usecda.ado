* usecda- version 1.3

capture 	program drop usecda
program 	define usecda
  args 		  file 
    // check for lecture do file
	  if substr("`file'",length("`file'")-2,3) == "lec" {
    di "Running lecture do file" 
	  do "https://shawnana79.github.io/data/`file'.do"
	  } 
	  // check for lab do file 
  	else if substr("`file'",length("`file'")-2,3) == "lab" {
    di "Running lab do file" 
	  do "https://shawnana79.github.io/data/`file'.do"
	  } 
	  // Otherwise, open dataset 
    else {
    di "Opening as dataset" 
	  use "https://shawnana79.github.io/data/`file'.dta", clear
    }
end

