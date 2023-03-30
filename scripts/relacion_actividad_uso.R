# Relación entre el uso del dispositivo inteligente y la actividad física realizada por las personas
# que la media de los minutos usados la podemos comparar con la media de actividad asumiendo que la actividad fisica
# es la sumatoria de todas las actvidades con intensidad 1,2,3

str(daily_minutes_used) 

actividad_uso <- daily_minutes_used %>%
  arrange(id, date) %>%
  group_by(id, date) %>%
  summarise(totalsteps = sum(totalsteps),
            veryactiveminutes = sum(veryactiveminutes),
            fairlyactiveminutes = sum(fairlyactiveminutes),
            lightlyactiveminutes = sum(lightlyactiveminutes),
            minutesused = sum(minutesused),
            calories = sum(calories),
            min_activity = sum(veryactiveminutes, fairlyactiveminutes, lightlyactiveminutes)) %>%
  mutate(date = as.Date(date, format = "%m-%d-%y")) %>%
  select(id, date, totalsteps, veryactiveminutes, fairlyactiveminutes, lightlyactiveminutes, calories, minutesused, min_activity) 

# Resumen

actividad_uso %>%
  select(totalsteps, veryactiveminutes, fairlyactiveminutes, lightlyactiveminutes, calories, minutesused, min_activity) %>%
  summary()

# grafico

ggplot(data=actividad_uso)+
  geom_smooth(mapping = aes(x=minutesused, y=min_activity))+
  geom_point(mapping = aes(x=minutesused, y=min_activity))

# correlación

cor_used_activity <- cor(actividad_uso$minutesused, actividad_uso$min_activity)
cor_calories_activity <- cor(actividad_uso$min_activity, actividad_uso$calories)
