# =============================================================================
# GUÍA COMPLETA DE LOOPS EN R
# 
# Este script muestra diferentes tipos de loops en R incluyendo:
# - For loops simples
# - For loops anidados (2 y 3 niveles)
# - While loops
# - Funciones map del paquete purrr
# =============================================================================

# =============================================================================
# 1. FOR LOOPS BÁSICOS
# =============================================================================

cat("\n\n================ 1. FOR LOOPS BÁSICOS ================\n\n")

# Ejemplo con vector
cat("-- Ejemplo con vector numérico --\n")
numeros <- c(2, 4, 6, 8, 10)
suma <- 0

for (num in numeros) {
  suma <- suma + num
  print(paste("Sumando", num, "- Suma actual:", suma))
}

print(paste("Suma final:", suma))

# Ejemplo con secuencia
cat("\n-- Ejemplo con secuencia --\n")
for (i in seq(1, 10, by = 2)) {
  resultado <- i^2
  print(paste("El cuadrado de", i, "es", resultado))
}

# Ejemplo con índices
cat("\n-- Ejemplo con índices para acceder a elementos --\n")
nombres <- c("Ana", "Carlos", "Elena", "David", "Beatriz")
i <- 1
for (i in 1:length(nombres)) {
  print(paste("Persona", i, ":", nombres[i]))
  
  # Añadir una nota si el nombre empieza por una vocal
  if (substr(nombres[i], 1, 1) %in% c("A", "E", "I", "O", "U")) {
    print("  (Este nombre comienza con vocal)")
  } else {
   print('  (Este nombre no comienza con vocal)')
  }
}

# Version con strinr

for (i in 1:length(nombres)) {
  print(paste("Persona", i, ":", nombres[i]))
  
  # Añadir una nota si el nombre empieza por una vocal
  if (stringr::str_extract(nombres[i], '^[A-Z]') %in% c("A", "E", "I", "O", "U")) {
    print("  (Este nombre comienza con vocal)")
  } else {
    print('  (Este nombre no comienza con vocal)')
  }
}

# =============================================================================
# 2. FOR LOOPS ANIDADOS
# =============================================================================

cat("\n\n================ 2. FOR LOOPS ANIDADOS ================\n\n")

# Loop anidado de 2 niveles
cat("-- Loop anidado de 2 niveles: Tabla de multiplicación 5x5 --\n\n")

for (i in 1:5) {
  fila <- ""
  for (j in 1:5) {
    # Formateamos para alinear los números
    producto <- i * j
    fila <- paste(fila, sprintf("%3d", producto))
  }
  cat(fila, "\n") # Concatena los datos separados por un parrafo
  Sys.sleep(2) # Para que entre cada iteracion espere 2 segundos
}

# ¿que es sprintf? 
# d stands for decimal integer (not double!), so it says there will be no floating point or anything like that, just a regular integer.
# 3 shows how many digits will the printed number have. More precisely, the number will take at least
# link a explicacion: https://stackoverflow.com/questions/23718936/explanation-for-sprintf03d-7-functionality


# Loop anidado de 3 niveles
cat("\n-- Loop anidado de 3 niveles: Simulación dados --\n")
cat("Simulamos juegos con diferentes dados, caras y tiradas\n\n")

resultados <- list()

for (num_dados in 1:3) {
  for (caras in c(4, 6, 8)) {
    for (tiradas in 1:3) {
      # Simulamos las tiradas de dados
      set.seed(123 + num_dados + caras + tiradas)  # Para reproducibilidad
      
      # Generamos todas las tiradas
      todas_tiradas <- replicate(tiradas, sum(sample(1:caras, num_dados, replace = TRUE)))
      
      # Guardamos resultados
      info <- list(
        dados = num_dados,
        caras_por_dado = caras,
        num_tiradas = tiradas,
        resultados_tiradas = todas_tiradas,
        promedio = mean(todas_tiradas)
      )
      
      # Añadimos al listado general
      resultados[[length(resultados) + 1]] <- info
      
      # Mostramos resultado
      cat(sprintf("Con %d dado(s) de %d caras, en %d tirada(s): promedio = %.2f\n", 
                  num_dados, caras, tiradas, info$promedio))
    }
  }
}

# =============================================================================
# 3. WHILE LOOPS
# =============================================================================

cat("\n\n================ 3. WHILE LOOPS ================\n\n")

# Ejemplo básico de while
cat("-- Ejemplo básico: Crecimiento poblacional --\n")
poblacion_inicial <- 100
tasa_crecimiento <- 0.05
anos <- 0
poblacion_actual <- poblacion_inicial

