```
  library(tidyverse)
  library(janitor)
  
  fitbit_data <- read_csv("documents/Case Study/Data/FitBit Data/12April2016_12May2016/Fitabase Data/dailyActivity_merged.csv")
  
  fitbit_data <- clean_names(fitbit_data) %>% 
    mutate_at(vars(id), as.character) %>% 
    rename("date"="activity_date") %>% 
    mutate_at(vars(date), as.Date, format = "%m/%d/%y")
  
  head(fitbit_data)
  
  sleep_data <- read_csv("documents/Case Study/Data/FitBit Data/12April2016_12May2016/Fitabase Data/sleepDay_merged.csv")
  
  sleep_data <- clean_names(sleep_data) %>% 
    mutate_at(vars(id), as.character) %>% 
    rename("date"="sleep_day") %>% 
    mutate_at(vars(date), as.Date, format = "%m/%d/%y")
  
  head(sleep_data)
  
  weight_loss_data <- read_csv("documents/Case Study/Data/FitBit Data/12April2016_12May2016/Fitabase Data/weightLoginfo_merged.csv")
  
  weight_loss_data <- clean_names(weight_loss_data) %>% 
    mutate_at(vars(id), as.character) %>% 
    mutate_at(vars(date), as.Date, format = "%m/%d/%Y")
  
  head(weight_loss_data)
  
  combined_data <- fitbit_data %>% 
    left_join(sleep_data, by=c("id", "date")) %>% 
    left_join(weight_loss_data, by=c("id", "date")) %>% 
    mutate(weekday = weekdays(as.Date(date, "%m/%d/%y")))
  
  combined_data <- combined_data[!duplicated(combined_data), ]
  sum(is.na(combined_data))
  n_distinct(combined_data$id)
  n_distinct(sleep_data$id)
  n_distinct(weight_loss_data$id)
  n_distinct(fitbit_data$id)
  
  combined_data$weekday <- factor(combined_data$weekday, levels=c("Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
  
  combined_data <- combined_data %>% 
    mutate(total_active_minutes = very_active_minutes + fairly_active_minutes + lightly_active_minutes)
  
  
  combined_data %>% 
    select(total_steps, total_distance, very_active_minutes, fairly_active_minutes, lightly_active_minutes, sedentary_minutes, calories, total_minutes_asleep, total_time_in_bed, weight_pounds, bmi) %>% 
    summary()
  
  ggplot(data=combined_data, aes(x=total_steps, y=sedentary_minutes)) + geom_point()
  
  ggplot(data=combined_data, aes(x=total_minutes_asleep, y=total_time_in_bed)) + geom_point()
  
  ggplot(data=combined_data, aes(x=total_steps, y=total_distance)) +
    geom_point()
  
  ggplot(data=combined_data, aes(x=weekday, y=total_steps)) +
    geom_bar(stat = 'identity', fill='blue') +
    labs(title="Total Steps vs Day of Week", x="Day of the Week", y= "Total Steps across All Users")
  
  ggplot(data=combined_data, aes(x=weekday, y=total_active_minutes)) +
    geom_bar(stat = 'identity', fill='blue') +
    labs(title="Total Active Minutes vs Day of Week", x="Day of the Week", y= "Total Active Minutes across All Users")
  
  ggplot(data=combined_data, aes(x=total_minutes_asleep)) +
    geom_histogram(binwidth=100, fill="blue", color="black") +
    labs(title="Total Minutes Asleep Distribution", x="Total Minutes Asleep", y="Count")
  
  ggplot(data=combined_data, aes(x=total_active_minutes)) +
    geom_histogram(binwidth=50, fill="blue", color="black") +
    labs(title="Total Active Minutes Distribution", x="Total Active Minutes", y="Count")
  
  ggplot(data=combined_data, aes(x=total_minutes_asleep, y=calories)) +
    geom_point(color="blue")
  
  ggplot(data=combined_data, aes(x=total_minutes_asleep, y=total_active_minutes)) +
    geom_point(color="blue") +
    labs(title="Total Active Minutes vs. Total Minutes Asleep", x="Total Minutes Asleep", y="Total Active Minutes")
  
  cor(combined_data$total_minutes_asleep, combined_data$total_active_minutes, use="complete.obs")
  
  summarize(mean(combined_data$total_minutes_asleep), cor(x=combined_data$total_minutes_asleep, y=combined_data$calories))
  
  ggplot(data=combined_data, aes(x=weekday, y=logged_activities_distance)) +
    geom_bar(stat = "identity", fill="blue") + 
    labs(title="Logged Activity Distance vs. Day of the Week", x="Weekday", y="Logged Activity Distance")
  
  write_csv(combined_data, file="combined_data.csv")
```
