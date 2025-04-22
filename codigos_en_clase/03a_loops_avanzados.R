# Simulación de intervalos de confianza en regresión lineal simple
# Esta simulación muestra cómo diferentes muestras de la misma población
# pueden generar diferentes estimaciones e intervalos de confianza

# Configuración de la simulación
set.seed(123) # Para reproducibilidad
n_poblacion <- 10000 # Tamaño de la población
n_muestra <- 30 # Tamaño de cada muestra
n_simulaciones <- 10 # Número de muestras diferentes a tomar

# Parámetros verdaderos de la población
beta0_verdadero <- 5 # Intercepto verdadero
beta1_verdadero <- 2 # Pendiente verdadera
sigma <- 5 # Error estándar (alto para mostrar mayor variabilidad)

# Generar la población completa
x_poblacion <- runif(n_poblacion, 0, 10) # Variable independiente
y_poblacion <- beta0_verdadero + beta1_verdadero * x_poblacion + rnorm(n_poblacion, 0, sigma)

# Función para estimar el modelo en una muestra
estimar_modelo <- function(indices) {
  x_muestra <- x_poblacion[indices]
  y_muestra <- y_poblacion[indices]
  modelo <- lm(y_muestra ~ x_muestra)
  return(modelo)
}

# Generar múltiples muestras y estimar modelos
modelos <- list()
muestras_x <- list()
muestras_y <- list()
i<-1
for (i in 1:n_simulaciones) {
  indices_muestra <- sample(1:n_poblacion, n_muestra)
  muestras_x[[i]] <- x_poblacion[indices_muestra]
  muestras_y[[i]] <- y_poblacion[indices_muestra]
  modelos[[i]] <- estimar_modelo(indices_muestra)
}

# Crear un data frame con los resultados de las simulaciones
# Crear un data frame para almacenar los resultados usando loops
resultados <- data.frame(
  Simulacion = 1:n_simulaciones,
  Beta0 = numeric(n_simulaciones),
  Beta1 = numeric(n_simulaciones),
  Beta0_IC_Inf = numeric(n_simulaciones),
  Beta0_IC_Sup = numeric(n_simulaciones),
  Beta1_IC_Inf = numeric(n_simulaciones),
  Beta1_IC_Sup = numeric(n_simulaciones),
  p_valor_beta1 = numeric(n_simulaciones)
)

# Llenar el data frame con los resultados usando un loop
for (i in 1:n_simulaciones) {
  # Coeficientes
  resultados$Beta0[i] <- coef(modelos[[i]])[1]
  resultados$Beta1[i] <- coef(modelos[[i]])[2]
  
  # Intervalos de confianza
  ic <- confint(modelos[[i]])
  resultados$Beta0_IC_Inf[i] <- ic[1,1]
  resultados$Beta0_IC_Sup[i] <- ic[1,2]
  resultados$Beta1_IC_Inf[i] <- ic[2,1]
  resultados$Beta1_IC_Sup[i] <- ic[2,2]
  
  # P-valor
  resultados$p_valor_beta1[i] <- summary(modelos[[i]])$coefficients[2,4]
}

# Mostrar los resultados
print(resultados)

# Visualización 1: Comparando las diferentes estimaciones de Beta1 con sus intervalos de confianza
library(ggplot2)

# Gráfico de intervalos de confianza para Beta1
ggplot(resultados, aes(x = factor(Simulacion), y = Beta1)) +
  geom_point(size = 3, color = "blue") +
  geom_errorbar(aes(ymin = Beta1_IC_Inf, ymax = Beta1_IC_Sup), width = 0.2) +
  geom_hline(yintercept = beta1_verdadero, linetype = "dashed", color = "red") +
  labs(title = "Estimaciones de Beta1 con intervalos de confianza del 95%",
       subtitle = paste("Valor verdadero de Beta1 =", beta1_verdadero),
       x = "Número de simulación",
       y = "Estimación de Beta1") +
  theme_minimal()

# Visualización 2: Gráficos de dispersión con líneas de regresión para cada muestra
# Crear un gráfico con facetas para las primeras 6 simulaciones
plots_list <- list()

