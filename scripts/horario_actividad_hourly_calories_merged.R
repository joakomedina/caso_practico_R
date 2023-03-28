# Este es el scrip con el data frame para analizar los horarios de mayor actividad física según los registros de los dispositivos
# Este análisis se realiza con la base de datos hourlyCalories_merged.csv

hourly_activity <- read_csv("C:\\Users\\Joako\\Documents\\R_proyectos\\Caso_practico\\data_trabajo\\hourlyCalories_merged.csv") 
head(hourly_activity)

n_unique(hourly_activity$Id)

sum(duplicated(hourly_activity))

clean_names(hourly_activity)

hourly_activity <- rename_with(hourly_activity, tolower)


hourly_activity <- hourly_activity %>%
  rename(date = activityhour) %>%
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))
hourly_activity$time <- format(hourly_activity$date, format = "%H:%M:%S")
hourly_activity$date <- format(hourly_activity$date, format = "%m-%d-%y")

class(hourly_activity$date)

hourly_activity <- hourly_activity %>%
  group_by(time) %>%
  summarise(avg_intensity = mean(calories))


ggplot(data=hourly_activity, aes(x=time, y=avg_intensity)) + geom_bar(stat = "identity", fill= '#76b7b2')+
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Horas de mayor actividad física ",
       x = "Hora", y = "Gasto calorico medio")


