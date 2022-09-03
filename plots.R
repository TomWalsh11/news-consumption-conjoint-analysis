rm(list=ls())
library("ggplot2")
library("ggthemes")

# Figure 1: News Conjoint Main
d <- read.table("/Users/thomaswalsh/Documents/LSE/Dissertation/MyCode/newschoice.txt",comment.char="")
ffilename<- "Fig1"

# Group variables
Outletheadline     <- paste(c("1b",2:7),".outletheadline",sep="")
EndorserPartisanship     <- paste(c("1b",2:3),".endorserpartisanship",sep="")
EndorserGender    <- paste(c("1b",2),".endorsergender",sep="")
EndorserReligiosity   <- paste(c("1b",2),".endorserreligiosity",sep="")

# 95% Confidence Interval
CIs <- function(d){
  colnames(d)[1:2] <- c("pe","se")
  d$upper <-d$pe + 1.96*d$se
  d$lower <-d$pe - 1.96*d$se
  return(d)
}
d<- CIs(d)
d$var <- rownames(d)

FillGroup <- function(d){
  
  d$gruppe <- NA
  d$gruppe[d$var %in% Outletheadline]       <- "Partisan Bias"
  d$gruppe[d$var %in% EndorserPartisanship]       <- "Endorser Partisanship"
  d$gruppe[d$var %in% EndorserGender]       <- "Endorser Gender"
  d$gruppe[d$var %in% EndorserReligiosity]       <- "Endorser Religiosity"
  
  # reorder
  d <- rbind(d[d$var %in% Outletheadline,],
             d[d$var %in% EndorserPartisanship,],
             d[d$var %in% EndorserGender,],
             d[d$var %in% EndorserReligiosity,])
  return(d)
}

d <- FillGroup(d)
d$order <- 1:nrow(d)

GetLabels <- function(d){
  offset <- c("   ")
  
  d$var[d$var %in% Outletheadline] <- paste(offset,c("N","3R","2R","1R","3D","2D","1D"))
  d$var[d$var %in% EndorserPartisanship] <- paste(offset,c("Independent",
                                                           "Republican","Democrat"))
  
  d$var[d$var %in% EndorserGender] <- paste(offset,c("Male",
                                                     "Female"))
  
  d$var[d$var %in% EndorserReligiosity] <- paste(offset,c("Not Religious","Religious"))
  
  return(d)
}

d <- GetLabels(d)

# Bring in Sub Labels           
d <- d[order(d$order),]
dd <- data.frame(var= c("Partisan Bias:",
                        " ",
                        "Endorser Partisanship:",
                        "  ",
                        "Endorser Gender:",
                        "   ",
                        "Endorser Religiosity:"
),order=c(0.5,7.1,7.5,10.1,10.9,12.1,12.9),pe=1,se=1,upper=1,lower=1,gruppe=NA)

d <- rbind(d,dd)
d <-d[order(d$order),]
d$var <- factor(d$var,levels=unique(d$var)[length(d$var):1])

yylab  <- c("\nChange in Pr(Article Chosen to Read)")

p = ggplot(d,aes(y=pe,x=var,colour=gruppe))
p = p + coord_flip(ylim = c(-.6, .6))  
p = p + geom_hline(yintercept = 0,size=.5,colour="black",linetype="dotted") 
p = p +geom_pointrange(aes(ymin=lower,ymax=upper,width=.4),position="dodge",size=.6)
p = p + scale_y_continuous(name=yylab,breaks=round(seq(-.6,.6,.2),1),labels=c("-.6","-.4","-.2","0",".2",".4",".6"))
p = p + scale_colour_discrete("",na.translate=F) + scale_x_discrete(name="")
print(p)

dev.off()
pdf(paste(ffilename,".pdf",sep=""),width=10,height=12.5)
p = p  + theme_gray()
print(p)
dev.off()

# Figure 2: By Partisanship of Respondent
k=2
subfilename <- "Fig2"
subsetnlabel <- ""
slevels <- c(1,2)

d <- read.table("/Users/thomaswalsh/Documents/LSE/Dissertation/MyCode/PartyID1.txt",comment.char="")
rows <- rownames(d)
p <- nrow(d)
for(i in 2:k){
  d <-   rbind(d,read.table(paste("PartyID",i,".txt",sep=""),comment.char=""))
}
d$subset      <- rep(1:k,each=p)
d$subsetlabel <- paste(subsetnlabel, rep(c("Democrats",
                                           "Republicans"),each=p))

