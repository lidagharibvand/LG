install.packages("haven")
install.packages("car")
install.packages("multcomp")
install.packages("epiDisplay")
install.packages("ggplot")
install.packages("gmodels")
#q1
#load data
library(haven)
q1<-read_spss("hers.sav")
#change variable name to lower cases
names(q1)<-tolower(names(q1))

#90% CI For BMI#
t.test(q1$bmi,conf.level=0.90)$conf.int


#differece in mean

nondiab<-q1$bmi[q1$diabetes==0]
diab<-q1$bmi[q1$diabetes==1]
#equal variance
var.test(bmi~diabetes,data=q1)
t.test(nondiab,diab,alternative="two.sided",var.equal=TRUE,conf.level=0.90)$conf.int

#different CI
nondiab<-q1$bmi[q1$diabetes==0]
diab<-q1$bmi[q1$diabetes==1]
t.test(nondiab,conf.level=0.90)$conf.int
t.test(diab,conf.level=0.90)$conf.int

#one sample ttest

q2<-read_spss("hers.sav")
names(q2)<-tolower(names(q2))
#a
t.test(q2$bmi,mu=30,alternative="less",conf.int=0.95)
#not equal
t.test(q2$bmi,mu=30,conf.int=0.95)
#versas 
#equal variance
var.test(bmi~diabetes,data=q2)
#independent t test
t.test(diab,nondiab,alternative="greater",var.equal=TRUE,conf.level=0.95)

#not equal
t.test(diab,nondiab,var.equal=TRUE,conf.level=0.95)


#paired t test
t.test(q2$hdl,q2$hdl1,paired=TRUE,alternative="two.sided",conf.int=0.95)

q2$physact2[q2$physact==1]<-"No physical activity"
q2$physact2[q2$physact==2]<-"Once a month"
q2$physact2[q2$physact==3]<-"Two times a month"
q2$physact2[q2$physact==4]<-"Four times a month"
q2$physact2[q2$physact==5]<-"More than once a week"
#test for equal variance
library(car)
leveneTest(bmi~physact2,data=q2)
#ANOVA test
summary(aov(bmi~physact2,data=q2))
#multiple comparison Tukey
library(multcomp)
q2$physact2<-as.factor(q2$physact2)
model<-lm(bmi~physact2,data=q2)
summary(glht(model,mcp(physact2="Tukey")))

#create boxplot
boxplot(bmi~physact2,data=q2)

summary(aov(weight~physact2,data=q2))
q3<-read_spss("hers.sav")
names(q3)<-tolower(names(q3))
#summary statistics
mean(q3$age,na.rm=TRUE)
sd(q3$age,na.rm=TRUE)
mean(q3$weight,na.rm=TRUE)
sd(q3$weight,na.rm=TRUE)
mean(q3$bmi,na.rm=TRUE)
sd(q3$bmi,na.rm=TRUE)
q3$racethnicity[q3$raceth==1]<-"Caucasian"
q3$racethnicity[q3$raceth==2]<-"African American"
q3$racethnicity[q3$raceth==3]<-"Hispanic"
library(epiDisplay)
tab1(q3$racethnicity)
q3$physact2[q3$physact==1]<-"No physical activity"
q3$physact2[q3$physact==2]<-"Once a month"
q3$physact2[q3$physact==3]<-"Two times a month"
q3$physact2[q3$physact==4]<-"Four times a month"
q3$physact2[q3$physact==5]<-"More than once a week"
tab1(q3$physact2)
q3$smoke2[q3$smoking==0]<-"No"
q3$smoke2[q3$smoking==1]<-"Yes"
tab1(q3$smoke2)
q3$statins2[q3$statins==0]<-"No"
q3$statins2[q3$statins==1]<-"Yes"
tab1(q3$statins2)



#multiple comparison Tukey
library(multcomp)
q2$physact2<-as.factor(q2$physact2)
model<-lm(weight~physact2,data=q2)
summary(glht(model,mcp(physact2="Tukey")))

#create boxplot
boxplot(weight~physact2,data=q2)
#run scatter plot
q5<-read_spss("hers.sav")
names(q5)<-tolower(names(q5))
library(ggplot2)
ggplot(q5,aes(x=age,y=sbp))+
  geom_point()+
  geom_smooth(method=lm)
ggplot(q5,aes(x=bmi,y=sbp))+
  geom_point()+
  geom_smooth(method=lm)
ggplot(q5,aes(x=bmi,y=glucose))+
  geom_point()+
  geom_smooth(method=lm)
q5_lm<-lm(sbp~age+bmi+glucose,data=q5)
summary(q5_lm)


#Medcond
q6<-read_spss("hers.sav")
names(q6)<-tolower(names(q6))
q6$medcond2[q6$medcond==0]<-"Medical condition:No"
q6$medcond2[q6$medcond==1]<-"Medical condition:Yes"
q6$smoke2[q6$smoking==0]<-"Smoking:No"
q6$smoke2[q6$smoking==1]<-"Smoking:Yes"
ctable<-table(q6$medcond2,q6$smoke2)
ctable
chisq_test<-chisq.test(q6$medcond2,q6$smoke2)
chisq_test


library(gmodels)
CrossTable(q6$medcond2,q6$smoke2)


