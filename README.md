# How Can a Wellness Technology Company Play it Smart?
### The Google Data Analytics Professional Certification Capstone Project

## Background
Bellabeat is a high-tech company that specializes in the manufacture of health-focused smart products, specifically, devices for women. The company was founded in 2013 by Urska Srsen and Sando Mur and since the induction of the company, the company has seen steady growth. The devices specialize in collecting data on activity, sleep, stress, and reproductive health which infroms women of their current health trends. By the year 2016, Bellabeat had launched a variety of products and had opened up offices around the world. The company had invested significant capital into their marketing budget and had been using advertisements across a broad range of mediums.

Now, with significant growth of the company already happening, Srsen would like to leverage available smart device data from different companies to reveal more opportunities for growth. She has tasked the marketing team with the analysis of smart device usage data to gain better insights into how people tend to use their smart devices. The insights gained from this analysis will be applied to a specific Bellabeat product and will be utilized to guide marketing strategy in the future.
## Ask
### Stakeholders
* __Urska Srsen__: Bellabeat's cofounder and Chief Creative Officer
* __Sando Mur__: Mathematician and Bellabeat’s cofounder; key member of the Bellabeat executive team
* __Bellabeat marketing analytics team__: A team of data analysts responsible for collecting, analyzing, and reporting data that helps guide Bellabeat's marketing strategy.

### Bellabeat Products
* __Bellabeat app__: The Bellabeat app provides users with health data related to their activity, sleep, stress, menstrual cycle, and mindfulness habits. This data can help users better understand their current habits and make healthy decisions.
* __Leaf__: Bellabeat’s classic wellness tracker can be worn as a bracelet, necklace, or clip. The Leaf tracker connects to the Bellabeat app to track activity, sleep, and stress.
* __Time__: This wellness watch combines the timeless look of a classic timepiece with smart technology to track user activity, sleep, and stress. The Time watch connects to the Bellabeat app to provide you with insights into your daily wellness.
* __Spring__: This is a water bottle that tracks daily water intake using smart technology to ensure that you are appropriately hydrated throughout the day. The Spring bottle connects to the Bellabeat app to track your hydration levels.
* __Bellabeat membership__: Bellabeat also offers a subscription-based membership program for users. Membership gives users 24/7 access to fully personzalized guidance on nutrition, activity, sleep, health and beauty, and mindfulness based on their lifestyle and goals.

### Business Task
Analyze smart device usage data from non-Bellabeat smart devices to gain insight into how customers use these products such that the analysis can be applied to Bellabeat products.

### Key Questions 
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends influence Bellabeat marketing strategy?

## Prepare
### Data Source
The data source used in this case study was a publicly available data set available on Kaggle titled __FitBit Fitness Tracker Data__. The data contained in this dataset was that of 30 eligible and consenting FitBit users that responded to a survey distributed via Amazon Mechanical Turk between the dates of March 12, 2016 and May 12, 2016. Each of the participants consented to the submission of their personal fitness tracking data which included physical activity, heart rate, and sleep monitoring data. The data set contains 30 CSV files and was last updated three months ago.

#### Limitations
* The biggest limitation of this data is that it is from 2016, making it more than five years old and outside of the accepted "current" range. It is important to note this limitation when providing recommendations.
* A second limitation of this data is the relatively small sample size. Although 30 is typically the minimum allowable sample size for statistical testing to result in meaningful results, a bigger sample size can always be relied on for more trustworthy results.
* For the information on user weight, only 11 individuals appear to have entered information regarding weight between March 12th and April 11th and only eight users appear to have entered information regarding weight between April 12th and May 12th. Of these 11 (8) users, most of the weight information was entered manually and thus bias and human error must be considered in this case.
* Some files only appear for one of the date ranges. Specifically, this happens for the `sleepDay_merged.csv` file which will be explored as part of this analysis. Due to this it is important to note that only one month worth of sleep data will be analyzed to draw conclusions. 
## Process
### Data Files to be Explored
In this case, multiple CSV files were included in the downloaded dataset. Our goal for this project is to analyze trends in smart device usage and apply these findings to make recommendations about Bellabeat products and marketing. With this in mind it is important to determine which information will be the most useful to achieve these goals. First, the `dailyActivity_merged.csv` file will be explored as this provides a general overview to the fitness activity of the users. Second, the `sleepDay_merged.csv` file will be explored as this provides information into how the users are using their devices to track their sleep patterns. __(Note: there is only sleep data recorded from April to May)__
### Data Cleaning
#### Excel
To begin with exploring the different CSV files that were included with this dataset, Excel will be used to complete an initial pass through.
1. Open the `dailyActivity_merged.csv` file. Apply a filter to all columns and check for blank values. Result: No blank values found.
2. Repeat step 1 for the `sleepDay_merged.csv` file. Result: no blank values found.
3. Inspect other columns in the files.
4. As no times are provided in the SleepDay column, the column will be transformed from a datetime format to a date format.
5. The Id column in all files to be explored will be switched from numeric format to text format as these numbers are not needed to make any calculations.

