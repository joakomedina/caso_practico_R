# Creación data.frame hourly intensities
# Con este análisis vemos el patron de horas de mayor actividad física
# Este es el data frame para las horas según la intensidad pero también para juntarlo con hourly_activity y construir una relación
# entre intensidad y gasto calórico en un nuevo data.frame llamado intensities_calories

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

# puede ser un calculo junto a un gráfico para reforzar el patrón de horas de actividad

intensities <- hourly_intensities %>%
  group_by(time) %>%
  summarise(avg_intensity = mean(averageintensity))

ggplot(intensities, aes(x = time, y = avg_intensity)) +
  geom_bar(stat = "identity", fill = "#76b7b2") +
  theme(axis.text.x = element_text(angle = 45))+
  labs(title = "Patron de horas de mayor actividad física ",
       x = "Tiempo en horas", y = "Promedio de intensidad")