while (poblacion_actual < 200) {
  anos <- anos + 1
  poblacion_actual <- poblacion_actual + (poblacion_actual * tasa_crecimiento)
  print(paste("Año", anos, "- Población:", round(poblacion_actual)))
}

print(paste("Se necesitaron", anos, "años para duplicar la población inicial."))

anios_loop <- c()
for(i in 1:1000){
  poblacion_inicial <- 100
  anos <- 0
  poblacion_actual <- poblacion_inicial
  while (poblacion_actual < 200) {
    anos <- anos + 1
    tasa_crecimiento <- runif(1,0,0.1)
    poblacion_actual <- poblacion_actual + (poblacion_actual * tasa_crecimiento)
  }
  anios_loop <- c(anios_loop,anos)
}
mean(anios_loop)


# Ejemplo con break
cat("\n-- Ejemplo con break: Lanzamiento de moneda --\n")
set.seed(42)  # Para reproducibilidad
lanzamientos <- 0
caras_consecutivas <- 0

while (TRUE) {
  lanzamientos <- lanzamientos + 1
  resultado <- sample(c("cara", "cruz"), 1)
  
  if (resultado == "cara") {
    caras_consecutivas <- caras_consecutivas + 1
    cat("Lanzamiento", lanzamientos, ": cara (", caras_consecutivas, "caras consecutivas)\n")
  } else {
    caras_consecutivas <- 0
    cat("Lanzamiento", lanzamientos, ": cruz (reinicio contador de caras)\n")
  }
  
  # Condición de salida
  if (caras_consecutivas >= 3) {
    cat("\n¡Conseguimos 3 caras consecutivas después de", lanzamientos, "lanzamientos!\n")
    break
  }
  
  # Prevención de loops infinitos (solo para este ejemplo)
  if (lanzamientos >= 100) {
    cat("\nDetuvimos después de 100 intentos sin conseguir 3 caras consecutivas.\n")
    break
  }
}

# =============================================================================
# 4. FUNCIONES MAP DEL PAQUETE PURRR
# =============================================================================

cat("\n\n================ 4. FUNCIONES MAP DEL PAQUETE PURRR ================\n\n")

# Primero, instalamos y cargamos el paquete si no lo tenemos
if (!require(purrr)) {
  install.packages("purrr")
}
library(purrr)

# Ejemplo simple: map para aplicar función a cada elemento
cat("-- Ejemplos básicos de map --\n")
numeros <- c(1, 2, 3, 4, 5)

# Usando map (devuelve una lista)
resultados <- map(numeros, function(x) {
  return(list(
    original = x,
    cuadrado = x^2,
    cubo = x^3
  ))
})

# Mostramos los resultados
print("Resultado de map (lista):")
print(resultados)

# Usando map_dbl (devuelve un vector numérico)
cuadrados <- map_dbl(numeros, ~ .x^2)
print("Resultado de map_dbl (vector numérico):")
print(cuadrados)


# Uso de map para cargar múltiples archivos
cat("\n-- Uso de map para cargar múltiples archivos --\n")

# Creamos archivos de ejemplo (normalmente ya los tendrías)
dir.create("datos_ejemplo", showWarnings = FALSE)

# Creamos 3 archivos CSV de muestra
for (i in 1:3) {
  df <- data.frame(
    id = 1:5,
    valor = runif(5, 0, 100),
    grupo = sample(LETTERS[1:3], 5, replace = TRUE)
  )
  write.csv(df, file = paste0("datos_ejemplo/datos_", i, ".csv"), row.names = FALSE)
}

# Instalamos readr si no lo tenemos
if (!require(readr)) {
  install.packages("readr")
}
library(readr)

# Obtenemos la lista de archivos CSV
archivos_csv <- list.files(path = "datos_ejemplo", 
                           pattern = "*.csv", 
                           full.names = TRUE)
print("Archivos creados:")
print(archivos_csv)

# Usando map para leer todos los archivos
datos_combinados <- map_df(archivos_csv, function(archivo) {
  # Leemos el archivo
  datos <- read_csv(archivo, show_col_types = FALSE)
  
  # Añadimos el nombre del archivo como columna para identificar el origen
  datos$archivo_origen <- basename(archivo)
  
  return(datos)
})

# Mostramos el resultado
print("Datos combinados usando map_df:")
print(datos_combinados)

# Comparación con for loop
cat("\n-- Comparación con for loop --\n")
datos_for_loop <- data.frame()

for (archivo in archivos_csv) {
  # Leemos el archivo
  datos <- read_csv(archivo, show_col_types = FALSE)
  
  # Añadimos el nombre del archivo como columna
  datos$archivo_origen <- basename(archivo)
  
  # Combinamos con los datos anteriores
  if (nrow(datos_for_loop) == 0) {
    datos_for_loop <- datos
  } else {
    datos_for_loop <- rbind(datos_for_loop, datos)
  }
  print(i)
}

