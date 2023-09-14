songs=read.csv('analysisData.csv')

songs=songs[!is.na(songs$genre),]

ngroup=c()

for (i in 1:nrow(songs)) {
  group=songs$genre[i]
  a=substring(group,3,(nchar(group)-2))
  b=strsplit(gsub('[, ]', '', a),split = "''")[[1]]
  ngroup=c(ngroup,length(b))
}

newsongs=cbind(songs,ngroup)

library(stringr)
val=c()
for (i in 1:nrow(songs)) {
  group=songs$genre[i]
  a=substring(group,3,(nchar(group)-2))
  b=strsplit(gsub('[, ]', '', a),split = "''")[[1]] 
  val=c(val,b)
  
}

index=duplicated(val)
single=val[!index]

newsongs[,(ncol(newsongs)+1):(ncol(newsongs)+length(single))]=0

colnames(newsongs)[21:(20+995)]=single

for (i in 1:nrow(newsongs)) {
  group=newsongs$genre[i]
  a=substring(group,3,(nchar(group)-2))
  b=strsplit(gsub('[, ]', '', a),split = "''")[[1]] 
  if(length(b)>0){ for (j in 1:length(b)) {
    newsongs[i,b[j]]=1
  }}
}

d=apply(newsongs[,21:(20+995)],2,sum)

dd=as.matrix(d)

newsongs=cbind(newsongs[,1:20],newsongs[,rownames(dd)[d>200]]) 

sort(d)

#############

summary(songs$track_duration/(1000*60))

library(dplyr)

milliseconds.per.minutes<-1000*60

newsongs<-newsongs%>% 
  mutate(track_minutes=track_duration/(milliseconds.per.minutes))

#newsongs$rating[newsongs$rating<0]=0

#newsongs=newsongs[-c(which(newsongs$rating<10)),]

newsongs$time_sig_cat=ifelse(newsongs$time_signature %in% c(0,1,5),"Four","Other")

w<-grep(pattern="The", x=newsongs$performer)

newsongs$performerTHE=0
newsongs[w,"performerTHE"]=1

newsongs=newsongs[,-c(1:4)]

RMSE=function(t,p){
  return(sqrt(mean((t-p)^2)))
}

model=lm(newsongs$rating~.,newsongs)

summary(model)

library(MASS)
model=stepAIC(model)
summary(model)

library (car)
vif(model,type = 'predictor')

colnames(newsongs)[colnames(newsongs)=="r&b"]="r_b"
colnames(newsongs)[colnames(newsongs)=="singer-songwriter"]="singer_songwriter"
colnames(newsongs)[colnames(newsongs)=="post-disco"]="post_disco"
colnames(newsongs)[colnames(newsongs)=="post-grunge"]="post_grunge"

summary(newsongs$rating)

more=which(newsongs$rating<50&newsongs$rating>24)

less=sample(more,length(more)*0.8)

newsongs=newsongs[-less,]

num_trees=100

library(ranger)

min_mtry=0
min_pred=0

for (i in 1:61) {
  
  model=ranger(formula = newsongs$rating ~ track_duration + track_explicit + 
               danceability + energy + loudness + acousticness + instrumentalness + 
               liveness + valence + tempo + time_signature + adultstandards + 
               dancepop + pop + countryrock + softrock + quietstorm + r_b + 
               soul + contemporarycountry + country + countryroad + folk + 
               singer_songwriter + canadianpop + newwave + synthpop + 
               classicukpop + nashvillesound + post_disco + rhythmandblues + 
               bluesrock + psychedelicrock + rock + chicagosoul + southernsoul + 
               permanentwave + rap + southernhiphop + phillysoul + britishinvasion + 
               deepadultstandards + vocaljazz + post_grunge + countrydawn + 
               merseybeat + hollywood + alternativerock + modernrock + poprock + 
               boyband + soulblues + glammetal + europop + glamrock + trap + 
               neomellow + melodicrap + dirtysouthrap + hardcorehiphop + 
               performerTHE, mtry =i, 
             data = newsongs, num.trees=num_trees, splitrule='extratrees')
  
  pred=predict(model, data=newsongs, num.trees = num_trees)
  
  if(model$r.squared>min_pred){
    min_pred=model$r.squared
    min_mtry=i
  }
  
}

model=ranger(formula = newsongs$rating ~ track_duration + track_explicit + 
               danceability + energy + loudness + acousticness + instrumentalness + 
               liveness + valence + tempo + time_signature + adultstandards + 
               dancepop + pop + countryrock + softrock + quietstorm + r_b + 
               soul + contemporarycountry + country + countryroad + folk + 
               singer_songwriter + canadianpop + newwave + synthpop + 
               classicukpop + nashvillesound + post_disco + rhythmandblues + 
               bluesrock + psychedelicrock + rock + chicagosoul + southernsoul + 
               permanentwave + rap + southernhiphop + phillysoul + britishinvasion + 
               deepadultstandards + vocaljazz + post_grunge + countrydawn + 
               merseybeat + hollywood + alternativerock + modernrock + poprock + 
               boyband + soulblues + glammetal + europop + glamrock + trap + 
               neomellow + melodicrap + dirtysouthrap + hardcorehiphop + 
               performerTHE, mtry =min_mtry, 
             data = newsongs, num.trees=num_trees, splitrule='extratrees')

pred=predict(model, data=newsongs, num.trees = num_trees)

RMSE(newsongs$rating,pred$predictions)

#############Predict

scoringData = read.csv('scoringData.csv')

ngroup=c()
for (i in 1:nrow(scoringData)) {
  group=scoringData$genre[i]
  a=substring(group,3,(nchar(group)-2))
  b=strsplit(gsub('[, ]', '', a),split = "''")[[1]] 
  ngroup=c(ngroup,length(b))
}

newscoringData=cbind(scoringData,ngroup)

newscoringData[,(ncol(newscoringData)+1):(ncol(newscoringData)+length(single))]=0

colnames(newscoringData)[20:1014]=single

newscoringData<-newscoringData%>% 
  mutate(track_minutes=track_duration/(milliseconds.per.minutes))

newscoringData$time_sig_cat=ifelse(newscoringData$time_signature %in% c(0,1,5),"Four","Other")

w<-grep(pattern="The", x=newscoringData$performer)

newscoringData$performerTHE=0
newscoringData[w,"performerTHE"]=1

colnames(newscoringData)[colnames(newscoringData)=="r&b"]="r_b"
colnames(newscoringData)[colnames(newscoringData)=="singer-songwriter"]="singer_songwriter"
colnames(newscoringData)[colnames(newscoringData)=="post-disco"]="post_disco"
colnames(newscoringData)[colnames(newscoringData)=="post-grunge"]="post_grunge"

pred =round( predict(model, data=newscoringData, num.trees = num_trees)$predictions,2)

submissionFile = data.frame(id = scoringData$id, rating = pred)
submissionFile$rating[submissionFile$rating<0]=0

write.csv(submissionFile, 'sample_submission.csv',row.names = F)
