
# Fundamentos de Bases de Datos: SQL, NoSQL y APIs

## 1. Bases de Datos Relacionales (SQL)

Las bases de datos relacionales han sido el pilar de almacenamiento de datos estructurados durante décadas. Vamos a explorar sus características fundamentales y cómo se diseñan eficientemente.

### 1.1 ¿Qué es una Primary Key (Clave Primaria)?

Una clave primaria es un campo (o conjunto de campos) que identifica de manera única cada registro en una tabla. Pensemos en ello como el "DNI" de cada fila.

**Características principales:**
- Debe ser única para cada registro
- No puede contener valores nulos
- Debe ser estable (no cambiar con frecuencia)
- Optimiza las búsquedas y las operaciones

**Ejemplo:**
En una tabla de `Clientes`, podríamos tener un campo `cliente_id` que es un número único asignado a cada cliente. Este campo sería la clave primaria.

```sql
CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20)
);
```

### 1.2 ¿Qué es una Foreign Key (Clave Foránea)?

Una clave foránea es un campo en una tabla que hace referencia a la clave primaria de otra tabla. Establece una relación entre dos tablas, garantizando la integridad referencial.

**Características:**
- Crea relaciones entre tablas
- Mantiene la integridad de los datos
- Previene la eliminación de datos relacionados
- Permite construir consultas complejas entre tablas

**Ejemplo:**
En una tabla de `Pedidos`, tendríamos un campo `cliente_id` que hace referencia a la tabla `Clientes`. Esto conecta cada pedido con su cliente correspondiente.

```sql
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY,
    cliente_id INT,
    fecha_pedido DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);
```

### 1.3 Diseño Eficiente de Bases de Datos Relacionales

Un principio fundamental en el diseño de bases de datos relacionales es **minimizar la redundancia**. Esto se logra mediante un proceso llamado normalización.

#### ¿Por qué evitar la redundancia?

Imaginemos un escenario donde tenemos una única tabla con todas las transacciones y los datos de los usuarios:

```
TABLA: Transacciones
| transaccion_id | fecha      | monto  | usuario_id | nombre_usuario | email_usuario         | direccion_usuario      |
|----------------|------------|--------|------------|----------------|------------------------|------------------------|
| 1              | 2023-01-15 | 1500   | 101        | Ana García     | ana@ejemplo.com       | Calle Principal 123    |
| 2              | 2023-01-16 | 750    | 102        | Juan Pérez     | juan@ejemplo.com      | Avenida Central 456    |
| 3              | 2023-01-17 | 2000   | 101        | Ana García     | ana@ejemplo.com       | Calle Principal 123    |
```

**Problemas con este diseño:**

1. **Modificaciones complejas:** Si Ana cambia su email, habría que actualizar múltiples filas, lo que aumenta el riesgo de inconsistencias.
   
   Por ejemplo, si actualizamos solo algunas ocurrencias del email de Ana:
   ```
   | transaccion_id | ... | nombre_usuario | email_usuario         | ... |
   |----------------|-----|----------------|------------------------|-----|
   | 1              | ... | Ana García     | ana@ejemplo.com       | ... |
   | 3              | ... | Ana García     | ana_nueva@ejemplo.com | ... |
   ```
   ¡Ahora tenemos información contradictoria en nuestra base de datos!

2. **Desperdicio de espacio:** La información de cada usuario se repite en cada transacción.

3. **Mayor probabilidad de errores:** Al ingresar datos repetidamente, aumenta la posibilidad de errores tipográficos o inconsistencias.

#### Solución: Diseño normalizado

Un mejor diseño sería separar la información en tablas relacionadas:

**Tabla: Usuarios**
```
| usuario_id | nombre      | email           | direccion          |
|------------|-------------|-----------------|---------------------|
| 101        | Ana García  | ana@ejemplo.com | Calle Principal 123 |
| 102        | Juan Pérez  | juan@ejemplo.com| Avenida Central 456 |
```

**Tabla: Transacciones**
```
| transaccion_id | fecha      | monto  | usuario_id |
|----------------|------------|--------|------------|
| 1              | 2023-01-15 | 1500   | 101        |
| 2              | 2023-01-16 | 750    | 102        |
| 3              | 2023-01-17 | 2000   | 101        |
```

**Ventajas:**
- Si Ana cambia su email, solo se actualiza una fila en la tabla Usuarios
- Menor almacenamiento requerido
- Menor probabilidad de inconsistencias
- Mayor flexibilidad para consultas y análisis

### 1.4 Limitaciones de las Bases de Datos Relacionales

A pesar de sus ventajas, las bases de datos SQL presentan algunas limitaciones:

**Esquemas rígidos:** Cada tabla debe seguir un esquema predefinido. Todas las filas deben tener las mismas columnas.

**Dificultad para modelar datos heterogéneos:** Consideremos un caso de un e-commerce que vende productos muy diferentes:

- Un vino tiene atributos como bodega, año, variedad
- Un televisor tiene atributos como pulgadas, resolución, tecnología de pantalla
- Un libro tiene autor, editorial, ISBN

