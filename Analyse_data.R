#Script to analyze data
require(ggplot2)
require(reshape)

#Plot scores from game at Annie's:
stb_game_at_Annie<-data.frame(Zoë=c(13,26,30,39,39,44,49,62),Christiane=c(18,25,29,38,44,53,62,66),Krystyna=c(0,3,5,19,32,52,53,66),Annie=c(0,0,22,44,53,60,68,87),Vincent=c(6,22,48,49,74,77,92,117),Jean=c(20,38,47,62,65,95,109,118),Turn=1:8)
stb_game_at_Annie<-melt(stb_game_at_Annie,id='Turn',variable_name='Name')
ggplot(stb_game_at_Annie,aes(Turn,value))+geom_line(aes(colour=Name))+ylab("Cumulative Score")+scale_x_continuous(breaks=1:8)+opts(title=expression("Shut the Box running Scores"))
ggsave("Game_at_Annie_score.png")
ggsave("Game_at_Annie_score.pdf")

#Read in data and put in desired format
shut_the_box_data<-read.csv("Data_for_Analysis.csv")
Greedy<-data.frame(Score=shut_the_box_data$Greedy_Score,Game_Length=shut_the_box_data$Greedy_History)
Greedy$Method<-"greedy"
Random<-data.frame(Score=shut_the_box_data$Random_Score,Game_Length=shut_the_box_data$Random_History)
Random$Method<-"random"
Shortest<-data.frame(Score=shut_the_box_data$Shortest_Score,Game_Length=shut_the_box_data$Shortest_History)
Shortest$Method<-"shortest"
Longest<-data.frame(Score=shut_the_box_data$Longest_Score,Game_Length=shut_the_box_data$Longest_History)
Longest$Method<-"longest"
shut_the_box_score_data<-rbind(Greedy,Random,Shortest,Longest)


#Obtain density plots
p<-ggplot(shut_the_box_score_data,aes(x=Score,color=Method))+geom_density(alpha=.5)+ylab("Density")+opts(title = expression("Distribution of Shut the Box Scores"))
ggsave("Score_Density.pdf")
ggsave("Score_Density.png")
print("Mean Game Length with Random autoplay:")
print(mean(Random$Game_Length, na.rm=TRUE))
print("Mean Game Length with Shortest autoplay:")
print(mean(Shortest$Game_Length, na.rm=TRUE))
print("Mean Game Length with Longest autoplay:")
print(mean(Longest$Game_Length, na.rm=TRUE))
print("Mean Game Length with Greedy autoplay:")
print(mean(Greedy$Game_Length, na.rm=TRUE))
p<-ggplot(shut_the_box_score_data,aes(Game_Length, ..density.., colour = Method))+geom_freqpoly(binwidth=1)+xlab("Game Length")+ylab("Density")+opts(title = expression("Distribution of Shut the Box game Lengths"))
ggsave("Game_Length_Density.pdf")
ggsave("Game_Length_Density.png")


#Basic Summary statistics
summary(shut_the_box_data)

#Carry out an Anova
stbaov<-shut_the_box_score_data[shut_the_box_score_data$Method %in% c("greedy","shortest"),]
a<-aov(stbaov$Score~stbaov$Method)
summary(a)

