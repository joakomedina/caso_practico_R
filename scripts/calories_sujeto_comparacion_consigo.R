
#### Creación de data.frame para el cálculo del consumo de calorías diarias
# La idea es poder contabilizar cuantas calorías diarias quema o consume cada persona y obtener un promedio de calorías 
# quemadas y establecer un patrón de comparación


intensity_calories <- 
  merge(min_intensities_narrow, min_calories_narrow, by=c ("id", "date"))
