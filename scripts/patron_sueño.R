
## Creación de data.frame sleep_day_df evaluar el patron de sueño y si hay relación entre el los registros de sueño (siesta)
# y la actividad física

sleep_day_df <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\Caso_practico_R\\data\\sleepDay_merged.csv")
head(sleep_day_df)

### Limpieza, exploración de datos y registros, formateo y estandarización

###### Verificación registros de usuarios

n_unique(sleep_day_df$Id)

###### Verificación de duplicados

sum(duplicated(sleep_day_df))

###### Removiendo duplicados

sleep_day_df <- sleep_day_df %>%
  distinct() %>%
  drop_na()

###### Limpieza nombres de columnas

clean_names(sleep_day_df)

###### Formateo a minúsculas 

sleep_day_df <- rename_with(sleep_day_df, tolower)

###### Formateo de la columna activity_date a tipo date y renombrado de columna a date y división de la columna date para que solo
###### tenga datos fecha y creación de columna time para que contenga el registro de tiempo

sleep_day_df <- sleep_day_df %>%
  rename(date = sleepday)

sleep_day_df <- sleep_day_df %>%
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))

sleep_day_df$time <- format(sleep_day_df$date, format = "%H:%M:%S")
sleep_day_df$date <- format(sleep_day_df$date, format = "%m-%d-%y")

head(sleep_day_df)

## Resúmen horas de sueño

sleep <- sleep_day_df %>%
  select( totalsleeprecords, totalminutesasleep, totaltimeinbed) %>%
  summary()
View(sleep)


