rm(list=ls())

#### DATA FROM NIH SEER
#### https://seer.cancer.gov/popdata/download.html

.libPaths( c( .libPaths(), "U:/R") )

library(readr)
library(dplyr)
library(lme4)
library(texreg)
library(tidyr)
library(data.table)
library(ggplot2)
library(foreign)
set.seed(1)

setwd("R:/Project/NCANDS/ncands-csv/")

seer<-read_fwf(file="us.1990_2015.19ages.txt", 
        fwf_widths(c(4,2,2,3,2,1,1,1,2,8)),
        col_types="icccciiiii")
names(seer)<-c("year", "state", "state.fips",
                     "cnty.fips", "registry", 
                     "race", "latino", "sex",
                     "age", "pop")

seer$FIPS<-paste(seer$state.fips, seer$cnty.fips, sep="")

tot.pop<-seer%>%group_by(FIPS, year)%>%
  summarise(tot.pop=sum(pop),
            child.pop=sum(pop[age<5]),
            adult.pop=sum(pop[age>4]),
            wht.pop=sum(pop[race==1]),
            wht.child.pop=sum(pop[(race==1)&(age<5)]),
            wht.adult.pop=sum(pop[(race==1)&(age>4)]),
            blk.pop=sum(pop[race==2]),
            blk.child.pop=sum(pop[(race==2)&(age<5)]),
            blk.adult.pop=sum(pop[(race==2)&(age>4)]),
            ai.pop=sum(pop[race==3]),
            ai.child.pop=sum(pop[(race==3)&(age<5)]),
            ai.adult.pop=sum(pop[(race==3)&(age>4)]),
            aa.pop=sum(pop[race==4]),
            aa.child.pop=sum(pop[(race==4)&(age<5)]),
            aa.adult.pop=sum(pop[(race==4)&(age>4)]),
            lat.pop=sum(pop[latino==1]),
            lat.child.pop=sum(pop[(latino==1)&(age<5)]),
            lat.adult.pop=sum(pop[(latino==1)&(age>4)])
            )

write.csv(tot.pop, file="seer-pop.csv", row.names=FALSE)