Tratar de encajar todos estos productos en una única estructura relacional puede resultar en:
1. Una tabla con muchas columnas nulas
2. Un diseño excesivamente complejo con múltiples tablas
3. Dificultad para añadir nuevos tipos de productos

## 2. Bases de Datos NoSQL

Las bases de datos NoSQL (No sólo SQL) surgieron como respuesta a las limitaciones de los sistemas relacionales, especialmente para aplicaciones web y casos de uso con grandes volúmenes de datos o estructuras variables.

### 2.1 Características de las Bases de Datos NoSQL

- **Esquema flexible:** No requieren una estructura predefinida
- **Escalabilidad horizontal:** Facilidad para distribuir datos en múltiples servidores
- **Alta disponibilidad:** Diseñadas para funcionar en entornos distribuidos
- **Optimizadas para ciertos patrones de acceso:** Cada tipo está diseñado para casos de uso específicos

### 2.2 Bases de Datos Documentales (JSON)

Las bases de datos documentales como MongoDB, Firestore o CouchDB almacenan datos en documentos similares a JSON (JavaScript Object Notation).

**Ventajas:**
- Cada documento puede tener una estructura diferente
- Los datos relacionados se almacenan juntos, reduciendo la necesidad de "joins"
- Fáciles de escalar horizontalmente
- Se adaptan bien a datos cambiantes

#### Ejemplo: Productos en una tienda online

Para un e-commerce, podemos tener documentos con diferentes estructuras según el tipo de producto:

**Producto: Vino**
```json
{
  "id": "V001",
  "tipo": "vino",
  "nombre": "Malbec Reserva",
  "bodega": "Alta Vista",
  "año": 2018,
  "origen": "Mendoza",
  "variedad": "Malbec",
  "precio": 1250.50
}
```

**Producto: Televisor**
```json
{
  "id": "T001",
  "tipo": "televisor",
  "marca": "Samsung",
  "modelo": "Neo QLED",
  "pulgadas": 55,
  "smart": true,
  "conexiones": ["HDMI", "USB", "Bluetooth"],
  "precio": 120000,
  "tecnologia": "QLED"
}
```

**Producto: Libro**
```json
{
  "id": "L001",
  "tipo": "libro",
  "titulo": "Cien años de soledad",
  "autor": "Gabriel García Márquez",
  "editorial": "Sudamericana",
  "año": 1967,
  "isbn": "978-0307474728",
  "paginas": 432,
  "precio": 2500
}
```

Cada documento contiene toda la información necesaria para su producto, incluso cuando los campos varían significativamente entre tipos de productos. Esta flexibilidad es la principal ventaja de las bases de datos NoSQL documentales.

### 2.3 ¿Cuándo usar SQL vs. NoSQL?

**Preferir SQL cuando:**
- Los datos tienen una estructura consistente y bien definida
- La integridad referencial es crítica (ej. sistemas bancarios)
- Se requieren transacciones complejas con propiedades ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad)
- Se necesitan consultas complejas y reporting

**Preferir NoSQL cuando:**
- Los datos tienen estructura variable o evolucionan rápidamente
- Se necesita escalar horizontalmente para manejar grandes volúmenes
- La velocidad de desarrollo es más importante que la normalización perfecta
- Los patrones de acceso son simples (generalmente basados en clave-valor)

## 3. APIs: Interfaz para acceder a datos

Una vez que tenemos datos almacenados (ya sea en SQL o NoSQL), necesitamos formas de acceder a ellos desde otras aplicaciones. Aquí es donde entran las APIs.

### 3.1 ¿Qué son las APIs?

API significa "Application Programming Interface" (Interfaz de Programación de Aplicaciones). Son conjuntos de reglas y protocolos que permiten que diferentes aplicaciones se comuniquen entre sí.

**Analogía:** Si una base de datos es como una biblioteca, una API es como el bibliotecario que te ayuda a encontrar y obtener libros específicos sin tener que conocer el sistema de organización de la biblioteca.

### 3.2 APIs RESTful

REST (Representational State Transfer) es un estilo arquitectónico para diseñar servicios web. Una API RESTful organiza los recursos (datos) en URLs específicas y utiliza métodos HTTP estándar para interactuar con ellos.

**Métodos HTTP principales:**

| Método | Propósito | Equivalente en BD |
|--------|-----------|-------------------|
| GET    | Obtener datos | SELECT |
| POST   | Crear nuevos registros | INSERT |
| PUT    | Actualizar registros (reemplazo completo) | UPDATE |
| PATCH  | Actualizar parcialmente | UPDATE (parcial) |
| DELETE | Eliminar registros | DELETE |

**Ejemplo de endpoints (URLs) para una API de e-commerce:**
- `/productos` - Lista todos los productos
- `/productos/T001` - Obtiene el televisor con ID T001
- `/usuarios/123/pedidos` - Lista todos los pedidos del usuario 123

### 3.3 Ejemplo práctico: Consulta a una API de clima en R

