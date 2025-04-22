# =============================================================================
# EXPLORATORY DATA ANALYSIS (EDA) CON EL DATASET DE BOSTON
# =============================================================================

# Este script demuestra un análisis exploratorio de datos completo 
# utilizando el conjunto de datos de Boston Housing, combinando
# enfoques manuales con el tidyverse y herramientas automatizadas.

# =============================================================================
# 1. CARGAR PAQUETES NECESARIOS
# =============================================================================

# Paquetes básicos de Tidyverse
library(tidyverse)     # Para manipulación y visualización de datos
library(MASS)          # Para el dataset de Boston

# Paquetes específicos para EDA
library(DataExplorer)  # Para EDA automatizado
library(GGally)        # Para gráficos multivariados
library(corrplot)      # Para visualización de correlaciones
library(skimr)         # Para estadísticas descriptivas mejoradas
library(moments)       # Para calcular asimetría (skewness) y curtosis

# Para dividir la pantalla en múltiples gráficos
library(gridExtra)     # Para organizar múltiples gráficos
library(cowplot)       # Alternativa para combinar gráficos

# =============================================================================
# 2. CARGAR Y ENTENDER LOS DATOS
# =============================================================================

# Cargar el conjunto de datos de Boston
data(Boston)

# Convertir a tibble para una mejor visualización
boston_tbl <- as_tibble(Boston)
View(head(boston_tbl,1000)) # para abrir las primeras 1000 filas
dim(boston_tbl)

# Examinar las primeras filas del conjunto de datos
print("Primeras filas del conjunto de datos:")
head(boston_tbl)

# Comprender la estructura del conjunto de datos
print("Estructura del conjunto de datos:")
glimpse(boston_tbl)

# Nota sobre el conjunto de datos de Boston:
# Este dataset contiene información sobre valores de viviendas en suburbios de Boston
# con varias características como tasas de criminalidad, acceso a carreteras, etc.

