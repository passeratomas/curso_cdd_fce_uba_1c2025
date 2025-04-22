# Funciones para generar datos de examen - Alquiler de casas temporales
# Estas funciones generan 5 tablas relacionadas con datos aleatorios basados en el número de legajo

# Función principal que genera todas las tablas
generar_datos_examen <- function(legajo) {
  # Establecer la semilla para reproducibilidad basada en el legajo
  set.seed(as.numeric(legajo))
  
  # Parámetros de dimensión
  n_usuarios_alquilan <- 5000     # Usuarios que alquilan propiedades
  n_usuarios_arrendatarios <- 1000 # Propietarios/arrendatarios
  n_casas <- 3000                  # Propiedades disponibles
  n_transacciones <- 100000        # Transacciones totales
  
  # Generar las tablas
  usuarios_alquilan <- generar_usuarios_alquilan(n_usuarios_alquilan)
  usuarios_arrendatarios <- generar_usuarios_arrendatarios(n_usuarios_arrendatarios)
  casas <- generar_casas(n_casas, usuarios_arrendatarios$id_arrendatario)
  transacciones <- generar_transacciones(n_transacciones, 
                                         usuarios_alquilan$id_alquila, 
                                         usuarios_arrendatarios$id_arrendatario,
                                         casas$id_casa)
  detalles_transacciones <- generar_detalles_transacciones(transacciones$id_transaccion, casas)
  
  # Retornar todas las tablas en una lista
  return(list(
    transacciones = transacciones,
    usuarios_alquilan = usuarios_alquilan,
    usuarios_arrendatarios = usuarios_arrendatarios,
    casas = casas,
    detalles_transacciones = detalles_transacciones
  ))
}

# Función para generar la tabla de usuarios que alquilan (inquilinos)
generar_usuarios_alquilan <- function(n) {
  # Vectores de opciones
  provincias <- c('Buenos Aires', 'CABA', 'Catamarca', 'Chaco', 'Chubut', 
                  'Córdoba', 'Corrientes', 'Entre Ríos', 'Formosa', 'Jujuy', 
                  'La Pampa', 'La Rioja', 'Mendoza', 'Misiones', 'Neuquén', 
                  'Río Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz', 
                  'Santa Fe', 'Santiago del Estero', 'Tierra del Fuego', 'Tucumán')
  
  niveles_verificacion <- c('Básico', 'Intermedio', 'Completo')
  
  # Generar datos aleatorios
  id_alquila <- 1:n
  sexo <- sample(c('Masculino', 'Femenino'), n, replace = TRUE)
  edad <- sample(18:70, n, replace = TRUE)
  provincia_nacimiento <- sample(provincias, n, replace = TRUE)
  cantidad_alquileres <- sample(0:50, n, replace = TRUE)
  calificacion_media <- round(runif(n, 1, 5), 1)
  
  # Fechas de registro (últimos 5 años)
  fecha_registro <- as.Date(sample(
    seq(as.Date('2019-01-01'), as.Date('2024-12-31'), by = "day"),
    n, replace = TRUE
  ))
  
  nivel_verificacion <- sample(niveles_verificacion, n, replace = TRUE)
  
  # Campos adicionales interesantes
  idiomas_hablados <- sample(
    c('Español', 'Español,Inglés', 'Español,Inglés,Portugués', 'Español,Portugués'),
    n, replace = TRUE
  )
  
  preferencia_ubicacion <- sample(provincias, n, replace = TRUE)
  
  # Crear dataframe
  data.frame(
    id_alquila = id_alquila,
    sexo = sexo,
    edad = edad,
    provincia_nacimiento = provincia_nacimiento,
    cantidad_alquileres = cantidad_alquileres,
    calificacion_media = calificacion_media,
    fecha_registro = fecha_registro,
    nivel_verificacion = nivel_verificacion,
    idiomas_hablados = idiomas_hablados,
    preferencia_ubicacion = preferencia_ubicacion,
    stringsAsFactors = FALSE
  )
}

