* usecda- version 1.2

capture 	program drop usecda
program 	define usecda
args 		data 
use			https://shawnana79.github.io/data/`data'.dta, clear
end