#### R
To continue with data cleaning, the mdoified CSV files were uploaded to RStudio where they could be further examined.
1. To start, the `tidyverse` package and the `janitor` package were loaded into the workspace.
2. The clean_names function from the janitor package was applied to the column names of the different data frames. This transformed the names to lowercase and separated the words by an underscore.
3. Each column containing date information was renamed to "date" and formatting was applied such that each date appeared the same.
   
   Example: <br>
    ```
    fitbit_data <- clean_names(fitbit_data) %>%
      mutate_at(vars(id), as.character) %>% 
      rename("date"="activity_date") %>% 
      mutate_at(vars(date), as.Date, format = "%m/%d/%y")
    ```
4. The newly combined dataset must then be checked for duplicates to ensure that no entries are being counted twice. Additionally, the number of NA columns was explored and the number of IDs for each dataset was found.

   ```
   combined_data <- combined_data[!duplicated(combined_data), ]
   sum(is.na(combined_data))
   n_distinct(combined_data$id)
   n_distinct(sleep_data$id)
   n_distinct(weight_loss_data$id)
   n_distinct(fitbit_data$id)
   ```
   
__Note__: The final dataset had 940 observations of 25 different variables. Of these possible 23,500 entries, 6893 of them were found to be NA. There were 33 distinct IDs found in the `combined_data` table, aligning with the number of distinct IDs found in the `dailyActivity_merged.csv` file. There were 24 distinct IDs found in the `sleepDay_merged.csv` file and only eight distinct IDs were found in the `weightLoginfo_merged.csv` file. This already points to a trend in the fitness tracker usage. __People are most likely to use their device throughout the course of the day, they are less likely to use their device to monitor sleep, and they are even less likely to use their device to monitor weight.__

## Analyze

### Initial Exploration
1. To start, some key fields were selected and the summary statistics for these fields were generated. This was the result:
   
   <img width="719" alt="Screenshot 2024-05-30 at 1 47 22 PM" src="https://github.com/CWS01/bellabeat_case_study/assets/148288624/3589c4da-2e3a-440b-a8b1-8485987e3234">

   Here it can be seen that on average users take 7638 steps a day and cover around 5.490 miles worth of distance. Looking at the different regimes of activity (very active, fairly active, lightly          active, and sedentary), one can see that majority of time is spent sedentary. Specifically, about 2% of a users time is spent being very active, about 1% of a users time is spent being fairly active,    about 16% of a users time is spent being lightly active, and about 81% of a users time is spent being sedentary. Users were found to sleep for an average of 419 minutes, or 7 hours, per night, while     spending a total of 459 minutes, or 7.6 hours, in bed per night. Lastly, users who recorded their weight had an average weight in pounds of 158.8 and an average body mass index (BMI) of 25.19. It is     again important to poiint out that opnly eight users utilized the weight tracking feature of their fitness device and thus these two fields saw a total of 873 NAs.

