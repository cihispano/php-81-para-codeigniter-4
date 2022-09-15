# PHP 8.1 para CodeIgniter 4

Configuración de Docker con Docker Compose para poder levantar de forma rápida un entorno de desarrollo para
[CodeIgniter 4](https://codeigniter.com/).

Esta configuración genera los siguientes contenedores:

- **appstarter-fe**: Servidor NGINX 1.23. Está disponible http y https (con certificado autofirmado con lo que la primera
  vez que se accede hay que indicar que se quiere aceptar el riesgo y continuar), protocolo HTTP2
- **appstarter-be**: Servidor con PHP-FPM versión 8.1 con los siguientes módulos y paquetes:

    - nodejs (V 16)
    - yarn (Classic Stable)
    - composer (V2)
    - php-cs-fixer
    - git
    - Zend OPcache
    - Xdebug v3
    - Módulos PHP adicionales
        - apcu, gd, intl, mcrypt, opcache, pcntl, pdo_mysql, mysqli, pdo_pgsql, pgsql, soap, sockets, xdebug, zip
    - Módulos Zend
        - Xdebug
        - Zend OPcache
- **appstarter-mysql**: Servidor MariaDB (10.9.2). Lleva incluido un script de inicialización con lo que ya crea
  automáticamente el usuario de la base de datos y le da permisos. Accesible en el host a través del puerto 3306.
- **appstarter-postgresql**: Servidor PostgeSQL (14.5). Accesible en el host a través del puerto 5432.


## Instalación de Codeigniter 4

Puedes hacer la instalación siguiendo cualquiera de los dos métodos recomendados en la
[documentación oficial](https://codeigniter.com/user_guide/index.html):

- [Instalación con composer](https://codeigniter.com/user_guide/installation/installing_composer.html)
- [Instalación manual](https://codeigniter.com/user_guide/installation/installing_manual.html)

En este caso utilizamos la recomendada, con composer. En caso de que no lo tengas instalado, puedes hacerlo a través
del método manual.

Abre una terminal en su sistema y crea un nuevo proyecto:

```shell
composer create-project codeigniter4/appstarter mi-proyecto
```

Y después entra en el directorio:
```shell
cd mi-proyecto
```

## Instalación de PHP 8.1 para CodeIgniter

### Preparación del entorno de desarrollo

El equipo en el que vas a hacer la instalación debe tener instalado y configurado (depende de tu sistema operativo):

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Comando GNU [Make](https://www.gnu.org/software/make/)

#### Documentación adicional

- [Instalar make en Debian / Ubuntu](https://linuxhint.com/install-make-ubuntu/)
- [Instalar make en Windows](https://linuxhint.com/install-use-make-windows/)
- [Instalar make en Mac](https://stackoverflow.com/questions/10265742/how-to-install-make-and-gcc-on-a-mac)

## Descarga del repositorio

> Si estás actualizando desde una versión anterior debes borrar antes el directorio **docker**.

Descarga este repositorio y después descomprímelo en cualquier ruta.

A continuación, copia los siguientes ficheros y directorios a la raíz del proyecto de Codeigniter 4 que
acabas descargar en el punto anterior:

- 📁 docker
- 📝 Makefile
- 📝 docker-compose.yml


## Configuración de Docker Compose

### Variables de entorno para configuración de la base de datos

#### Notación del fichero .env de CodeIgniter

El fichero .env de CodeIgniter4 utiliza la notación con `.` para utilizar variables con espacio de nombres.

Software como Docker, Apache y otros no soportan dicha notación y en las versiones más recientes de CodeIgniter4
ya permiten cambiar `.` por `_`. Esto quiere decir que para poder utilizar docker-composer sin recibir errores en
ciertas situaciones, debes de cambiar esta notación (incluso en las líneas que estén comentadas).
En el propio fichero `env` de ejemplo de CodeIgniter ya indica cómo hacerlo.

#### Variables de configuración de la base de datos

Las variables de entorno son autodescriptivas, con lo que no hacer falta mucha explicación.

A continuación se indica los nombres de las variables y los valores que toman por defecto en caso de que no se hayan
indicado en el fichero `.env`.

- **DB_NAME**: appstarter_db
- **DB_USER**: appstarter_user
- **DB_PASSWORD**: appstarter_password

Ejemplo de fichero de configuración mímima para que funcione CodeIgniter4 con Docker utilizando este repositorio.

```dotenv
#--------------------------------------------------------------------
# Docker
#--------------------------------------------------------------------
#DB_NAME=
#DB_USER=
#DB_PASSWORD=

#--------------------------------------------------------------------
# ENVIRONMENT
#--------------------------------------------------------------------

CI_ENVIRONMENT=development

#--------------------------------------------------------------------
# APP
#--------------------------------------------------------------------

app_baseURL=https://localhost/
app_indexPage=
```

### Fichero `docker-compose.yml`

Antes de generar las imágenes, puedes modificar el fichero para cambiar la configuración según tus necesidades.

Por ejemplo, si no vas a utilizar base de datos o bien solo necesitas una de ellas, borra la que no necesites.

Además, en el contendor de PHP hay varias líneas comentadas que puedes descomentar según IDE y  sistema operativo que
estés utilizando:

- **\# - ~/.ssh:/home/usuario/.ssh:ro**: inyecta en el contedor la configuración de ssh que tienes en tu equipo. De
esta forma, desde el contenedor puedes hacer **git pull**, **git push**, **composer require PAQUETE**, **ssh**, etc.
como si estuvieses con tu usuario en tu máquina.
- **\# - ~/.gitconfig:/home/usuario/.gitconfig:ro**: copia tu configuración local de git al propio contenedor.
- **\# PHP_IDE_CONFIG: serverName=appstarter-be**: variable de entorno para poder utilizar Xdebug con PhpStorm.

Por último en este fichero, deben configurar el parámetro **XDEBUG_CLIENT_HOST**, ya que depende del sistema
operativo que estés utilizando. En el propio fichero tienes las instrucciones de lo que tienes que poner.

### Configuración del contenedor de PHP

El Dockerfile de PHP está en `docker/Back/Dockerfile`.

En este fichero puedes:

- Modificar la hora horaria: busca la línea `localedef -i es_ES -c -f UTF-8 -A /usr/share/locale/locale.alias es_ES.UTF-8`
y pon los valores que sean adecuados a tu zona.

## Crear las imágenes y levantar los contenedores

Una vez tienes todo configurado, para crear las imágenes, abres una terminal, te sitúas en la carpeta del proyecto
y escribes el comando:

```shell
make build
```

Y espera a que terminen de crearse. Debería de aparecerte un mensaje similar a este:

```
Successfully tagged mi-proyecto_appstarter-be:latest
```

Si todo ha ido correctamente, puedes arrancar los servicios con el comando:

```shell
make start
```

## Comando make

### Ver utilidades disponibles

```shell
make help
```

### Entrar en el contenedor de PHP para ejecutar comandos

```shell
make ssh-be
```

Y una vez dentro puedes comprobar la versión de PHP instalada:

```shell
php -v
```

Ejemplo de salida del comando anterior

```text
PHP 8.1.6 (cli) (built: May 13 2022 22:28:45) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.1.6, Copyright (c) Zend Technologies
    with Zend OPcache v8.1.6, Copyright (c), by Zend Technologies
    with Xdebug v3.2.0alpha3, Copyright (c) 2002-2022, by Derick Rethans
```

A entrar, ya estás directamente en el directorio raíz de la aplicación.

Para salir, utiliza el comando exit:

```shell
exit
```

### Para los contenedores

La configuración en el docker-compose es que los servicios se vuelvan a levantar aunque reinicies tu equipo.


Reiniciar (Parar y arrancar otra vez)

```shell
make restart
```

Parar

```shell
make stop
```

Eliminar los contenedores y la red

```shell
make down
```

# Configuración adicional del fichero .env

En este punto se explica la configuración mínima para poder probar todo el entorno, incluyendo las bases de datos.

Para ver la configuración de forma más detallada, consulta la
[documentación oficial](https://codeigniter.com/user_guide/installation/running.html#initial-configuration).

El fichero **.env** tiene que existir para el funcionamiento de Docker, por lo que si no existe y no te face
falta configurar ninguna variable de entorno, simplemente créalo vacío, aunque la configuración mímima para
el entorno de desarrollo puede ser la siguiente:

```dotenv
#--------------------------------------------------------------------
# ENVIRONMENT
#--------------------------------------------------------------------

CI_ENVIRONMENT=development

#--------------------------------------------------------------------
# APP
#--------------------------------------------------------------------

app_baseURL=https://localhost/
app_indexPage=
```

Según la base de datos que estés utilizando

## MariaDB

```dotenv
#--------------------------------------------------------------------
# DATABASE
#--------------------------------------------------------------------
database_default_hostname=dbmysql
database_default_database=appstarter_db
database_default_username=appstarter_user
database_default_password=appstarter_password
database_default_DBDriver=MySQLi
database_default_port=3306
```

## PostgreSQL

```dotenv
#--------------------------------------------------------------------
# DATABASE
#--------------------------------------------------------------------
database_default_hostname=dbpostgres
database_default_database=appstarter_db
database_default_username=appstarter_user
database_default_password=appstarter_password
database_default_DBDriver=Postgre
database_default_port=5432
```

## Reutilización de variables

En caso de que hayas personalizo la configuración de usuario, password y nombre de la base de datos, en vez de
estar repitiendo en los pasos anteriores los mismos valores, puedes utilizar las variables al inicio del fichero:

```dotenv
database_default_database=${DB_NAME}
database_default_username=${DB_USER}
database_default_password=${DB_PASSWORD}
```

# Inicio y prueba de la aplicación

Para probar que está todo correcto, primero levanta los contenedores con el comando:

```shell
make restart
```

Y en el navegador visita la url [https://localhost](https://localhost)

> En caso de que aparezca un aviso de riesgo potencial, pulsa en avanzado...
> y después en Aceptar el riesgo y continuar

Esto es debido a que el certificado es autofirmado, pero no lo volverá a pedir.

Para probar la conexión con la base de datos, puedes entrar en el contenedor de PHP

```shell
make ssh-be
```

Y en el contendor, ejecutar este comando:

```shell
php spark db:table
```

Si todo está bien, verás un mensaje de error indicando que no hay tablas:

```text
Database has no tables!
```