# Función para generar la tabla de usuarios arrendatarios (propietarios)
generar_usuarios_arrendatarios <- function(n) {
  # Vectores de opciones
  provincias <- c('Buenos Aires', 'CABA', 'Catamarca', 'Chaco', 'Chubut', 
                  'Córdoba', 'Corrientes', 'Entre Ríos', 'Formosa', 'Jujuy', 
                  'La Pampa', 'La Rioja', 'Mendoza', 'Misiones', 'Neuquén', 
                  'Río Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz', 
                  'Santa Fe', 'Santiago del Estero', 'Tierra del Fuego', 'Tucumán')
  
  niveles_verificacion <- c('Básico', 'Intermedio', 'Completo')
  
  # Generar datos aleatorios
  id_arrendatario <- 1:n
  sexo <- sample(c('Masculino', 'Femenino'), n, replace = TRUE)
  edad <- sample(25:75, n, replace = TRUE)
  provincia_nacimiento <- sample(provincias, n, replace = TRUE)
  cantidad_viviendas_publicadas <- sample(1:10, n, replace = TRUE)
  calificacion_media <- round(runif(n, 1, 5), 1)
  
  # Fechas de registro (pueden ser más antiguas que los inquilinos)
  fecha_registro <- as.Date(sample(
    seq(as.Date('2017-01-01'), as.Date('2024-12-31'), by = "day"),
    n, replace = TRUE
  ))
  
  nivel_verificacion <- sample(niveles_verificacion, n, replace = TRUE)
  es_superanfitrion <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.2, 0.8))
  tiempo_respuesta_hrs <- sample(c(1, 2, 4, 8, 12, 24, 48), n, replace = TRUE)
  
  # Campos adicionales interesantes
  anos_experiencia <- sample(1:15, n, replace = TRUE)
  politica_cancelacion <- sample(
    c('Flexible', 'Moderada', 'Estricta'), 
    n, replace = TRUE,
    prob = c(0.3, 0.4, 0.3)
  )
  
  # Crear dataframe
  data.frame(
    id_arrendatario = id_arrendatario,
    sexo = sexo,
    edad = edad,
    provincia_nacimiento = provincia_nacimiento,
    cantidad_viviendas_publicadas = cantidad_viviendas_publicadas,
    calificacion_media = calificacion_media,
    fecha_registro = fecha_registro,
    nivel_verificacion = nivel_verificacion,
    es_superanfitrion = es_superanfitrion,
    tiempo_respuesta_hrs = tiempo_respuesta_hrs,
    anos_experiencia = anos_experiencia,
    politica_cancelacion = politica_cancelacion,
    stringsAsFactors = FALSE
  )
}

