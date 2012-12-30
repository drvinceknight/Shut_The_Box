#Script to analyze data
require(ggplot2)
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
p<-ggplot(shut_the_box_score_data,aes(x=Score,color=Method))+geom_density(alpha=.5)+ylab("Density")+opts(title = expression("Distribution of Shut the Box scores"))
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
p<-ggplot(shut_the_box_score_data,aes(x=Game_Length,color=Method))+geom_density(alpha=.5)+xlab("Game Length")+ylab("Density")+opts(title = expression("Distribution of Shut the Box game lengths"))
ggsave("Game_Length_Density.pdf")
ggsave("Game_Length_Density.png")


#Carry out an Anova
stbaov<-shut_the_box_score_data[shut_the_box_score_data$Method %in% c("greedy","shortest"),]
a<-aov(stbaov$Score~stbaov$Method)
summary(a)
