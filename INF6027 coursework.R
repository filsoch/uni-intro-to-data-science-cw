library(kableExtra)
library(tidyverse)
library(corrplot)
library(modelsummary)
library(stargazer)

IMD_2019 <- read_csv("IMD_2019.csv")

# comparing 100 least deprived areas with 100 most deprived

#100 most health deprived

most_deprived <- filter(IMD_2019, HDDRank <= 100)
most_deprived <- select(most_deprived, HDDRank, IncRank, EduRank, CriRank, EnvRank,
                        IMDRank0, EmpRank, BHSRank, IDCRank, IDORank, CYPRank,
                        ASRank, GBRank, WBRank, OutRank, IndRank)

mean_most_deprived <- summarise_each(most_deprived, funs(mean))

mean_most_deprived <- gather(mean_most_deprived)

numbers <- c(1:16)

numbers <- data.frame(numbers)

mean_most_deprived <- bind_cols(mean_most_deprived, numbers)

most_deprived_plot <- ggplot (mean_most_deprived, aes (x=numbers, y=value)) + 
  geom_bar (stat = "identity", fill = "steelblue") +
  theme_light () +
  labs (x="Deprivation Indices", y="Mean of Deprivation ratings",
  title = "Means of deprivation ratings for 100 most health deprived areas") +
  scale_x_continuous (breaks=seq (1,16,1)) +
  theme(axis.title.x = element_text (size = 18),
        axis.title.y = element_text (size = 18),
        axis.text = element_text (size=16, face = "bold"),
        plot.title = element_text(size=22))

#100 least health derpived                                                              

least_deprived <- filter(IMD_2019, HDDRank >= (nrow(IMD_2019)-99))

least_deprived <- select(least_deprived, HDDRank, IncRank, EduRank, CriRank, EnvRank,
                         IMDRank0, EmpRank, BHSRank, IDCRank, IDORank, CYPRank,
                         ASRank, GBRank, WBRank, OutRank, IndRank)


mean_least_deprived <- summarise_each(least_deprived, funs(mean))

mean_least_deprived <- gather(mean_least_deprived)

mean_least_deprived <- bind_cols(mean_least_deprived, numbers)

least_deprived_plot <- ggplot (mean_least_deprived, aes (x=numbers, y=value)) + 
  geom_bar (stat = "identity", fill = "steelblue", width = 0.7) +
  theme_light () +
  labs (x="Deprivation Indices", y="Mean of Deprivation ratings",
  title = "Means of deprivation ratings for 100 least health deprived areas") +
  scale_x_continuous (breaks=seq (1,16,1)) +
  theme(axis.title.x = element_text (size = 18),
        axis.title.y = element_text (size = 18),
        axis.text = element_text (size=16, face = "bold"),
        plot.title = element_text(size=22))

#making a subset data with the variables of interest

IMD_Scores <- select (IMD_2019, LSOA01NM, HDDScore, IncScore, EduScore, CriScore, EnvScore,
                      IMDScore, EmpScore, BHSScore, IDCScore, IDOScore, CYPScore,
                      ASScore, GBScore, WBScore, OutScore, IndScore)

#testing correlation between variables (rounding to 2 decimals)

IMD_Scores_corr <- round (cor (IMD_Scores[2:17]), 2)

IMD_Scores_corr <- as.data.frame(IMD_Scores_corr) 

#checking what variables have low correlation score

IMD_Scores_corr <- filter(IMD_Scores_corr, HDDScore <= 0.3  & HDDScore >= -0.3)


#variables EnvScore,BHSScore, WBSScore, OutScore, IndScore have low correlation
#with HDDScore (less than 0.3 or -0.3), therefore they have been removed to 
#improve table readability

IMD_Scores_corr <- round (cor (IMD_Scores[2:17]), 2)

IMD_Scores_corr <- as.data.frame(IMD_Scores_corr) 

IMD_Scores_corr <- filter(IMD_Scores_corr, HDDScore >= 0.3  | HDDScore <= -0.3)

IMD_Scores_corr <- select(IMD_Scores_corr, -EnvScore,
                          -BHSScore, -WBScore, -OutScore, -IndScore)

IMD_Scores_corr <- arrange(IMD_Scores_corr, desc(HDDScore))

#making a table for publication