# Comprobamos que obtenemos resultados similares
View(datos_for_loop)
View(datos_combinados)

# =============================================================================
# 5. CONSEJOS Y BUENAS PRÁCTICAS
# =============================================================================

cat("\n\n================ 5. CONSEJOS Y BUENAS PRÁCTICAS ================\n\n")

# 1. Pre-asignar memoria cuando sea posible
cat("-- 1. Pre-asignar memoria para mejorar rendimiento --\n")
n <- 10000

# Medimos tiempo para método lento (creciendo vector)
cat("Método lento (reasignando vector en cada iteración):\n")
tiempo_inicio <- Sys.time()
resultados_lento <- c()
for (i in 1:n) {
  resultados_lento <- c(resultados_lento, i^2)
}
tiempo_fin <- Sys.time()
print(paste("Tiempo:", tiempo_fin - tiempo_inicio))

# Medimos tiempo para método rápido (preasignación)
cat("\nMétodo rápido (pre-asignando memoria):\n")
tiempo_inicio <- Sys.time()
resultados_rapido <- numeric(n)
for (i in 1:n) {
  resultados_rapido[i] <- i^2
}
tiempo_fin <- Sys.time()
print(paste("Tiempo:", tiempo_fin - tiempo_inicio))

# 2. Considerar alternativas vectorizadas
cat("\n-- 2. Considerar alternativas vectorizadas cuando sea posible --\n")
numeros <- 1:10000

# Usando loop
cat("Usando loop:\n")
tiempo_inicio <- Sys.time()
resultado1 <- numeric(length(numeros))
for (i in 1:length(numeros)) {
  resultado1[i] <- numeros[i]^2
}
tiempo_fin <- Sys.time()
print(paste("Tiempo:", tiempo_fin - tiempo_inicio))

# Usando operaciones vectorizadas
cat("\nUsando operación vectorizada:\n")
tiempo_inicio <- Sys.time()
resultado2 <- numeros^2
tiempo_fin <- Sys.time()
print(paste("Tiempo:", tiempo_fin - tiempo_inicio))

# 3. Usar funciones apply/map
cat("\n-- 3. Usar funciones apply/map con dataframes --\n")
data(mtcars)
print("Primeras filas de mtcars:")
print(head(mtcars))

# Calcular la media de cada columna numérica
cat("\nMedias de columnas usando map_dbl:\n")
medias_columnas <- map_dbl(mtcars, mean)
print(medias_columnas)

cat("\nMedias de columnas usando un for loop:\n")
medias_for <- numeric(ncol(mtcars))
nombres_col <- names(mtcars)
i <- 1
for (i in 1:ncol(mtcars)) {
  medias_for[i] <- mean(mtcars[,i])
}
names(medias_for) <- nombres_col
print(medias_for)

# =============================================================================
# 6. NORMALIZACIÓN Y ESTANDARIZACIÓN DE DATOS
# =============================================================================

cat("\n\n================ 6. NORMALIZACIÓN Y ESTANDARIZACIÓN DE DATOS ================\n\n")

library(tidyverse)

# Creamos un conjunto de datos de ejemplo
set.seed(123)
datos_ejemplo <- data.frame(
  id = 1:10,
  valor1 = rnorm(10, mean = 50, sd = 10),
  valor2 = runif(10, min = 0, max = 100),
  valor3 = rpois(10, lambda = 5),
  categoria = sample(letters[1:3], 10, replace = TRUE)
)

cat("Datos originales:\n")
print(datos_ejemplo)

# Definimos funciones para normalización y estandarización
# Normalización: escala los valores entre 0 y 1
normalizar <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

# Estandarización: transforma a z-scores (media=0, sd=1)
estandarizar <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

# 1. Usando loops tradicionales
cat("\n-- 1. Normalización y estandarización usando loops tradicionales --\n")

# Identificamos las columnas numéricas
columnas_numericas <- sapply(datos_ejemplo, is.numeric)
columnas_numericas <- columnas_numericas & names(datos_ejemplo) != "id"  # Excluimos la columna ID
nombres_columnas_num <- names(datos_ejemplo)[columnas_numericas]

# Creamos dataframes para almacenar los resultados
datos_norm_loop <- datos_ejemplo
datos_std_loop <- datos_ejemplo

# Normalización con loop
for (col in nombres_columnas_num) {
  nuevo_nombre <- paste0(col, "_norm")
  datos_norm_loop[[nuevo_nombre]] <- normalizar(datos_ejemplo[[col]])
}

