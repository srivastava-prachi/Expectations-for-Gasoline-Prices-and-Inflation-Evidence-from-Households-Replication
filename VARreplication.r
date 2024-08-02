################################################
##VAR Table
################################################

rm(list = ls())
library("readxl")

#load data
alldata <- read_excel("VARreplicationdata.xlsx", guess_max = 10000000)


library(tseries)
library(dlm)
library(dynlm)
library(vars)
library(tsDyn)
########UMICH



alldata$year=as.numeric(substr(alldata$observation_date, 1,4))
alldata$month=as.numeric(substr(alldata$observation_date, 6,7))
alldata$ym=alldata$year*100+alldata$month
alldata$ymts=alldata$year*12+alldata$month


#*****sample*****
finoutput=matrix(NA, 15,5)
for (j in 1:5) {
  
if (j==1) {
  sampledata=subset(alldata, subset = (alldata$year>2012 & alldata$year<2023))
}
  if (j==2) {
    sampledata=subset(alldata, subset = (alldata$year>1981 & alldata$year<1993))
  }
  if (j==3) {
    sampledata=subset(alldata, subset = (alldata$year>2004 & alldata$year<2014))
  }
  if (j==4) {
    sampledata=subset(alldata, subset = (alldata$year>2004 & alldata$year<2023))
  }
  if (j==5) {
    sampledata=subset(alldata, subset = (alldata$year>1981 & alldata$year<2023))
  }
  
  
  
#************* OLS
lmsimple=lm(sampledata$CPI~sampledata$`Gasoline (Motor Fuel)`)
abc=summary(lmsimple)


#************* VAR1

vardata=data.frame(sampledata$`Gasoline (Motor Fuel)`,sampledata$CPIexGas)

VARselect(vardata)


linvarest=lineVar(vardata,lag=1)

Bmatrix1=linvarest$coefficients

set.seed(50)
resamplesize=1000
resimall=matrix(0,resamplesize,1)
for (i in 1:resamplesize) {
  matchingsamp=sample(nrow(linvarest$residuals), nrow(linvarest$residuals), replace=T)
  randshock=linvarest$residuals[matchingsamp, ]
  weightsamp=sampledata$`Weight of Motorfuel`[2:nrow(sampledata)]
  weightCPI=weightsamp
  resamp=VAR.sim(Bmatrix1, n=length(linvarest$residuals)/2, lag=1, include = "const", innov = randshock)
  resamp[,2]=resamp[,2]*(1-weightCPI/100)+resamp[,1]*weightCPI/100
  resimall[i,1]=cov(resamp)[1,2]/var(resamp[,1])
}


####VAR2

vardata=data.frame(sampledata$`Gasoline (Motor Fuel)`,sampledata$CPIexGas)

linvarest=lineVar(vardata,lag=2)

Bmatrix1=linvarest$coefficients

set.seed(50)
resamplesize=1000
resimall2=matrix(0,resamplesize,1)
for (i in 1:resamplesize) {
  matchingsamp=sample(nrow(linvarest$residuals), nrow(linvarest$residuals), replace=T)
  randshock=linvarest$residuals[matchingsamp, ]
  weightsamp=sampledata$`Weight of Motorfuel`[3:nrow(sampledata)]
  weightCPI=weightsamp
  resamp=VAR.sim(Bmatrix1, n=length(linvarest$residuals)/2, lag=2, include = "const", innov = randshock)
  resamp[,2]=resamp[,2]*(1-weightCPI/100)+resamp[,1]*weightCPI/100
  resimall2[i,1]=cov(resamp)[1,2]/var(resamp[,1])
}

####VAR3

vardata=data.frame(sampledata$`Gasoline (Motor Fuel)`,sampledata$CPIexGas)

linvarest=lineVar(vardata,lag=3)

Bmatrix1=linvarest$coefficients

set.seed(50)
resamplesize=1000
resimall3=matrix(0,resamplesize,1)
for (i in 1:resamplesize) {
  matchingsamp=sample(nrow(linvarest$residuals), nrow(linvarest$residuals), replace=T)
  randshock=linvarest$residuals[matchingsamp, ]
  weightsamp=sampledata$`Weight of Motorfuel`[4:nrow(sampledata)]
  weightCPI=weightsamp
  resamp=VAR.sim(Bmatrix1, n=length(linvarest$residuals)/2, lag=3, include = "const", innov = randshock)
  resamp[,2]=resamp[,2]*(1-weightCPI/100)+resamp[,1]*weightCPI/100
  resimall3[i,1]=cov(resamp)[1,2]/var(resamp[,1])
}

####VAR12

vardata=data.frame(sampledata$`Gasoline (Motor Fuel)`,sampledata$CPIexGas)

linvarest=lineVar(vardata,lag=12)

Bmatrix1=linvarest$coefficients

set.seed(50)
resamplesize=1000
resimall12=matrix(0,resamplesize,1)
for (i in 1:resamplesize) {
  matchingsamp=sample(nrow(linvarest$residuals), nrow(linvarest$residuals), replace=T)
  randshock=linvarest$residuals[matchingsamp, ]
  weightsamp=sampledata$`Weight of Motorfuel`[13:nrow(sampledata)]
  weightCPI=weightsamp
  resamp=VAR.sim(Bmatrix1, n=length(linvarest$residuals)/2, lag=12, include = "const", innov = randshock)
  resamp[,2]=resamp[,2]*(1-weightCPI/100)+resamp[,1]*weightCPI/100
  resimall12[i,1]=cov(resamp)[1,2]/var(resamp[,1])
}

finoutput[1,j]=lmsimple$coefficients[2]-1.285*abc$coefficients[2,2]
finoutput[2,j]=lmsimple$coefficients[2]
finoutput[3,j]=lmsimple$coefficients[2]+1.285*abc$coefficients[2,2]

finoutput[4,j]=quantile(resimall,.1)
finoutput[5,j]=quantile(resimall,.5)
finoutput[6,j]=quantile(resimall,.9)

finoutput[7,j]=quantile(resimall2,.1)
finoutput[8,j]=quantile(resimall2,.5)
finoutput[9,j]=quantile(resimall2,.9)

finoutput[10,j]=quantile(resimall3,.1)
finoutput[11,j]=quantile(resimall3,.5)
finoutput[12,j]=quantile(resimall3,.9)

finoutput[13,j]=quantile(resimall12,.1)
finoutput[14,j]=quantile(resimall12,.5)
finoutput[15,j]=quantile(resimall12,.9)


}

#Save output table
write.csv(finoutput,"VARreplication.csv")