# Función para generar la tabla de casas/viviendas
generar_casas <- function(n, ids_arrendatarios) {
  # Vectores de opciones
  provincias <- c('Buenos Aires', 'CABA', 'Catamarca', 'Chaco', 'Chubut', 
                  'Córdoba', 'Corrientes', 'Entre Ríos', 'Formosa', 'Jujuy', 
                  'La Pampa', 'La Rioja', 'Mendoza', 'Misiones', 'Neuquén', 
                  'Río Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz', 
                  'Santa Fe', 'Santiago del Estero', 'Tierra del Fuego', 'Tucumán')
  
  tipos_vivienda <- c('Casa', 'Departamento', 'Cabaña', 'Loft', 'Chalet')
  
  categorias_vivienda <- c('Económica', 'Estándar', 'Premium', 'Lujo', 'Ultra lujo')
  
  amenities_posibles <- c(
    'WiFi', 'Pileta', 'Aire acondicionado', 'Calefacción', 
    'Cocina equipada', 'Lavadora', 'TV', 'Estacionamiento', 
    'Parrilla', 'Terraza', 'Gimnasio', 'Jacuzzi', 'Vista al mar', 
    'Acceso a playa', 'Seguridad 24hs'
  )
  
  # Generar datos aleatorios
  id_casa <- 1:n
  
  # Asignar arrendatarios a casas (un arrendatario puede tener múltiples casas)
  id_arrendatario <- sample(ids_arrendatarios, n, replace = TRUE)
  
  tipo_vivienda <- sample(tipos_vivienda, n, replace = TRUE)
  provincia_ubicacion <- sample(provincias, n, replace = TRUE)
  capacidad_maxima <- sample(2:12, n, replace = TRUE)
  numero_habitaciones <- sample(1:6, n, replace = TRUE)
  numero_banos <- sample(1:4, n, replace = TRUE)
  
  # El precio base depende en parte de la categoría
  categoria <- sample(categorias_vivienda, n, replace = TRUE)
  
  # Asignar precios que reflejen la categoría
  precio_base_noche <- sapply(categoria, function(cat) {
    base <- switch(cat,
                   'Económica' = runif(1, 5000, 12000),
                   'Estándar' = runif(1, 10000, 20000),
                   'Premium' = runif(1, 18000, 30000),
                   'Lujo' = runif(1, 25000, 40000),
                   'Ultra lujo' = runif(1, 35000, 60000))
    round(base)
  })
  
  distancia_centro_km <- round(runif(n, 0, 15), 1)
  anio_construccion <- sample(1950:2023, n, replace = TRUE)
  
  # Generar amenities para cada vivienda
  amenities <- sapply(1:n, function(i) {
    n_amenities <- sample(2:8, 1)
    paste(sample(amenities_posibles, n_amenities), collapse = ",")
  })
  
  # Calificaciones
  calificacion_limpieza <- round(runif(n, 1, 5), 1)
  calificacion_ubicacion <- round(runif(n, 1, 5), 1)
  calificacion_general <- round(runif(n, 1, 5), 1)
  
  # Campos adicionales interesantes
  mascotas_permitidas <- sample(c(TRUE, FALSE), n, replace = TRUE)
  fumadores_permitidos <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.1, 0.9))
  eventos_permitidos <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.2, 0.8))
  
  # Crear dataframe
  data.frame(
    id_casa = id_casa,
    id_arrendatario = id_arrendatario,
    tipo_vivienda = tipo_vivienda,
    provincia_ubicacion = provincia_ubicacion,
    capacidad_maxima = capacidad_maxima,
    numero_habitaciones = numero_habitaciones,
    numero_banos = numero_banos,
    precio_base_noche = precio_base_noche,
    categoria = categoria,
    distancia_centro_km = distancia_centro_km,
    anio_construccion = anio_construccion,
    amenities = amenities,
    calificacion_limpieza = calificacion_limpieza,
    calificacion_ubicacion = calificacion_ubicacion,
    calificacion_general = calificacion_general,
    mascotas_permitidas = mascotas_permitidas,
    fumadores_permitidos = fumadores_permitidos,
    eventos_permitidos = eventos_permitidos,
    stringsAsFactors = FALSE
  )
}

# Función para generar la tabla de transacciones
generar_transacciones <- function(n, ids_alquila, ids_arrendatario, ids_casa) {
  id_transaccion <- 1:n
  
  # Para cada transacción:
  # 1. Elegir aleatoriamente una casa
  # 2. El arrendatario está determinado por la casa
  # 3. Elegir aleatoriamente un usuario que alquila
  
  # Seleccionar casas aleatorias para cada transacción
  idx_casa <- sample(length(ids_casa), n, replace = TRUE)
  id_casa <- ids_casa[idx_casa]
  
  # Seleccionar usuarios que alquilan aleatorios
  id_alquila <- sample(ids_alquila, n, replace = TRUE)
  
  # Para cada casa, obtener su arrendatario
  # En un caso real esto sería una join, pero aquí lo simulamos:
  casa_a_arrendatario <- setNames(
    sample(ids_arrendatario, length(ids_casa), replace = TRUE),
    ids_casa
  )
  
  id_arrendatario <- casa_a_arrendatario[as.character(id_casa)]
  
  # Generar fechas de transacción (últimos 2 años)
  fecha_transaccion <- as.Date(sample(
    seq(as.Date('2023-01-01'), as.Date('2024-12-31'), by = "day"),
    n, replace = TRUE
  ))
  
  # Campos adicionales interesantes
  origen_reserva <- sample(
    c('App Móvil', 'Sitio Web', 'Teléfono', 'Agencia'),
    n, replace = TRUE,
    prob = c(0.45, 0.40, 0.10, 0.05)
  )
  
  # Crear dataframe
  data.frame(
    id_transaccion = id_transaccion,
    id_alquila = id_alquila,
    id_arrendatario = id_arrendatario,
    id_casa = id_casa,
    fecha_transaccion = fecha_transaccion,
    origen_reserva = origen_reserva,
    stringsAsFactors = FALSE
  )
}

