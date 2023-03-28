

## Creación de data.frame sleep_day_df 
# Análisis patron de sueño y summary de variable

sleep_day <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\Caso_practico_R\\data\\sleepDay_merged.csv")
head(sleep_day)

### Limpieza, exploración de datos y registros, formateo y estandarización

###### Verificación registros de usuarios

n_unique(sleep_day$Id)

###### Verificación de duplicados

sum(duplicated(sleep_day))

###### Removiendo duplicados

sleep_day <- sleep_day %>%
  distinct() %>%
  drop_na()

###### Limpieza nombres de columnas

clean_names(sleep_day)

###### Formateo a minúsculas 

sleep_day <- rename_with(sleep_day, tolower)

###### Formateo de la columna activity_date a tipo date y renombrado de columna a date y división de la columna date para que solo
###### tenga datos fecha y creación de columna time para que contenga el registro de tiempo

sleep_day <- sleep_day %>%
  rename(date = sleepday)

sleep_day <- sleep_day %>%
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))

sleep_day$time <- format(sleep_day$date, format = "%H:%M:%S")
sleep_day$date <- format(sleep_day$date, format = "%m-%d-%y")

head(sleep_day)

sleep_day$date <- as.Date(strptime(sleep_day$date, format = "%m-%d-%Y"))
class(sleep_day$date)

sleep_day$time <- as.ITime(sleep_day$time, format = "%H:%M:%S")
class(sleep_day$time)

## Resúmen horas de sueño

sleep <- sleep_day %>%
  select( totalsleeprecords, totalminutesasleep, totaltimeinbed) %>%
  summary()
View(sleep)


