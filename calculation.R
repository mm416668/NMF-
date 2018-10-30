
#load data in R environment

a=read.csv("/Users/yangmeng/Desktop/small/links.csv")
b= read.csv("/Users/yangmeng/Desktop/small/movies.csv")
c=read.csv("/Users/yangmeng/Desktop/small/ratings.csv")
d = read.csv("/Users/yangmeng/Desktop/small/tags.csv")
e = read.csv("/Users/yangmeng/Desktop/small/maintable.csv")

#general review of each dataset


head(a)
head(b)
head(c)
head(d)

#clean each dataset check there is a missing value

a1<-na.omit(a)
b1<-na.omit(b)
c1<-na.omit(c)
d1<-na.omit(d)
View(a1)
View(b1)
View(c1)
View(d1)

# calculation:data qualification is high, only a has missing value and the precentage is low (9125-9112)/9125
# the missing value can be removed

# Using SQL pakages

install.packages("sqldf")
library(sqldf)

# how many movies are rated --9066

c2=sqldf("select DISTINCT movieid ,Avg(rating) as rate
          from c1 
          group by movieid
          order by rate DESC
          
         ")

c3<-sqldf("select * from c2 inner join d1 on c2.movieId = d1.movieId")
top_movie100<-sqldf("select * from c3 limit 100")
top_movie200<-sqldf("select * from c3 limit 200")
top_movie300<-sqldf("select * from c3 limit 300")


# user behaviour

d2=sqldf("select userId, Sum(userId) as sum
          from d1
          group by userId
          order by sum DESC
         ")

top_customer10<-sqldf("select * from d2 limit 10")
top20<-sqldf("select * from d2 limit 20")

top20matrix<-sqldf("select top20.userId, movieId, rating from top20 left join matrix1 on top20.userId=matrix1.userId")


# time series

time<-sqldf("select Max(timestamp) as max ,Min(timestamp) as min from d1")
timetotal=(time$max-time$min)/(3600*24*30*12)
timetotal

#convert Convert epoch to human readable date and vice versa



install.packages("anytime")
library(anytime)


movieyear<-year(anytime(d1$timestamp))
moviemonth<-month(anytime(d1$timestamp))
timeanalysis2<-data.frame(d1,moviemonth)
timeanalysis<-data.frame(d1,movieyear)
timeanalysisbyyear<-sqldf("select movieyear,COUNT(movieyear) as count from timeanalysis group by movieyear")
timeanalysisbymonth<-sqldf("select moviemonth,COUNT(moviemonth) as count from timeanalysis2 group by moviemonth")



install.packages("ggplot2")

acf(timeanalysisbymonth)

plot(timeanalysisbyyear)
plot(timeanalysisbymonth)

cor(c$rating,c$timestamp)



# the totallength for sample dataset is almost 11 years

?ts

ts1<-ts(d1$timestamp,frequency = 12,start = 1)
plot(ts1)


install.packages("RWeka")
library(RWeka)

install.packages("rTensor")
library(rTensor)

modee1<-as.tensor(top_movie100,drop = FALSE)


# build tow-dememsion matrix for user and movie

matrix1<-c1[,1:3]
install.packages("rpivotTable")

library(rpivotTable)

matrix2<-rpivotTable(matrix1,rows="userId",cols = "movieId",vals = "rating")
matrix2

install.packages("reshape2")

library(reshape2)

matrix3<-dcast(matrix1,userId~movieId,fill = 0)

matrix4<-dcast(top20matrix,userId~movieId, fill=0)

#head(matrix3)
#structure(matrix3)

write.csv(matrix3,file="/Users/yangmeng/Desktop/small/maintable.csv")

?write.csv

#the file is too big 

#so need to cut the table


?sample

library(data.table)
 
install.packages("data.table")
library(data.table)
set.seed(10)


#iris[sample(nrow(iris), 2), ]

test1<-e[sample(nrow(e),nrow(e)*0.1),]
test2<-test1[,sample(ncol(test1),ncol(e)*0.005)]



user_movie<-read.csv("/Users/yangmeng/Desktop/small/maintable.csv")


user_tag<-sqldf("select * from c1 inner join b1 on c1.movieId = b1.movieId")

user_tag<-user_tag[,c(1,3,7)]

write.csv(user_tag,"/Users/yangmeng/Desktop/small/user_tag.csv")

# Cut top 10% customer, most active or movie fun

user_tag_test1<-sqldf("select userId, COUNT(userId) as c from user_tag group by userId order by c DESC LIMIT 67")


# Get the tag of the top 10% customer to analyze the tag

user_tag_test2<-sqldf("select * from user_tag INNER JOIN user_tag_test on user_tag.userId = user_tag_test.userId order by c DESC")


# use the user with highest amount of movie

user_tag_547<-user_tag_test2[1:2391,]

plot(user_tag_547$genres,user_tag_547$rating)

#tokenize the genre

install.packages("tokenizers")
library(tokenizers)

f<-as.vector(user_tag_547$genres)

hist(f)

tokenize(f)

f[1]

strsplit(f[1],split = "|")

f[1]

strsplit(f,split = "|")

install.packages("recommenderlab")
install.packages("ggplot2")
install.packages("data.table")
install.packages("reshape2")
install.packages("wordcloud")

library(recommenderlab)
library(ggplot2)
library(data.table)
library(reshape2)
library(wordcloud)

wordcloud(user_tag)
?wordcloud


#data(user_tag,package = "recommenderlab")


#wordcloud(user_tag$genres,user_tag$rating)

install.packages("NMF")
library(NMF)
?NMF
??NMF

nmfAlgorithm()



install.packages("nmf")
library(nmf)

install.packages("Biobase")
library(NMF)
meth <- nmfAlgorithm(version='R')
NMFSeed()

nmfAlgorithm()


f1<-nmf(matrix4,3,.options="t")
summary(f1)
plot(f1)
basismap(f1,subsetRow=TRUE)
plot(g)
f1n<-nmf(matrix4,3,'ns')
f3<-nmf(matrix4,2:6,'ns')
plot(f3)

w<-basis(f1)
h<-coef(f1)
matrix4<-matrix4[,-1]

f2<-nmf(matrix4,4,.options="t")
plot(f2)
e<-summary(f2)
as.data.frame(e)
class(e)
as.data.frame(compare(f1,f2,f3))
f3<-nmf(matrix4,5,.options="t")
plot(f3)
summary(f3)
f20<-nmf(matrix4,20,.options="t")
plot(f20)
g<-fitted(f1)
g2<-fitted(f2)
gn<-fitted(f1n)
dim(gn)
dim(g2)
w<-summary(g2)
w
View(g2)
s<-featureScore(f20)
class(s)
summary(s)

class(f1)
summary(f1)
summary(f2)
class(g2)
summary(g2)

estim.r<-nmf(matrix4,2:6,nrun=10,seed=123456)


matrix4.sample<-matrix4[,sample(ncol(matrix4),ncol(matrix4)*0.1)]

estim.r<-nmf(matrix4.sample,2:6,nrun=3)

plot(estim.r)

#consensusmap(estim.r, annCol=matrix4.sample, labCol=NA, labRow=NA)

res.multi.method <- nmf(matrix4.sample, 3, list('brunet', 'lee', 'ns'), seed=123456, .options='t')
plot(res.multi.method)
class(res.multi.method)
compare(res.multi.method)

2.4%%0

Inf-Inf

2/3


sapply(my_car,is.na)

str(my_car)
ggplot(data = my_car) + 
  geom_point(mapping = aes(x = my_car$horsepower , y = my_car$price ,color = my_car$`body-style` ))

my_car$`fuel-type`

