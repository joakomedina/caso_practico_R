#Este script estoy realizando un análisis de intensidad vs calorías para hallar algún patron. La idea es comparar al sujeto contra si
# mismo en la quemada de calorías diarias. Este proceso debe hacer un merge entre min_intensities_narrow y min_calories_narrow
# como ya tengo min_intensities_narrow procesada en otro analisis solo me queda procesar min_calories_narrow


min_calories_narrow <- 
  read_csv("C:\\Users\\Joako\\Documents\\R_curso_analisis_datos\\caso_practico_R\\data\\minuteCaloriesNarrow_merged.csv")

