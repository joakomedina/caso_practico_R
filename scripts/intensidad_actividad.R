
## Creación de data.frame min_intensities_narrow

min_intensities_narrow <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\Caso_practico_R\\data\\minuteIntensitiesNarrow_merged.csv")
head(min_intensities_narrow)

### Limpieza, exploración de datos y registros, formateo y estandarización

###### Verificación registros de usuarios

n_unique(min_intensities_narrow$Id)

###### Verificación de duplicados

sum(duplicated(min_intensities_narrow))

###### Limpieza nombres de columnas

clean_names(min_intensities_narrow)

###### Formateo a minúsculas 

min_intensities_narrow <- rename_with(min_intensities_narrow, tolower)

###### Formateo de la columna activity_date a tipo date y renombrado de columna a date y división de la columna date para que solo
###### tenga datos fecha y creación de columna time para que contenga el registro de tiempo

min_intensities_narrow_3 <- min_intensities_narrow %>% 
  rename(date = activityminute) %>% 
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))

min_intensities_narrow_3$time <- format(min_intensities_narrow_3$date, format = "%H:%M:%S")
min_intensities_narrow_3$date <- format(min_intensities_narrow_3$date, format = "%m-%d-%Y")


min_intensities_narrow_3$date <- as.Date(strptime(min_intensities_narrow_3$date, format = "%m-%d-%Y"))
class(min_intensities_narrow_3$date)

min_intensities_narrow_3$time <- as.ITime(min_intensities_narrow_3$time, format = "%H:%M:%S")
class(min_intensities_narrow_3$time)

class(min_intensities_narrow_3$intensity)

## Análisis patron de intensidad

counts_0 <- min_intensities_narrow_3 %>%
  group_by(id) %>%
  summarise(intensity_0 = sum(intensity == 0))

counts_1 <- min_intensities_narrow_3 %>%
  group_by(id) %>%
  summarise(intensity_1 = sum(intensity == 1))

counts_2 <- min_intensities_narrow_3 %>%
  group_by(id) %>%
  summarise(intensity_2 = sum(intensity == 2))


counts_3 <- min_intensities_narrow_3 %>%
  group_by(id) %>%
  summarise(intensity_3 = sum(intensity == 3))


lista_df <- list(counts_0, counts_1, counts_2, counts_3)
escale_intensities_min <- Reduce(function(x, y) merge(x, y, by = c("id"), all = TRUE), lista_df)
                                 
escale_intensities_min %>%
  select(intensity_0, intensity_1, intensity_2, intensity_3) %>%
  summary()

# Media intensidad

escale_avg <- escale_intensities_min %>%
  select(intensity_0, intensity_1, intensity_2, intensity_3) %>%
  summarise(avg_0 = mean(intensity_0), avg_1 = mean(intensity_1), avg_2 = mean(intensity_2), avg_3 = mean(intensity_3))

escale_avg_long <- escale_avg %>%
  pivot_longer(cols = starts_with("avg"), names_to = "intensity", values_to = "mean")


write.csv(escale_avg_long, "escale_avg_long.csv", row.names = FALSE)

                                 