d <- CIs(d)
d$var <- rep(rows,k)
d <- FillGroup(d)

d$order <- 1:nrow(d)
d <- d[order(d$subset,d$order),]
d$order <- 1:nrow(d)
d <- GetLabels(d)

d <- d[order(d$order),]
dd <- data.frame(var= c("Partisan Bias:",
                        " ",
                        "Endorser Partisanship:",
                        "  ",
                        "Endorser Gender:",
                        "   ",
                        "Endorser Religiosity:"
),order=c(0.5,7.1,7.5,10.1,10.9,12.1,12.9),pe=1,se=1,upper=1,lower=1,gruppe=NA,subset=NA,subsetlabel=NA)

d <- rbind(d,dd)
d <-d[order(d$order),]
d$var <- factor(d$var,levels=unique(d$var)[length(d$var):1])

d$subsetlabel[is.na(d$subsetlabel)] <- unique(d$subsetlabel)[2]
d$subsetlabel <- factor(d$subsetlabel,levels=unique(d$subsetlabel))

p = ggplot(d,aes(y=pe,x=var,colour=gruppe))
p = p + facet_grid(.~subsetlabel)
p = p + coord_flip(ylim = c(-.6, .6))
p = p + geom_hline(yintercept = 0,size=.5,colour="black",linetype="dotted") 
p = p +geom_pointrange(aes(ymin=lower,ymax=upper,width=.4),position="dodge",size=.6)
p = p + scale_y_continuous(name=yylab,breaks=round(seq(-.6,.6,.2),1),labels=c("-.6","-.4","-.2","0",".2",".4",".6"))
p = p + scale_x_discrete(name="") + scale_colour_discrete("",na.translate=F)
print(p)

dev.off()
pdf(paste(subfilename,".pdf",sep=""),width=14,height=9.5)
p = p  + theme_gray()
print(p)
dev.off()

# Figure 3: By Respondent Religiosity
k=2
subfilename <- "Fig3"
subsetnlabel <- ""
slevels <- c(1,2)

d <- read.table("/Users/thomaswalsh/Documents/LSE/Dissertation/MyCode/Religiosity1.txt",comment.char="")
rows <- rownames(d)
p <- nrow(d)
for(i in 2:k){
  d <-   rbind(d,read.table(paste("Religiosity",i,".txt",sep=""),comment.char=""))
}
d$subset      <- rep(1:k,each=p)
d$subsetlabel <- paste(subsetnlabel, rep(c("Religious",
                                           "Not Religious"),each=p))

d <- CIs(d)
d$var <- rep(rows,k)
d <- FillGroup(d)

d$order <- 1:nrow(d)
d <- d[order(d$subset,d$order),]
d$order <- 1:nrow(d)
d <- GetLabels(d)

d <- d[order(d$order),]
dd <- data.frame(var= c("Partisan Bias:",
                        " ",
                        "Endorser Partisanship:",
                        "  ",
                        "Endorser Gender:",
                        "   ",
                        "Endorser Religiosity:"
),order=c(0.5,7.1,7.5,10.1,10.9,12.1,12.9),pe=1,se=1,upper=1,lower=1,gruppe=NA,subset=NA,subsetlabel=NA)

d <- rbind(d,dd)
d <-d[order(d$order),]
d$var <- factor(d$var,levels=unique(d$var)[length(d$var):1])

d$subsetlabel[is.na(d$subsetlabel)] <- unique(d$subsetlabel)[2]
d$subsetlabel <- factor(d$subsetlabel,levels=unique(d$subsetlabel))

p = ggplot(d,aes(y=pe,x=var,colour=gruppe))
p = p + facet_grid(.~subsetlabel)
p = p + coord_flip(ylim = c(-.6, .6))
p = p + geom_hline(yintercept = 0,size=.5,colour="black",linetype="dotted") 
p = p +geom_pointrange(aes(ymin=lower,ymax=upper,width=.4),position="dodge",size=.6)
p = p + scale_y_continuous(name=yylab,breaks=round(seq(-.6,.6,.2),1),labels=c("-.6","-.4","-.2","0",".2",".4",".6"))
p = p + scale_x_discrete(name="") + scale_colour_discrete("",na.translate=F)
print(p)

dev.off()
pdf(paste(subfilename,".pdf",sep=""),width=14,height=9.5)
p = p  + theme_gray()
print(p)
dev.off()