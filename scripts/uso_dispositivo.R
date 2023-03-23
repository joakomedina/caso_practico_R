install.packages("tidyverse")
install.packages("janitor")
install.packages("skimr")

library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
library(IRdisplay)

## Creación de data.frame daily_activity

daily_activity <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\Caso_practico_R\\data\\dailyActivity_merged.csv")
head(daily_activity)

### Limpieza, exploración de datos y registros, formateo y estandarización

###### Verificación registros de usuarios

n_unique(daily_activity$Id)

###### Verificación de duplicados

sum(duplicated(daily_activity))

###### Limpieza nombres de columnas

clean_names(daily_activity)

###### Formateo a minúsculas 

daily_activity <- rename_with(daily_activity, tolower)

###### Formateo de la columna activity_date a tipo date y renombrado de columna a date

daily_activity$activitydate <- mdy(daily_activity$activitydate)
class(daily_activity$activitydate)

daily_activity <- daily_activity %>%
  rename(date = activitydate)

head(daily_activity)

## Análisis de rango de uso de los dispositivos inteligentes

daily_minutes_used <- daily_activity %>%
  group_by(id, date) %>%
  mutate(minutesused = sum(veryactiveminutes, fairlyactiveminutes, lightlyactiveminutes, sedentaryminutes))

#### Filtrando sujetos informantes con 0 uso

daily_minutes_used %>%
  group_by(id, date) %>%
  filter(minutesused <= 1)

#### Descubriendo a los informantes con menor uso del dispositivo inteligente y destacando a aquellos un con un uso bajo. Son 5 personas

min_df_uso <- daily_minutes_used %>%
  group_by(date) %>%
  filter(minutesused == min(minutesused)) %>%
  select(id, date, minutesused) %>%
  arrange(date)

min_df_uso %>%
  group_by(date) %>%
  filter(minutesused <= 150) %>%
  select(id, date, minutesused) %>%
  arrange(date)
View(min_df_uso)

#### Construir una escala de uso

rango_uso <- daily_minutes_used %>%
  mutate(usertype = case_when(
    minutesused < 360 ~ "Bajo",
    minutesused >= 361 & minutesused < 719 ~ "Moderado",
    minutesused >= 720 & minutesused < 1079 ~ "Regular",
    minutesused >= 1080 ~ "Alto"
  )) 

##### Totalizar la escala

rango_uso_percent <- rango_uso %>%
  group_by(usertype) %>%
  summarise(total = n()) %>%
  mutate(totals = sum(total)) %>%
  group_by(usertype) %>%
  summarise(totalpercent = (total/totals)*100) %>%
  mutate(labels = paste(round(totalpercent, 2), "%"))

rango_uso_percent$usertype <- factor(rango_uso_percent$usertype, levels = c("Bajo", "Moderado", "Regular", "Alto"))
View(rango_uso_percent)

##### Descargar datos para construir gráfico de torta en Tableau

write.csv(rango_uso_percent, "rango_uso_percent.csv", row.names = FALSE)

#### Visualizar Rango de uso de los dispostivos inteligentes

display_png(file="C:/Users/Joako/Documents/R_curso_analisis_datos/Caso_practico_R/informe_jupyter/Imagenes/Porcentaje_uso.png")