```r
# Cargar las bibliotecas necesarias
library(httr)
library(jsonlite)

# Definir la URL de la API (reemplazar con tu propia clave API)
url <- "https://api.openweathermap.org/data/2.5/weather"
params <- list(
  q = "Buenos Aires",
  appid = "TU_API_KEY",
  units = "metric"  # Para obtener temperatura en Celsius directamente
)

# Realizar la solicitud GET
respuesta <- GET(url, query = params)

# Verificar si la solicitud fue exitosa
if (http_status(respuesta)$category == "Success") {
  # Convertir el contenido JSON a un objeto R
  datos <- fromJSON(content(respuesta, "text"))
  
  # Extraer y mostrar información relevante
  ciudad <- datos$name
  temperatura <- datos$main$temp
  humedad <- datos$main$humidity
  
  cat(paste("Clima actual en", ciudad, ":\n"))
  cat(paste("Temperatura:", temperatura, "°C\n"))
  cat(paste("Humedad:", humedad, "%\n"))
} else {
  cat("Error al consultar la API:", http_status(respuesta)$message)
}
```

Este código:
1. Define la URL base de la API y los parámetros necesarios
2. Realiza una solicitud GET con esos parámetros
3. Verifica si la solicitud fue exitosa
4. Convierte la respuesta JSON en un objeto R
5. Extrae y muestra la información relevante

### 3.4 Autenticación en APIs

La mayoría de las APIs requieren algún tipo de autenticación para controlar el acceso y prevenir abusos.

**Métodos comunes de autenticación:**

1. **API Keys:** Una clave única que identifica al usuario o aplicación.
   ```r
   # Ejemplo de uso de API Key como parámetro
   respuesta <- GET(url, query = list(api_key = "tu_clave_api", ...))
   
   # O como encabezado
   respuesta <- GET(url, add_headers(Authorization = "ApiKey tu_clave_api"))
   ```

2. **OAuth:** Un protocolo de autorización que permite acceso seguro a los recursos de un usuario.
   ```r
   # Ejemplo simplificado de OAuth
   token <- oauth2.0_token(endpoint, app, scope = "read_data")
   respuesta <- GET(url, config(token = token))
   ```

3. **JWT (JSON Web Tokens):** Tokens firmados que contienen información del usuario.
   ```r
   # Uso de JWT en un encabezado de autorización
   respuesta <- GET(url, add_headers(Authorization = paste("Bearer", jwt_token)))
   ```

**Rate Limits (Límites de uso):**
La mayoría de las APIs tienen límites en la cantidad de solicitudes que puedes hacer en un período determinado:
- Por ejemplo: "1000 solicitudes por día" o "60 solicitudes por minuto"
- Cuando excedes estos límites, generalmente recibes un error 429 (Too Many Requests)
- Las APIs comerciales suelen ofrecer diferentes niveles de acceso según el plan de pago

### 3.5 APIs en el contexto empresarial

Las empresas utilizan APIs para varios propósitos críticos:

**APIs internas:**
- Permiten que diferentes departamentos o sistemas compartan datos de manera controlada
- Facilitan la arquitectura de microservicios, donde cada componente se comunica a través de APIs
- Ejemplo: El sistema de inventario expone una API para que el sistema de ventas pueda verificar existencias

**APIs de socios comerciales:**
- Permiten integraciones B2B (Business-to-Business)
- Acceso controlado a ciertos datos o funciones
- Ejemplo: Una tienda online integra la API de un servicio de envíos para calcular costos y rastrear paquetes

**APIs públicas:**
- Abiertas a desarrolladores externos (con registro)
- Pueden ser gratuitas o de pago
- Ejemplos comunes:
  - Pasarelas de pago: Mercado Pago, PayPal
  - Redes sociales: Twitter, Facebook, Instagram
  - Servicios de mapas: Google Maps, Mapbox
  - Plataformas de comercio electrónico: MercadoLibre, Amazon

**APIs como modelo de negocio:**
Algunas empresas han construido modelos de negocio completos alrededor de sus APIs:
- Stripe y PayPal para procesamiento de pagos
- Twilio para mensajería y comunicaciones
- AWS, Google Cloud y Azure para servicios en la nube

## Conclusión

El mundo de las bases de datos y APIs sigue evolucionando constantemente para satisfacer las necesidades cambiantes del desarrollo de software y análisis de datos. Comprender estos conceptos fundamentales te permite elegir las herramientas adecuadas para cada proyecto y construir sistemas que sean eficientes, escalables y fáciles de mantener.

- Las bases de datos SQL brindan estructura, integridad y capacidades de consulta potentes
- Las bases de datos NoSQL ofrecen flexibilidad, escalabilidad y adaptabilidad
- Las APIs proporcionan interfaces estructuradas para acceder a datos y funcionalidades

La elección entre estas tecnologías no es excluyente: muchos sistemas modernos utilizan un enfoque híbrido, empleando bases de datos SQL y NoSQL según las necesidades específicas de cada componente, y exponiendo todo a través de APIs bien diseñadas.
