# load packages
library(googlesheets); library(reshape2); library(ggplot2)
source('~/Dropbox (Personal)/Functions/SummarySE.R')

# which google sheets do you have access to?
# may ask you to authenticate in a browser!
#gs_ls()

##### get the delay discounting google sheet - change to the name of YOUR spreadsheet
dd <- gs_title("Delay Discounting (Responses)")

# list worksheets
gs_ws_ls(dd)

# get delay discounting data
dd1 <- gs_read(ss=dd, ws = "Form Responses 1")
colnames(dd1) <- c('Timestamp', 'Untimed', 'Timed')

# calculate means
dd2 <- melt(dd1, id.vars = 'Timestamp', variable.name = 'Condition', value.name = 'DiscountRate')
dd3 <- summarySE(dd2, measurevar = 'DiscountRate', groupvars = 'Condition')

# calculate difference scores
#dd1$diff <- dd1$Timed - dd1$Untimed

# histograms
hist1 <- ggplot(dd1, aes(x=Untimed)) + geom_histogram(binwidth = 0.001, fill="#FF6666") + expand_limits(x=c(0,0.15)) +theme_bw()
hist2 <- ggplot(dd1, aes(x=Timed)) + geom_histogram(binwidth = 0.001, fill="#33CCCC") + expand_limits(x=c(0,0.15)) + theme_bw()

# means
timepress <- ggplot(dd3, aes(Condition, DiscountRate, fill = Condition)) + geom_bar(stat='identity', position=position_dodge()) + 
  geom_errorbar(aes(ymin=DiscountRate-se, ymax=DiscountRate+se), width = .2, position = position_dodge(.9)) +
   theme_bw() + theme(legend.position = 'none')

setwd('~/Desktop/Teachable Tidbit/')
saveRDS(timepress, 'timepress.rds')
saveRDS(hist1, 'hist1.rds')
saveRDS(hist2, 'hist2.rds')
