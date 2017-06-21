* usecda- version 1.2

capture 	program drop usecda
program 	define usecda
args 		data 
use			http://shawnasmith.net/data/`data'.dta, clear
end
