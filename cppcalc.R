# pension calc
# http://retirehappy.ca/how-to-calculate-your-cpp-retirement-pension/
birthmonth=09;birthyear=1954
# my numbers based on 7000 a year for last years estimated then 2000 - basic exemption is $ 3500
upe=c(245,0,6600,3599,0,4369,8034,5902,6177,0,5000,10714,13600,23400,25800,25900,25123,15157,28900,30500,32200,33400,34400,34900,35400,0,36900,37400,37600,38300,39100,39900,40500,41100,42100,41904,44900,29666,34018,25016,14010,7000,7000,7000,2000,2000,2000,2000,2000)
# http://www.drpensions.ca/cpp-rate-table.html 1966-2015
ympe=c(5000,5000,5100,5200,5300,5400,5500,5600,6600,7400,8300,9300,10400,11700,13100,14700,16500,18500,20800,23400,25800,25900,26500,27700,28900,30500,32200,33400,34400,34900,35400,35800,36900,37400,37600,38300,39100,39900,40500,41100,42100,43700,44900,46300,47200,48300,50100,51100,52200,53600,54672,55765,56880,58018,59178)
# above has been added to by 2 % for the next 5 years actual calc is http://www.servicecanada.gc.ca/eng/services/pensions/cpp/payments/cppcpi.shtml
# could be modified to 5 year average or moving 2/3 year average
retiremonth=birthmonth
retirestart=birthyear+60
mb=NULL;ryr=NULL # variables to be used in calculation of life time payments
# start of benefit calculation loop
for (j in 1:6)     
{
retireyear=retirestart+j-1 # for this iteration of the loop assume start collecting pension in this year
ncm=(retireyear-birthyear-18)*12+retiremonth-birthmonth # number contributing months starts when you're 18
years=((birthyear+18):retireyear)
a=data.frame(years,12,upe[1:(retireyear-birthyear-17)],ympe[(birthyear+18-1965):(length(years)+6)])
# divide upe by ympe add to dataframe
a$div=a$upe/a$ympe
# create multiplier last 5 years that pension starts 
lastfive=sum(a$ympe[(length(years)-4):length(years)])/5
a$adjcurr=a$div*lastfive
colnames(a)=c("year","eligmonths","upe","ympe","div","adjcurr")
a[1,"eligmonths"]=12-birthmonth;a[length(years),"eligmonths"]=birthmonth
# calculate total adjusted pensionable earnings
tape1=sum(a$adj)
# average monthly pensionable earnings amount
m=tape1/ncm
# general dropout 17 % of APE as of 2014
gd=round(.17*ncm)
# remember to look at child years for kids if spouse doesn't file
# any months dropped must be subtracted from ncm
gd2=gd # once child calc is in make this gd1
ncm2=ncm
# take general drop out off, first reorder df by adjusted pensionable earnings
a=a[order(a$adjcurr),] 
dropmonths=sum(a$eligmonths) # to figure out how many months dropped
for (i in 1:gd2)
   {if (a[ceiling(i/12),"adjcurr"]/12<m)
       a[ceiling(i/12),"eligmonths"]=a[ceiling(i/12),"eligmonths"]-1}
a=a[order(a$year),] # put it back in year order
dropmonths=dropmonths-sum(a$eligmonths)
ncme=ncm2-dropmonths # remove dropmonths for next step of calc
m=sum(a$adjcurr*a$eligmonths/12)/ncme
# now mulitply by 25 % 
m=m*.25
#http://retirehappy.ca/how-to-get-your-cpp-early/
early=(birthyear+65-retireyear)*12-(birthmonth-retiremonth)
# reduction for each month early .58 % x months before 65th - goes to .6 2016
r=.58*early
if (retireyear>=2016) r=.6*early
m=m-m*r/100;m=round(m,2)
mb[j]=m;ryr[j]=retireyear
}
# end of benefit calculation loop
# the beginning of the messy stuff - sorry
z=data.frame(ryr,mb,mb*12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
for (i in 1:6)
{
     for (j in 5:26)
     if (j>i+4)
     z[i,j]=z[i,j-1]+z[i,3]
}
c=c("year","monthly","annual","")
for (i in 5:ncol(z))
     c=c(c,(as.character(retirestart+i-5)))
colnames(z)=c
write.csv(z,"cppbreakeven.csv")
# to do
# what happens when you go over 65 - reverse early calc, then when you pass 70
# to make it work for people born before 1948 must put in hard 1966
# add more ympe figures - it stops at 2020 now - do it at a % based on the last one
# disability months