webshot::install_phantomjs()

IMD_Scores_corr %>%
  kbl(caption = "Correlation scores between selected variables in dataset") %>%
  kable_classic(full_width = F, html_font = "Cambria", font_size = 16) %>% 
  save_kable("Charts/correlation_table.html")

#correlation plot with all variables

IMD_Scores_corr <- round (cor (IMD_Scores[2:17]), 2)

file_path= "Charts/Correlation matrix.png"
png(height=1000, width=1000, file=file_path, type = "cairo")

corrplot(IMD_Scores_corr, method = 'color',
                 addCoef.col = 'black',
                 type = 'lower', diag = FALSE, tl.srt = 45)

dev.off()
                  
#correlation tests to determine the highest correlation

cor.test(IMD_2019$HDDScore, IMD_2019$EmpScore)

cor.test(IMD_2019$HDDScore, IMD_2019$IMDScore)

#dividing the dataset into training and testing data

train_size = 0.7

IMD_Scores <- IMD_Scores[sample(1:nrow(IMD_Scores)),]

IMD_train <- IMD_Scores[1:(train_size*nrow(IMD_Scores)),]
IMD_test <- IMD_Scores[(nrow(IMD_train)+1):nrow(IMD_Scores),]

#simple linear regression model using "income score" as an independent variable

mod_income <- lm (
  formula = HDDScore ~ EmpScore,
  data = IMD_train)

#Testing the simple linear regression model

IMD_simple_test <- IMD_test 
IMD_simple_test$predicted <- predict(mod_income, newdata=IMD_simple_test)
IMD_simple_test$residuals <- IMD_simple_test$predicted - IMD_simple_test$HDDScore
IMD_simple_test

sse_simple_model <- sum(IMD_simple_test$residuals**2)
sse_simple_model #SSE = 2180.643

#visualising simple linear regression model

coefs_income <- coef(mod_income)
reg_plot <- ggplot (data = IMD_train,
  aes (x = EmpScore, y = HDDScore)) +
  geom_point() +
  geom_abline (mapping = aes(
    slope = coefs_income["EmpScore"],
    intercept = coefs_income["(Intercept)"]),
    color='red') +
  labs(x="Employment Score", y="Health Deprivation and Disability Score") +
  theme(axis.title=element_text(size=14,face="bold"))

#creating a plot of a smaller subset of data to improve visibility 

IMD_Train_150 <- sample_n(IMD_train, 150)

reg_plot_150 <- ggplot (data = IMD_Train_150,
        aes (x = EmpScore, y = HDDScore)) +
  geom_point() +
  geom_abline (mapping = aes(
    slope = coefs_income["EmpScore"],
    intercept = coefs_income["(Intercept)"]),
    color='red') +
  labs(x="Employment Score", y="Health Deprivation and Disability Score") +
  theme(axis.title=element_text(size=14,face="bold"))

#multiple linear regression model

intercept_only <- lm (HDDScore ~ 1, data = IMD_train)

all_predictor_model <- lm (HDDScore ~ ., data = IMD_train[2:17])

forward_stepwise <- step(intercept_only, direction='forward',
                         scope=formula(all_predictor_model), trace=0)

forward_stepwise$anova

mod_multi_test <- IMD_test 
mod_multi_test$predicted <- predict(forward_stepwise, newdata=mod_multi_test)
mod_multi_test$residuals <- mod_multi_test$predicted - mod_multi_test$HDDScore
mod_multi_test

sse_multi_model <- sum(mod_multi_test$residuals**2)
sse_multi_model #SSE = 1084.233

ggsave("Charts/most_deprived_areas.png", plot = most_deprived_plot, 
       width = 10,
       height = 10,
       units = ("in"))
ggsave("Charts/least_deprived_areas.png", plot = least_deprived_plot, 
       width = 10,
       height = 10,
       units = ("in"))
ggsave("Charts/regression_1.png", plot = reg_plot, 
       width = 10,
       height = 10,
       units = ("in"))
ggsave("Charts/regression_2.png", plot = reg_plot_150, 
       width = 10,
       height = 10,
       units = ("in"))

stargazer(all_predictor_model, type = "html",
          out = "multiple_regression_summary.html")
stargazer(mod_income, type = "html",
          out = "simple_regression_summary.html")
