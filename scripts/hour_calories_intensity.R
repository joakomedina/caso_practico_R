# Con este análisis vemos los minutos de intensidad en cada hora de actividad física

hourly_intensities <- read_csv("C:\\Users\\Joako\\Documents\\R_proyectos\\Caso_practico\\data_trabajo\\hourlyIntensities_merged.csv")
head(hourly_intensities)

n_unique(hourly_intensities$Id)

sum(duplicated(hourly_intensities))

clean_names(hourly_intensities)

hourly_intensities <- rename_with(hourly_intensities, tolower)


hourly_intensities <- hourly_intensities %>%
  rename(date = activityhour) %>%
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))
hourly_intensities$time <- format(hourly_intensities$date, format = "%H:%M:%S")
hourly_intensities$date <- format(hourly_intensities$date, format = "%m-%d-%y")

class(hourly_intensities$date)

hourly_activity <- hourly_intensities %>%
  group_by(time) %>%
  summarise(avg_intensity = mean(totalintensity))

ggplot(hourly_activity, aes(x = time, y = avg_intensity)) +
  geom_bar(stat = "identity", fill = "#76b7b2") +
  labs(title = "Patron de minutos de mayor intensidad en horas de mayor actividad ",
       x = "Hora", y = "Avg de minutos de intensidad")