# Función para generar detalles de transacciones
generar_detalles_transacciones <- function(ids_transaccion, casas) {
  n <- length(ids_transaccion)
  
  # Para cada transacción, necesitamos algunas propiedades de la casa
  # En un caso real esto sería un join, pero aquí simulamos:
  transaccion_a_casa <- sample(casas$id_casa, n, replace = TRUE)
  capacidades <- casas$capacidad_maxima[match(transaccion_a_casa, casas$id_casa)]
  precios_base <- casas$precio_base_noche[match(transaccion_a_casa, casas$id_casa)]
  
  # Generar datos aleatorios
  cantidad_noches <- sample(1:14, n, replace = TRUE)
  
  # El precio pactado varía del precio base (temporada alta/baja, promociones, etc.)
  factor_precio <- runif(n, 0.8, 1.2)
  precio_noche <- round(precios_base * factor_precio)
  
  # Cantidad de personas limitada por la capacidad de cada casa
  cantidad_personas <- sapply(1:n, function(i) {
    sample(1:capacidades[i], 1)
  })
  
  # Fechas de check-in/out basadas en la fecha de transacción
  # Primero asumimos fechas de transacción aleatorias
  fechas_transaccion <- as.Date(sample(
    seq(as.Date('2023-01-01'), as.Date('2024-12-31'), by = "day"),
    n, replace = TRUE
  ))
  
  # El check-in es después de la transacción (entre 7 y 90 días después)
  dias_hasta_checkin <- sample(7:90, n, replace = TRUE)
  fecha_checkin <- fechas_transaccion + dias_hasta_checkin
  
  # El check-out depende de la cantidad de noches
  fecha_checkout <- fecha_checkin + cantidad_noches
  
  # Métodos de pago
  metodo_pago <- sample(
    c('Tarjeta de crédito', 'Transferencia bancaria', 'Efectivo', 'Billetera virtual'),
    n, replace = TRUE,
    prob = c(0.6, 0.2, 0.1, 0.1)
  )
  
  # Estados de transacción
  estado_transaccion <- sample(
    c('Completada', 'Cancelada', 'Pendiente', 'En curso'),
    n, replace = TRUE,
    prob = c(0.7, 0.1, 0.1, 0.1)
  )
  
  # Descuentos, costos adicionales e impuestos
  descuento_aplicado <- sample(0:30, n, replace = TRUE)
  costo_limpieza <- sample(2000:8000, n, replace = TRUE)
  
  # El costo de servicio es un porcentaje del total
  costo_servicio <- round(precio_noche * cantidad_noches * 0.15)
  
  # Impuestos (IVA 21%)
  impuestos <- round(precio_noche * cantidad_noches * 0.21)
  
  # Calificaciones (solo para transacciones completadas)
  calificacion_huesped <- ifelse(
    estado_transaccion == 'Completada',
    sample(1:5, n, replace = TRUE),
    NA
  )
  
  calificacion_anfitrion <- ifelse(
    estado_transaccion == 'Completada',
    sample(1:5, n, replace = TRUE),
    NA
  )
  
  # Crear dataframe
  data.frame(
    id_transaccion = ids_transaccion,
    cantidad_noches = cantidad_noches,
    precio_noche = precio_noche,
    cantidad_personas = cantidad_personas,
    fecha_checkin = fecha_checkin,
    fecha_checkout = fecha_checkout,
    metodo_pago = metodo_pago,
    estado_transaccion = estado_transaccion,
    descuento_aplicado = descuento_aplicado, 
    costo_limpieza = costo_limpieza,
    costo_servicio = costo_servicio,
    impuestos = impuestos,
    calificacion_huesped = calificacion_huesped,
    calificacion_anfitrion = calificacion_anfitrion,
    stringsAsFactors = FALSE
  )
}

