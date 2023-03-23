
### juntar sleep_day_df y daily_activity para determinar si existe una relación entre una, dos o tres sesiones de sueño 
### y la actividad física

activity_sleep <- merge(sleep_day_df, daily_activity, by =c("id", "date"))

sleep_activity <- activity_sleep %>%
  select(id, date, totalsleeprecords, totalsteps) %>%
  group_by(totalsleeprecords) %>%
  summarise(avg = mean(totalsteps))
View(sleep_activity)