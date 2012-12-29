#Script to analyze data
require(ggplot2)
shut_the_box_data<-read.csv("Shut_the_Box.csv")
Greedy<-data.frame(Score=shut_the_box_data$Greedy_Score)
Greedy$Method<-"greedy"
Random<-data.frame(Score=shut_the_box_data$Random_Score)
Random$Method<-"random"
Shortest<-data.frame(Score=shut_the_box_data$Shortest_Score)
Shortest$Method<-"shortest"
Longest<-data.frame(Score=shut_the_box_data$Longest_Score)
Longest$Method<-"longest"
shut_the_box_score_data<-rbind(Greedy,Random,Shortest,Longest)
p<-ggplot(shut_the_box_score_data,aes(x=Score,color=Method))+geom_density(alpha=.5)+ylab("Density")+opts(title = expression("Distribution of Shut the Box scores"))
ggsave("Density_plot.pdf")
ggsave("Density_plot.png")