# Documentación sobre las variables (información contextual)
cat("
VARIABLES DEL DATASET DE BOSTON:
- crim: tasa de criminalidad per cápita por ciudad
- zn: proporción de terrenos residenciales zonificados para lotes mayores a 25,000 sq.ft
- indus: proporción de acres comerciales no minoristas por ciudad
- chas: variable ficticia del río Charles (= 1 si el tramo limita con el río; 0 en caso contrario)
- nox: concentración de óxidos de nitrógeno (partes por 10 millones)
- rm: número promedio de habitaciones por vivienda
- age: proporción de unidades ocupadas por sus propietarios construidas antes de 1940
- dis: distancias ponderadas a cinco centros de empleo de Boston
- rad: índice de accesibilidad a carreteras radiales
- tax: tasa de impuesto a la propiedad de valor total por $10,000
- ptratio: proporción alumno-profesor por ciudad
- black: 1000(Bk - 0.63)^2 donde Bk es la proporción de personas de raza negra por ciudad
- lstat: porcentaje de población de 'estatus bajo'
- medv: valor mediano de las viviendas ocupadas por sus propietarios en $1000
")

# =============================================================================
# 3. EVALUACIÓN DE LA CALIDAD DE LOS DATOS
# =============================================================================

# Verificar valores faltantes
print("Valores faltantes por columna:")
colSums(is.na(boston_tbl))

# Verificar valores duplicados
print("Número de filas duplicadas:")
sum(duplicated(boston_tbl))

# Estadísticas resumidas básicas
print("Estadísticas resumidas:")
summary(boston_tbl)

# Estadísticas detalladas con skimr (paquete especializado)
print("Informe detallado con skimr:")
skim(boston_tbl)

# Con paquete summarytools
summarytools::dfSummary(boston_tbl)

# =============================================================================
# 4. ANÁLISIS UNIVARIANTE: VARIABLES NUMÉRICAS
# =============================================================================

# Función para crear un conjunto completo de gráficos univariados
crear_graficos_univariados <- function(data, variable) {
  # Histograma
  p1 <- ggplot(data, aes(x = .data[[variable]])) +
    geom_histogram(bins = 30, fill = "steelblue", color = "white") +
    labs(title = paste("Histograma de", variable)) +
    theme_minimal()
  
  # Densidad
  p2 <- ggplot(data, aes(x = .data[[variable]])) +
    geom_density(fill = "steelblue", alpha = 0.5) +
    labs(title = paste("Densidad de", variable)) +
    theme_minimal()
  
  # Boxplot
  p3 <- ggplot(data, aes(y = .data[[variable]])) +
    geom_boxplot(fill = "steelblue") +
    labs(title = paste("Boxplot de", variable), x = "") +
    theme_minimal()
  
  # QQ Plot para verificar normalidad
  p4 <- ggplot(data, aes(sample = .data[[variable]])) +
    stat_qq() +
    stat_qq_line() +
    labs(title = paste("QQ Plot de", variable)) +
    theme_minimal()
  
  # Combinar gráficos
  grid.arrange(p1, p2, p3, p4, ncol = 2)
  
  # Calcular estadísticas de forma
  skew <- skewness(data[[variable]])
  kurt <- kurtosis(data[[variable]])
  
  cat("\nEstadísticas para", variable, ":\n")
  cat("Media:", mean(data[[variable]]), "\n")
  cat("Mediana:", median(data[[variable]]), "\n")
  cat("Desviación estándar:", sd(data[[variable]]), "\n")
  cat("Rango intercuartílico:", IQR(data[[variable]]), "\n")
  cat("Asimetría:", skew, "(>0 = asimetría positiva, <0 = asimetría negativa)\n")
  cat("Curtosis:", kurt, "(>3 = leptocúrtica, <3 = platicúrtica)\n")
}

# Analizar la variable objetivo 'medv' (valor mediano de las viviendas)
crear_graficos_univariados(boston_tbl, "medv")

# Analizar una variable predictora importante como 'lstat' 
# (porcentaje de población de estatus bajo)
crear_graficos_univariados(boston_tbl, "lstat")

# Analizar 'rm' (número promedio de habitaciones)
crear_graficos_univariados(boston_tbl, "rm")

# Analizar 'crim' (tasa de criminalidad)
crear_graficos_univariados(boston_tbl, "crim")

# Para examinar chas (variable binaria/categórica)
cat("\nDistribución de la variable chas (proximidad al río Charles):\n")
table(boston_tbl$chas)
prop.table(table(boston_tbl$chas))

ggplot(boston_tbl, aes(x = factor(chas))) +
  geom_bar(fill = "steelblue") +
  labs(title = "Distribución de chas", 
       x = "Limita con el río Charles", 
       y = "Frecuencia") +
  scale_x_discrete(labels = c("No (0)", "Sí (1)")) +
  theme_minimal()

# =============================================================================
# 5. ANÁLISIS BIVARIANTE
# =============================================================================

# Examinar la relación entre 'lstat' y 'medv'
ggplot(boston_tbl, aes(x = lstat, y = medv)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", color = "red") + # https://r-statistics.co/Loess-Regression-With-R.html
  labs(title = "Relación entre estatus socioeconómico y valor de viviendas",
       x = "% Población de estatus bajo (lstat)",
       y = "Valor mediano de viviendas en $1000 (medv)") +
  theme_minimal()

# Examinar la relación entre 'rm' y 'medv'
ggplot(boston_tbl, aes(x = rm, y = medv)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") + #https://r-statistics.co/Loess-Regression-With-R.html
  labs(title = "Relación entre número de habitaciones y valor de viviendas",
       x = "Número promedio de habitaciones (rm)",
       y = "Valor mediano de viviendas en $1000 (medv)") +
  theme_minimal()

# Boxplot de 'medv' por 'chas' (categórica vs numérica)
ggplot(boston_tbl, aes(x = factor(chas), y = medv, fill = factor(chas))) +
  geom_boxplot() +
  labs(title = "Valor de viviendas según proximidad al río Charles",
       x = "Limita con el río Charles",
       y = "Valor mediano de viviendas en $1000 (medv)") +
  scale_x_discrete(labels = c("No", "Sí")) +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal() +
  theme(legend.position = "none")

# Calcular matriz de correlación
cor_matrix <- cor(boston_tbl)
print("Matriz de correlación:")
print(round(cor_matrix, 2))

# Visualizar la matriz de correlación con corrplot
corrplot.mixed(cor_matrix,  
         tl.col = "black", tl.srt = 45, 
         title = "Matriz de correlación de variables de Boston")

# Identificar las variables más correlacionadas con 'medv'
cor_with_medv <- cor_matrix[, "medv"]
cor_with_medv <- cor_with_medv[order(abs(cor_with_medv), decreasing = TRUE)]
cor_with_medv <- cor_with_medv[cor_with_medv != 1]  # Excluir autocorrelación
print("Variables más correlacionadas con el valor de las viviendas (medv):")
print(round(cor_with_medv[1:5], 3))

# =============================================================================
# 6. ANÁLISIS MULTIVARIANTE
# =============================================================================

# Gráfico de pares para variables seleccionadas
variables_clave <- c("medv", "lstat", "rm", "ptratio", "crim")
GGally::ggpairs(
  boston_tbl[, variables_clave],
  title = "Gráfico de pares para variables clave"
)

# Análisis de Componentes Principales (PCA)
# Escalar los datos primero
boston_scaled <- scale(boston_tbl)
pca_result <- prcomp(boston_scaled)

# Resumen del PCA
print("Resumen del Análisis de Componentes Principales:")
print(summary(pca_result))

# Visualizar los resultados del PCA
pca_data <- as_tibble(pca_result$x[, 1:2])
pca_data$medv_grupo <- cut(boston_tbl$medv, 
                           breaks = quantile(boston_tbl$medv, probs = seq(0, 1, 0.25)),
                           labels = c("Bajo", "Medio-bajo", "Medio-alto", "Alto"),
                           include.lowest = TRUE)

ggplot(pca_data, aes(x = PC1, y = PC2, color = medv_grupo)) +
  geom_point(alpha = 0.7) +
  labs(title = "PCA: Primeras dos componentes principales",
       color = "Valor de vivienda") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal()

# Visualizar la contribución de las variables originales a las componentes
pca_rotation <- as_tibble(pca_result$rotation[, 1:2])
pca_rotation$variable <- rownames(pca_result$rotation)

ggplot(pca_rotation, aes(x = PC1, y = PC2, label = variable)) +
  geom_point() +
  ggrepel::geom_text_repel(size = 3) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(title = "Contribución de variables a las componentes principales") +
  theme_minimal()

# =============================================================================
# 7. EDA AUTOMATIZADO CON PAQUETES ESPECIALIZADOS
# =============================================================================

# DataExplorer: Crear un informe automático de EDA
# Este genera un informe HTML completo (descomentar para ejecutar)
# DataExplorer::create_report(boston_tbl)

# Visualizaciones automatizadas con DataExplorer
# Gráficos de correlación
plot_correlation(boston_tbl, 
                 title = "Matriz de correlación (DataExplorer)")

# Histogramas para todas las variables
plot_histogram(boston_tbl, 
               title = "Distribuciones de todas las variables (DataExplorer)")

# Análisis de valores atípicos (boxplots)
plot_boxplot(boston_tbl, by = "medv", 
             title = "Boxplots agrupados por cuartiles de medv (DataExplorer)")

# Gráficos QQ
plot_qq(boston_tbl, 
        title = "Gráficos QQ para todas las variables (DataExplorer)")

# =============================================================================
# 8. ANÁLISIS DE BARRIOS O GRUPOS DE INTERÉS
# =============================================================================

# Crear grupos basados en el valor de las viviendas
boston_tbl <- boston_tbl %>%
  mutate(valor_grupo = case_when(
    medv < 15 ~ "Bajo",
    medv < 25 ~ "Medio-bajo",
    medv < 35 ~ "Medio-alto",
    TRUE ~ "Alto"
  ) %>% factor(levels = c("Bajo", "Medio-bajo", "Medio-alto", "Alto")))

# Comparar características por grupo
boston_tbl %>%
  group_by(valor_grupo) %>%
  summarise(
    num_barrios = n(),
    promedio_criminalidad = mean(crim),
    promedio_habitaciones = mean(rm),
    promedio_estatus_bajo = mean(lstat),
    promedio_ratio_alumno_profesor = mean(ptratio),
    promedio_acceso_autopistas = mean(rad)
  ) %>%
  print()

# Visualizar las principales diferencias entre grupos
boston_long <- boston_tbl %>%
  ungroup() %>% 
  dplyr::select(valor_grupo, rm, lstat, ptratio, crim) %>%
  pivot_longer(-valor_grupo, 
               names_to = "variable", 
               values_to = "valor")

ggplot(boston_long, aes(x = valor_grupo, y = valor, fill = valor_grupo)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = "free_y", labeller = as_labeller(c(
    rm = "Habitaciones promedio",
    lstat = "% Población estatus bajo",
    ptratio = "Ratio alumnos-profesor",
    crim = "Tasa de criminalidad"
  ))) +
  labs(title = "Comparación de variables clave por grupo de valor",
       x = "Grupo de valor de vivienda",
       y = "") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

# =============================================================================
# 9. DETECCIÓN Y ANÁLISIS DE OUTLIERS
# =============================================================================

# Función para identificar outliers (regla IQR)
identificar_outliers <- function(x) {
  q1 <- quantile(x, 0.25)
  q3 <- quantile(x, 0.75)
  iqr <- q3 - q1
  limite_inferior <- q1 - 3 * iqr
  limite_superior <- q3 + 3 * iqr
  return(x < limite_inferior | x > limite_superior)
}

# Identificar outliers en variables clave
variables_para_outliers <- c("medv", "lstat", "rm", "crim")
outliers_df <- data.frame(matrix(ncol = length(variables_para_outliers), 
                                 nrow = nrow(boston_tbl)))
colnames(outliers_df) <- variables_para_outliers

for (var in variables_para_outliers) {
  outliers_df[[var]] <- identificar_outliers(boston_tbl[[var]])
}

# Contar outliers por variable
sapply(outliers_df, sum)

# Examinar barrios con valores de vivienda extremos
outliers_medv <- which(outliers_df$medv)
print("Barrios con valores de vivienda atípicos:")
print(boston_tbl[outliers_medv, ])

# Visualizar los outliers en un scatterplot
boston_con_outliers <- boston_tbl %>%
  mutate(es_outlier_medv = outliers_df$medv)

ggplot(boston_con_outliers, aes(x = lstat, y = medv, color = es_outlier_medv)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(values = c("steelblue", "red")) +
  labs(title = "Valores atípicos en el precio de viviendas",
       x = "% Población de estatus bajo (lstat)",
       y = "Valor mediano de viviendas en $1000 (medv)",
       color = "Outlier") +
  theme_minimal()

# =============================================================================
# 10. CREAR REPORTES AUTOMATICOS
# =============================================================================

DataExplorer::create_report(boston_tbl)
# https://cran.r-project.org/web/packages/DataExplorer/vignettes/dataexplorer-intro.html
create_report()
# =============================================================================
# FIN DEL SCRIPT
# =============================================================================