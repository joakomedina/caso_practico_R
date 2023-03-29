
# Este es el scrip con el data frame para analizar los horarios de mayor actividad física según los registros de los dispositivos
# Este análisis se realiza con la base de datos hourlyCalories_merged.csv
# El énfasis esta en el promedio de gasto calórico durante el día en cada hora

# Sin embargo la mayor utilidad de este data frame es la combinación con hourly_intensity para establecer una 
# relación entre la intensidad de la actividad física y el gasto calórico

hourly_calories <- read_csv("C:\\Users\\Joako\\Documents\\R_proyectos\\Caso_practico\\data_trabajo\\hourlyCalories_merged.csv") 
head(hourly_calories)

n_unique(hourly_calories$Id)

sum(duplicated(hourly_calories))

clean_names(hourly_calories)

hourly_calories <- rename_with(hourly_calories, tolower)


hourly_calories <- hourly_calories %>%
  rename(date = activityhour) %>%
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))
hourly_calories$time <- format(hourly_calories$date, format = "%H:%M:%S")
hourly_calories$date <- format(hourly_calories$date, format = "%m-%d-%y")


# Hasta aqui el formateo con columnas date y time en formato Date y ITime
# El siguiente análisis no me dice nada diferente que hourly_intensities con lo cuál:
  # El summarise creo que no es útil, me lleva a un gráfico final igual que el de hourly_intensities pero desde las calorías
  # Puedo hacer un merge con hourly_intensities para relacionar intensidad con gasto calórico.

hourly <- hourly_calories %>%
  group_by(time) %>%
  summarise(avg_intensity = mean(calories))
  
# No es necesario a menos que vuelva ITime la columna time antes, es por ello que después del merge es que las voy a volver time
      # Me da un error en el gráfico para una escala automatica con objetos de type ITime 
      # error: Don't know how to automatically pick scale for object of type <ITime>. Defaulting to continuous.
      # cambio a time posicxct

# hourly$time <- as.POSIXct(hourly$time, format = "%H:%M:%S")

ggplot(hourly, aes(x=time, y= avg_intensity)) + 
  geom_bar(stat = "identity", fill= '#76b7b2')+
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Horas de mayor actividad física ",
       x = "Hora", y = "Gasto calorico medio")


# Merge con hourly

intensities_calories <- merge(hourly_calories, hourly_intensities, by =c("id", "date", "time"))
class(intensities_calories$date)
class(intensities_calories$time)

        # Ponerlo en suspenso a menos que sea necesario para el análisis         
          ## hourly_activity$date <- as.Date(strptime(hourly_activity$date, format = "%m-%d-%Y"))
          ## class(hourly_activity$date)
          
          ## hourly_activity$time <- as.ITime(hourly_activity$time, format = "%H:%M:%S")
          ## class(hourly_activity$time)


ggplot(data=intensities_calories)+
  geom_smooth(mapping = aes(x=calories, y= averageintensity), color="#76b7b2")+
  labs(title = "Relación entre la intensidad de la actividad física y el gasto calórico",
       x = "Gasto Calórico", y = "Intensidad de actividad")
