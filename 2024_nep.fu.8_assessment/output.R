#set working data year and Nephrops database
survey.year<- 2024
catch.year<- 2023

#working directories
mkdir("output")
outdir<- "output/"
datadir<- "data/"
modeldir<- "model/"

#Clear files from outdir directories
unlink(list.files(outdir, full.names = T, recursive = T))

file.copy(paste0(datadir,"nephup.ff.",catch.year,".rdata"), outdir, overwrite=T)
file.copy(paste0(datadir, c("international.landings.csv","firth forth_TV_results_bias_corrected.csv","Mean weights in landings.csv")), outdir, overwrite=T)
file.copy(paste0(modeldir, c("firth forth_Exploitation summary.csv")), outdir, overwrite=T)
plots.advice(wk.dir = outdir,
             f.u="firth forth", MSY.hr = HR["Fmsy"],stock.object=nephup.ff,
             international.landings = "international.landings.csv",
             tv_results = "firth forth_TV_results_bias_corrected.csv",
             Exploitation_summary = "firth forth_Exploitation summary.csv")