# Función para guardar los datos generados en archivos CSV
guardar_datos_examen <- function(datos, carpeta = "datos_examen") {
  # Crear la carpeta si no existe
  if(!dir.exists(carpeta)) {
    dir.create(carpeta, recursive = TRUE)
  }
  
  # Guardar cada tabla en un archivo CSV
  write.csv(datos$transacciones, 
            file.path(carpeta, "transacciones.csv"), 
            row.names = FALSE)
  
  write.csv(datos$usuarios_alquilan, 
            file.path(carpeta, "usuarios_alquilan.csv"), 
            row.names = FALSE)
  
  write.csv(datos$usuarios_arrendatarios, 
            file.path(carpeta, "usuarios_arrendatarios.csv"), 
            row.names = FALSE)
  
  write.csv(datos$casas, 
            file.path(carpeta, "casas.csv"), 
            row.names = FALSE)
  
  write.csv(datos$detalles_transacciones, 
            file.path(carpeta, "detalles_transacciones.csv"), 
            row.names = FALSE)
  
  cat("Datos guardados en la carpeta:", carpeta, "\n")
}

# Ejemplo de uso:
# mi_legajo <- "882280"
# datos <- generar_datos_examen(mi_legajo)
# guardar_datos_examen(datos)

# Para generar datos específicos para un alumno:
generar_datos_alumno <- function(legajo, carpeta = NULL) {
  # Si no se especifica carpeta, usar el legajo como nombre
  if(is.null(carpeta)) {
    carpeta <- paste0("datos_alumno_", legajo)
  }
  
  # Generar y guardar los datos
  datos <- generar_datos_examen(legajo)
  guardar_datos_examen(datos, carpeta)
  
  # Devolver un resumen de los datos generados
  resumen <- list(
    num_transacciones = nrow(datos$transacciones),
    num_usuarios_alquilan = nrow(datos$usuarios_alquilan),
    num_usuarios_arrendatarios = nrow(datos$usuarios_arrendatarios),
    num_casas = nrow(datos$casas),
    primera_fecha = min(datos$transacciones$fecha_transaccion),
    ultima_fecha = max(datos$transacciones$fecha_transaccion)
  )
  
  return(resumen)
}

# Uso para un solo alumno:
# resumen <- generar_datos_alumno("882280")
# print(resumen)

# Para generar datos para múltiples alumnos (si tienes una lista de legajos)
generar_datos_curso <- function(legajos, carpeta_base = "datos_examen_curso") {
  # Crear la carpeta base
  if(!dir.exists(carpeta_base)) {
    dir.create(carpeta_base, recursive = TRUE)
  }
  
  # Generar datos para cada alumno
  resumenes <- list()
  
  for(legajo in legajos) {
    carpeta_alumno <- file.path(carpeta_base, paste0("alumno_", legajo))
    cat("Generando datos para alumno con legajo:", legajo, "\n")
    resumenes[[legajo]] <- generar_datos_alumno(legajo, carpeta_alumno)
  }
  
  return(resumenes)
}

# Ejemplo de uso para múltiples alumnos:
# legajos <- c("123456", "234567", "345678") # Lista de legajos de tus alumnos
# resumenes <- generar_datos_curso(legajos)