# Primero, generar dataframe con todos los datos
all_data <- data.frame()
for (i in 1:min(6, n_simulaciones)) {
  temp_df <- data.frame(
    x = muestras_x[[i]],
    y = muestras_y[[i]],
    Simulacion = paste("Simulación", i),
    beta0 = coef(modelos[[i]])[1],
    beta1 = coef(modelos[[i]])[2],
    p_valor = summary(modelos[[i]])$coefficients[2,4]
  )
  all_data <- rbind(all_data, temp_df)
}

# Crear la visualización con facetas
ggplot(all_data, aes(x = x, y = y)) +
  geom_point(alpha = 0.7) +
  geom_abline(aes(intercept = beta0, slope = beta1), color = "blue") +
  geom_abline(intercept = beta0_verdadero, slope = beta1_verdadero, 
              color = "red", linetype = "dashed") +
  facet_wrap(~ Simulacion) +
  labs(title = "Diferentes muestras y sus líneas de regresión estimadas",
       subtitle = "Línea roja punteada: regresión verdadera, Línea azul: regresión estimada",
       x = "X",
       y = "Y") +
  theme_minimal()

# Función para demostrar el significado del intervalo de confianza
# Vamos a simular muchas muestras y verificar si el IC contiene el valor verdadero
set.seed(456)
n_ic_sim <- 100  # Más simulaciones para demostrar la propiedad del IC
contiene_beta1 <- numeric(n_ic_sim)
contador_contiene <- 0

for (i in 1:n_ic_sim) {
  indices_muestra <- sample(1:n_poblacion, n_muestra)
  modelo <- estimar_modelo(indices_muestra)
  ic <- confint(modelo)
  
  # Verificar si el intervalo contiene el verdadero valor de Beta1
  if (ic[2,1] <= beta1_verdadero && beta1_verdadero <= ic[2,2]) {
    contiene_beta1[i] <- 1
    contador_contiene <- contador_contiene + 1
  } else {
    contiene_beta1[i] <- 0
  }
}

# Porcentaje de veces que el IC contiene el valor verdadero
porcentaje_cobertura <- (contador_contiene / n_ic_sim) * 100
cat("Porcentaje de intervalos de confianza que contienen el valor verdadero de Beta1:", 
    porcentaje_cobertura, "%\n")

# Visualizar cómo el tamaño de la muestra afecta el ancho del intervalo de confianza
tamanos_muestra <- c(10, 20, 50, 100, 200, 500)
num_tamanos <- length(tamanos_muestra)

# Crear dataframe para almacenar resultados
resultados_tamano <- data.frame(
  Tamano_muestra = tamanos_muestra,
  Beta1 = numeric(num_tamanos),
  IC_Inf = numeric(num_tamanos),
  IC_Sup = numeric(num_tamanos),
  Ancho_IC = numeric(num_tamanos)
)

set.seed(789)
# Loop para cada tamaño de muestra
for (i in 1:num_tamanos) {
  # Tomar una muestra de tamaño específico
  indices_muestra <- sample(1:n_poblacion, tamanos_muestra[i])
  
  # Estimar el modelo
  x_muestra <- x_poblacion[indices_muestra]
  y_muestra <- y_poblacion[indices_muestra]
  modelo <- lm(y_muestra ~ x_muestra)
  
  # Calcular el intervalo de confianza
  ic <- confint(modelo)
  
  # Guardar resultados
  resultados_tamano$Beta1[i] <- coef(modelo)[2]
  resultados_tamano$IC_Inf[i] <- ic[2,1]
  resultados_tamano$IC_Sup[i] <- ic[2,2]
  resultados_tamano$Ancho_IC[i] <- ic[2,2] - ic[2,1]
}

# Gráfico del ancho del IC en función del tamaño de la muestra
ggplot(resultados_tamano, aes(x = factor(Tamano_muestra), y = Ancho_IC)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Ancho del intervalo de confianza según el tamaño de la muestra",
       x = "Tamaño de la muestra",
       y = "Ancho del intervalo de confianza para Beta1") +
  theme_minimal()
