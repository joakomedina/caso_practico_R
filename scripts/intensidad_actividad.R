
## Creación de data.frame min_intensities_narrow para estimar tiempo de intensidad física minutos vs intensidad

min_intensities <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\Caso_practico_R\\data\\minuteIntensitiesNarrow_merged.csv")
head(min_intensities_narrow)

### Limpieza, exploración de datos y registros, formateo y estandarización

###### Verificación registros de usuarios

n_unique(min_intensities$Id)

###### Verificación de duplicados

sum(duplicated(min_intensities))

###### Limpieza nombres de columnas

clean_names(min_intensities)

###### Formateo a minúsculas 

min_intensities <- rename_with(min_intensities, tolower)

###### Formateo de la columna activity_date a tipo date y renombrado de columna a date y división de la columna date para que solo
###### tenga datos fecha y creación de columna time para que contenga el registro de tiempo

min_intensities <- min_intensities %>% 
  rename(date = activityminute) %>% 
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone()))

min_intensities$time <- format(min_intensities$date, format = "%H:%M:%S")
min_intensities$date <- format(min_intensities$date, format = "%m-%d-%Y")


min_intensities$date <- as.Date(strptime(min_intensities$date, format = "%m-%d-%Y"))
class(min_intensities$date)

min_intensities$time <- as.ITime(min_intensities$time, format = "%H:%M:%S")
class(min_intensities$time)

class(min_intensities$intensity)

## Análisis patron de intensidad

counts_0 <- min_intensities %>%
  group_by(id) %>%
  summarise(intensity_0 = sum(intensity == 0))

counts_1 <- min_intensities %>%
  group_by(id) %>%
  summarise(intensity_1 = sum(intensity == 1))

counts_2 <- min_intensities %>%
  group_by(id) %>%
  summarise(intensity_2 = sum(intensity == 2))


counts_3 <- min_intensities %>%
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

ggplot(escale_avg_long, aes(x = intensity, y = mean)) +
  geom_bar(stat = "identity", fill = "#76b7b2") +
  labs(title = "Relación entre tiempo e intensidad de la actividad física",
       x = "Intensidad de la actividad física", y = "Promedio de minutos mensual")

                                 
