#Este script estoy realizando un análisis de intensidad vs calorías para hallar algún patron. La idea es comparar al sujeto contra si
# mismo en la quemada de calorías diarias. Este proceso debe hacer un merge entre min_intensities_narrow y min_calories_narrow
# como ya tengo intensities_calories procesada en otro analisis solo me queda procesar min_calories_narrow y hacer merge

# min_calories_narrow tiene id, date_minute, calories en promedio
# intensities_calories tiene id, date, time, calories, totalintensity sumatoria rango de 0-3, averageintensity


min_calories <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\caso_practico_R\\data\\minuteCaloriesNarrow_merged.csv")
head(min_calories)


### Limpieza, exploración de datos y registros, formateo y estandarización

###### Verificación registros de usuarios

n_unique(min_calories$Id)

###### Verificación de duplicados

sum(duplicated(min_calories))

###### Limpieza nombres de columnas

clean_names(min_calories)

###### Formateo a minúsculas 

min_calories <- rename_with(min_calories, tolower)

###### Formateo de la columna activity_date a tipo date y renombrado de columna a date y división de la columna date para que solo
###### tenga datos fecha y creación de columna time para que contenga el registro de tiempo
# renombro columna calories a averagecalories para hacer el merge

min_calories <- min_calories %>% 
  rename(date = activityminute) %>% 
  mutate(date = as.POSIXct(date,format ="%m/%d/%Y %I:%M:%S %p" , tz=Sys.timezone())) %>%
  rename(averagecalories = calories)
min_calories$time <- format(min_calories$date, format = "%H:%M:%S")
min_calories$date <- format(min_calories$date, format = "%m-%d-%y")


          #min_calories$date <- as.Date(strptime(min_calories$date, format = "%m-%d-%Y"))
          #class(min_calories$date)
          
          #min_calories$time <- as.ITime(min_calories$time, format = "%H:%M:%S")
          #class(min_calories$time)

          #class(min_calories$intensity)

calorias_mismo <- merge(min_calories, intensities_calories, by=c("id", "date", "time"))

# hasta aquí ya cree un data.frame a través de un merge de intensities_calories y min_calories_narrow

#group_total_calories <- calorias_mismo %>%
  #select(id, date, calories) %>%
  #group_by(id, date)%>%
  #summarise(totaldiaria = sum(calories), 
            #.groups = "drop")

group_calories <- calorias_mismo %>%
  select(id, date, calories) %>%
  group_by(id, date)%>%
  summarise(totaldiaria = sum(calories), 
            .groups = "drop")
            
# promedio calories diarias por id

#total_calories_id <- aggregate(totaldiaria ~ id + date, group_total_calories, mean)
#head(total_calories_id)  

calories_id <- aggregate(totaldiaria ~ id + date, group_calories, mean)
head(calories_id)  

# incluyo columna rendimiento para incluir cuando estan por encima o por debajo de su medía diaria de gasto calorico

# group_total_calories$rendimiento <- 
 # ifelse(group_total_calories$totaldiaria > total_calories_id$totaldiaria, "encima", "debajo")

group_calories$rendimiento <- 
  ifelse(group_calories$totaldiaria > calories_id$totaldiaria, "encima", "debajo")

resumen <- table(group_calories$id, group_calories$rendimiento)

resumen <- as.data.frame.matrix(resumen)
colnames(resumen) <- c("encima", "debajo")
resumen$id <- rownames(resumen)

# construir tabla larga


resumen_larga <- pivot_longer(resumen, cols =c("debajo", "encima"), names_to = "tipo", values_to ="dias")

write.csv(resumen_larga, "resumen_larga.csv", row.names = FALSE)