2. Next, the amount of total steps taken by all users was plotted as a function of the day of the week. This sought to gain insight into whether there were certain days of the week where individuals seemed to be more active.

   ![TotalStepsvsDayofWeek](https://github.com/CWS01/bellabeat_case_study/assets/148288624/824c7253-1d16-4a24-ad82-565a9fea90df)

   In the above bar graph, one can observe that individuals tend to take more steps during the middle of the week with a peak seen on Tuesday and taper off both moving towards the start of the week and     moving towards the end of the week. With this in mind, one would expect to see the same trend in total active minutes (very active minutes + fairly active minutes + lightly active minutes).

3. The total active minutes was then plotted as a function of the day of the week.

   ![ActiveMinutesvsDayofWeek](https://github.com/CWS01/bellabeat_case_study/assets/148288624/37849337-310c-40a8-83f5-bd82a26d1f65)

   A similar trend to the total steps as function of the day of the week was seen with the total active minutes peaking towards the middle of the week, speicifcally on Tuesday, and tapers being seen        both towards the start of the week and the end of the week.

4. Next, the distribution of the total minutes spent asleep and the total active minutes distribution was visualized.

   ![TotalMinutesAsleepDistribution](https://github.com/CWS01/bellabeat_case_study/assets/148288624/d4a728bc-1f13-4881-9e67-1dfe4f428600)
   ![TotalActiveMinutesDistribution](https://github.com/CWS01/bellabeat_case_study/assets/148288624/abd4a434-f4ae-4a90-aca6-cbe9e8c4af86)

   The distribution of the total minutes asleep appears to show that most people spend between 300 to 500 minutes, or 5 to 8.3 hours, asleep each night. The distribution of the total active minutes appears to show that most people spend between 200 to 400 minutes, or 3.33 to 6.67 hours, in an active state.

5. Now, we can compare these two metrics in a scatterplot to see if a relationship exists.

   ![TotalAcvtivevsTotalAsleep](https://github.com/CWS01/bellabeat_case_study/assets/148288624/bac49a4d-0bdf-47c9-bb22-ab4a44e8af91)

   As seen in the graph, there does not appear to be much of a relationship between the two variables with most of the values centralized in the locations mentioned prior. Calculation of the correlation coefficient between these two variables results in a small negative value (-0.06929) indicating that when total minutes asleep increases, there may be small decrease in total actove minutes. This is likely due to the fact that when you spend more time asleep, you have less time to be active throughout the course of the day.

6. The last item looked at was logged activity distance as a function of the day of the week. This offers insight into when users are actually exercising, as logged activity means the user chose to record the activity, and could provide insight into when is the best time to run marketing advertisements.

   ![LoggedActivityvsWeekday](https://github.com/CWS01/bellabeat_case_study/assets/148288624/3cac616d-9c1d-4f8b-8a55-1fe2a52da906)

   The above bar chart shows that users only logged activities between Monday and Friday with no users logging any activities over the weekend. This is rather interesting as one may expect users to log more activities when they have more free time (i.e. on the weekend) and not when they have other obligations (i.e. work, school) but in this data set, the opposite trend was observed.

## Share

See the case study dashboard here: [Bellabeat Case Study](https://public.tableau.com/views/Bellabeat_Case_Study_17171854499110/BellabeatDashboard?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)

## Ask

* The first thing to note is in regards to how many users submitted each type of data. As can be seen, three areas of personal fitness tracking were scrutinized. These were daily activity data, sleep data, and weight data. For daily activity data, there were 33 users submitting records, for sleep data there were only 24 users submitting records, and for weight data there were only eight users submitting records. This indicates that most users tend to wear their device throughout the day allowing for background tracking of their daily activity, less users use their device to monitor their sleep, and even fewer users like to use their watch for any sort of weight tracking activity. What this insinuates is that Bellabeat should focus on all of the background tracking their devices can accomplish when the device is simply being worn. Additionally, it could mean that Bellabeat could focus on ways to make sleep tracking and/or weight tracking more intuitive and easier as many of the weight entires had to be done manually.
* Users appeared to take their most steps during the middle of the week and taper off both towards the start and end of the week. Additionally, users recorded their most tracked distance on Monday and saw a steady decline as the week progressed with no tracked distance being recorded on Saturday or Sunday. This could indicate that Bellabeat should focus their ad campaign to be more active during the week as this is when individuals tend to both be more active and also using fitness trackers to track specific activities.
* There did not appear to be a strong correlation between minutes spent active and the amount of time spent asleep. There was a weak negative correlation indicating that as users spent more time asleep, they tended to spend less time being active. This is likely due to the fact that when you spend more time asleep, you have less time to be active during a given day. Although this data is not necessarily useful for guiding marketing decisions, it could be useful for reinforcing the fact that recovery is important when performing a lot of activity.
* Expanding on this analysis would be a great next step. As data was only provided for 30 users, one possibility is to collect data from more users and then repeat this type of analysis. Additionally, the data is from 2016 and thus would not be considered current anymore. Both a larger and more recent data set could lead to better and more confident conclusions with regard to personal fitness tracking data.
