#set working data year and Nephrops database
survey.year<- 2024
catch.year<- 2023

#working directories
mkdir("report")
reportdir<- "report/"
outdir<- "output/"

#Clear files from outdir directories
unlink(list.files(reportdir, full.names = T, recursive = T))

#load stock object
load(paste0(outdir,"nephup.ff.",catch.year,".rdata"))

##############################################################################################

#Calculate mean sizes and create time series plot
mean.length <-mean.sizes(nephup.ff)
plot.mean.sizes(reportdir,nephup.ff,mean.length)

##following script produces mean size trends male/female  as per Ewen
#  set up df for LF plot - the tables which are output are incorrect - uses 
# lower bound to calculate mean length
tmp <-FLCore::trim(nephup.ff,year=2000:catch.year)
disc <-as.data.frame(seasonSums(tmp@discards.n))
catch <-as.data.frame(seasonSums(tmp@catch.n))
land <-as.data.frame(seasonSums(tmp@landings.n))

#Year, Sex, Length, Landings, Discards, Catch
LF.data.frame <-data.frame(Year=disc$year,Sex=disc$unit,
                           Length=disc$lengths,Landings=land$data,Discards=disc$data,
                           Catch=catch$data)
png(paste0(reportdir, "LFD_FF.png"),width = 800, height = 1000)
plot.ld(LF.data.frame,"FU 8",range(tmp,'minyear'),range(tmp,'maxyear'),25,35)
dev.off()

# Could use this instead 
catch.ldist.plot(flneph.object = nephup.ff, years=c(2000,catch.year), extra.space=3)
length.freq.dist(neph.object = nephup.ff, av.years = c(catch.year))

#WGNSSK agreed LF plot for advice sheets
#prepare data frame format
CatchLDsYr<- LF.data.frame
CatchLDsYr$Discards<- NULL #remove discard column as not needed
names(CatchLDsYr)<- c("Year","Sex","Length","LandNaL","CatchNaL") # rename fields
CatchLDsYr$Sex<- substr(CatchLDsYr$Sex,1,1)# Take the first letter (either M or F) from Sex ("Male" and "Female") for NEP_LD_plot_ICES function
#Run new function. Output goes to reportdir
NEP_LD_plot_ICES(df=CatchLDsYr, FU="8", FUMCRS=25, RefLth=35, out.dir=reportdir)

#Plot landings and quartery landings
nephup.quarterly.plots(reportdir,tmp, nephort.ff$days)

#Sex ratio plot
sex.ratio.plot(wdir=reportdir, stock.obj=nephup.ff, print.output=F, type="year")
sex.ratio.plot(wdir=reportdir, stock.obj=tmp, print.output=F, type="quarter")

#Landings long term plot
nephup.long.term.plots_kw_effort_aggregated(outdir,stock=nephup.ff,effort.data.days=nephort.ff$days, effort.data.kwdays=nephort.ff$kwdays,
                                            international=T,international.landings="international.landings.csv", output.dir=reportdir)