# Estandarización con loop
for (col in nombres_columnas_num) {
  nuevo_nombre <- paste0(col, "_std")
  datos_std_loop[[nuevo_nombre]] <- estandarizar(datos_ejemplo[[col]])
}

# Otra opcion 
# Iniciamos con el dataframe original
datos_std_iterativo <- datos_ejemplo

# Iteramos por cada columna y aplicamos mutate() en cada paso
for (col in nombres_columnas_num) {
  nuevo_nombre <- paste0(col, "_std")
  
  # Usamos !! y := para evaluación no estándar dentro de mutate
  datos_std_iterativo <- datos_std_iterativo %>%
    mutate(!!nuevo_nombre := estandarizar(.data[[col]]))
}

cat("Resultado de normalización con loop:\n")
print(datos_norm_loop)

cat("\nResultado de estandarización con loop:\n")
print(datos_std_loop)

# 2. Usando funciones map de purrr
cat("\n-- 2. Normalización y estandarización usando map de purrr --\n")

# Normalización con map
datos_norm_map <- datos_ejemplo %>%
  bind_cols(
    map_dfc(nombres_columnas_num, function(col) {
      # Creamos un dataframe de una columna con el resultado normalizado
      df_col <- tibble::tibble(!!paste0(col, "_norm") := normalizar(datos_ejemplo[[col]]))
      return(df_col)
    })
  )

# Estandarización con map
datos_std_map <- datos_ejemplo %>%
  bind_cols(
    map_dfc(nombres_columnas_num, function(col) {
      # Creamos un dataframe de una columna con el resultado estandarizado
      df_col <- tibble::tibble(!!paste0(col, "_std") := estandarizar(datos_ejemplo[[col]]))
      return(df_col)
    })
  )

cat("Resultado de normalización con map:\n")
print(datos_norm_map)

cat("\nResultado de estandarización con map:\n")
print(datos_std_map)

# 3. Usando mutate_at de dplyr
cat("\n-- 3. Normalización y estandarización usando mutate_at de dplyr --\n")

# Normalización con mutate_at
datos_norm_mutate <- datos_ejemplo %>%
  mutate_at(vars(nombres_columnas_num), 
            list(norm = normalizar))

# Estandarización con mutate_at
datos_std_mutate <- datos_ejemplo %>%
  mutate_at(vars(nombres_columnas_num), 
            list(std = estandarizar))

cat("Resultado de normalización con mutate_at:\n")
print(datos_norm_mutate)

cat("\nResultado de estandarización con mutate_at:\n")
print(datos_std_mutate)

# 4. Usando mutate_if (alternativa a mutate_at)
cat("\n-- 4. Normalización y estandarización usando mutate_if de dplyr --\n")

# Definimos una condición personalizada para seleccionar columnas numéricas excepto id
es_numerico_excepto_id <- function(x) {
  is.numeric(x) && !identical(x, datos_ejemplo$id)
}

# Normalización con mutate_if
datos_norm_if <- datos_ejemplo %>%
  mutate_if(es_numerico_excepto_id, 
            list(norm = normalizar)) %>%
  select(-id)  # Eliminamos la columna id_norm que no queremos

# Estandarización con mutate_if
datos_std_if <- datos_ejemplo %>%
  mutate_if(es_numerico_excepto_id, 
            list(std = estandarizar)) %>%
  select(-id)  # Eliminamos la columna id_std que no queremos

cat("Resultado de normalización con mutate_if:\n")
print(datos_norm_if)

cat("\nResultado de estandarización con mutate_if:\n")
print(datos_std_if)

# 5. Usando across (más moderno, reemplaza a mutate_at/mutate_if en dplyr reciente)
cat("\n-- 5. Normalización y estandarización usando across de dplyr --\n")

# Normalización con across
datos_norm_across <- datos_ejemplo %>%
  mutate(across(all_of(nombres_columnas_num), 
                list(norm = normalizar), 
                .names = "{.col}_{.fn}"))

# Estandarización con across
datos_std_across <- datos_ejemplo %>%
  mutate(across(all_of(nombres_columnas_num), 
                list(std = estandarizar), 
                .names = "{.col}_{.fn}"))

# Estandarización con ambos
datos_std_across <- datos_ejemplo %>%
  mutate(across(all_of(nombres_columnas_num), 
                list(norm = normalizar,
                     std = estandarizar,
                     sum = sum,
                     sd = sd,
                     max = max), 
                .names = "{.col}_{.fn}"))

cat("Resultado de normalización con across:\n")
print(datos_norm_across)

cat("\nResultado de estandarización con across:\n")
print(datos_std_across)

cat("\n\n================ Fin. ================\n\n")