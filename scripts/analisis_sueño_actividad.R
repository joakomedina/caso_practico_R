### dos data frame
### juntar sleep_day_df y daily_activity para determinar si existe una relación entre una, dos o tres sesiones de sueño 
### y la actividad física

activity_sleep <- merge(sleep_day_df, daily_activity, by =c("id", "date"))

sleep_activity <- activity_sleep %>%
  select(id, date, totalsleeprecords, totalsteps) %>%
  group_by(totalsleeprecords) %>%
  summarise(avg = mean(totalsteps))

View(sleep_activity)

#### Visualizar relación

ggplot(sleep_activity, aes(x = totalsleeprecords, y = avg)) +
  geom_bar(stat = "identity", fill = "#76b7b2") +
  labs(title = "Promedio de pasos dados según el número de registros de sueño",
       x = "Número de registros de sueño", y = "Promedio de pasos dados")
