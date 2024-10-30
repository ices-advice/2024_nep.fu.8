#set working data year and Nephrops database
survey.year<- 2024
catch.year<- 2023

#working directories
mkdir("model")
modeldir<- "model/"
datadir<- "data/"

#Clear files from modeldir directories
unlink(list.files(modeldir, full.names = T, recursive = T))

#Latest advice given (in tonnes)
latest.advice<- c(3129,3129) #3129 catch tonnes advice given in 2023 for 2024.

#FORECAST
########################################################################################
##Forecast for next year using the lastest survey point
survey<- paste(datadir, "firth forth", "_TV_results.csv", sep="")
international<- paste0(datadir, "international.landings.csv")

# Creates an exploitation table for the years in the survey file which can be 1 year more than in the
# landings and stock object (for an autumn advice)
#exploitation.table.2014(wk.dir = paste(Wkdir, "fishstats", sep=""), f.u = "fladen", stock.object=nephup.fl, international.landings = international, survey=survey)
exploitation.table(wk.dir = modeldir, f.u = "firth forth", stock.object=nephup.ff, international.landings = international, survey=survey)

data.yr<- catch.year
av.yrs<- (data.yr-2):data.yr  #last 3 years
exp.tab.ff<- read.csv(paste0(modeldir, "firth forth_Exploitation summary.csv"))

#Flower added to list of HRs (EU request to provide Fmsy ranges for selected North Sea and Baltic Sea stocks)
HR<- list(
  Flower=10.6,
  Fmsy = 16.3,
  F0.1 = 9.4,
  F35SpR = 12.7,
  Fyear = exp.tab.ff[exp.tab.ff$year==data.yr,"harvest.ratio"],
  Fav.yrs = round(mean(exp.tab.ff[exp.tab.ff$year %in% av.yrs,"harvest.ratio"]), 1)
)
HR<- sapply(HR, as.vector)
#Flow<- 10.6
#extra.options<- unique(c(seq(floor(min(HR)), ceiling(max(HR)), by=1), seq(Flow, HR[names(HR)=="Fmsy"], by=0.1))); extra.options<- extra.options[!extra.options %in% HR]
#HR<- c(HR, extra.options)
HR<- c(HR[names(HR) %in% "Fmsy"],sort(HR[!names(HR) %in% "Fmsy"]))
names(HR)[which(names(HR) %in% "Fyear")]<- paste0("F",data.yr)
names(HR)[which(names(HR) %in% "Fav.yrs")]<- paste0("F",av.yrs[1],"_",av.yrs[3])

#Forecast table as required by WGNSSK 2017
file.copy(paste0(datadir, c("Mean_weights.csv")), modeldir, overwrite=T)
forecast.table.WGNSSK(wk.dir = modeldir,
                      fu="FU8",hist.sum.table = "firth forth_Exploitation summary.csv",
                      mean.wts="Mean_weights.csv",
                      land.wt.yrs=av.yrs, disc.wt.yrs=av.yrs, disc.rt.yrs=av.yrs, 
                      h.rates=HR, d.surv =25, latest.advice=latest.advice)
