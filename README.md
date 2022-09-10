# PHP 8.1 para CodeIgniter 4

Configuración de Docker con Docker Compose para poder levantar de forma rápida un entorno de desarrollo para
[CodeIgniter 4](https://codeigniter.com/).

Esta configuración genera los siguientes contenedores:

- **appstarter-fe**: Servidor NGINX 1.23.1. Está disponible http y https (con certificado autofirmado con lo que la primera
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

```shell
cihispano@pc:~$ composer create-project codeigniter4/appstarter mi-proyecto
cihispano@pc:~$ cd mi-proyecto
```

## Instalación de PHP 8.1 para Codeigniter

### Preparación del entorno de desarrollo

El equipo en el que vas a hacer la instalación debe tener instalado y configurado (depende de tu sistema operativo):

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Comando GNU `Make`

## Descarga del repositorio

Descarga este repositorio y después descomprímelo en cualquier ruta.

A continuación, copia los siguientes ficheros y directorios a la raíz del proyecto de Codeigniter 4 que
acabas descargar en el punto anterior:

- 📁 `docker`
- 📝 `Makefile`
- 📝 `docker-compose.yml`

## Configuración de Docker Compose

### Fichero `docker/env` y los valores por defecto

Las variables de entorno no tienen asignados unos valores por defecto para configurar el acceso a la base de datos.

**Debes copiar el fichero `docker/dist.env` con el nombre `docker/.env`**.

Los valores que definen son:

- **DB_USER**: appstarter_user
- **DB_PASSWORD**: appstarter_password
- **DB_NAME**: appstarter_db

Para copiarlo, si estás en Linux o Mac, puedes utilizar el comando:

```shell
cihispano@pc:~/mi-proyecto$ cp docker/dist.env docker/.env
```

En windows puedes hacerlo con el explorador de archivos.

### Fichero `docker-compose.yml`

Antes de generar las imágenes, puedes modificar el fichero para cambiar la configuración según tus necesidades.

Por ejemplo, si no vas a utilizar base de datos o bien sólo necesitas una de ellas, borra la que no necesites.

Además, en el contendor de PHP hay dos líneas comentadas que puedes descomentar según el sistema operativo que estés
utilizando:

- **\# - ~/.ssh:/home/usuario/.ssh:ro**: inyecta en el contedor la configuración de ssh que tienes en tu equipo. De
esta forma, desde el contenedor puedes hacer **git pull**, **git push**, **composer require PAQUETE**, **ssh**, etc.
como si estuvieses con tu usuario en tu máquina.
- **\# - ~/.gitconfig:/home/usuario/.gitconfig:ro**: copia tu configuración local de git al propio contenedor.

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
cihispano@pc:~/mi-proyecto$ make build
```

Y espera a que terminen de crearse. Debería de aparecerte un mensaje similar a este:

```
Successfully tagged mi-proyecto_appstarter-be:latest
```

Si todo ha ido correctamente, puedes arrancar los servicios con el comando:

```shell
cihispano@pc:~/mi-proyecto$ make start
```

## Comando make

### Ver utilidades disponibles

```shell
cihispano@pc:~/mi-proyecto$ make help
```

### Entrar en el contenedor de PHP para ejecutar comandos

```shell
cihispano@pc:~/mi-proyecto$ make ssh-be
```

Y una vez dentro puedes comprobar la versión de PHP instalada:

```shell
usuario@appstarter-be:/app$ php -v
PHP 8.1.6 (cli) (built: May 13 2022 22:28:45) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.1.6, Copyright (c) Zend Technologies
    with Zend OPcache v8.1.6, Copyright (c), by Zend Technologies
    with Xdebug v3.2.0alpha3, Copyright (c) 2002-2022, by Derick Rethans
```

A entrar, ya estás directamente en el directorio raiz de la aplicación.

Para salir, utiliza el comando exit:

```shell
usuario@appstarter-be:/app$ exit
```

### Para los contenedores

La configuración en el docker-compose es que los servicios se vuelvan a levantar aunque reinicies tu equipo. Para
pararlos, ejecuta el comando:

```shell
cihispano@pc:~/mi-proyecto$ make stop
```

O para reiniciarlos, con:

```shell
cihispano@pc:~/mi-proyecto$ make restart
```

## Configuración de CI4

En este punto se explica la configuración mínima para poder probar todo el entorno, incluyendo las bases de datos.

Para ver la configuración de forma más detallada, consulta la
[documentación oficial](https://codeigniter.com/user_guide/installation/running.html#initial-configuration).

Primero hay que copiar el fichero **env** con el nombre **.env**:

```shell
cihispano@pc:~/mi-proyecto$ cp env .env
```

O bien con el explorador de archivos si estás utilizando Windows.

Después, edita el fichero **.env** y modifica las siguientes líneas:

```dotenv
CI_ENVIRONMENT = development
app.baseURL = 'https://localhost/'
```

Según la base de datos que estés utilizando

### MariaDB

```dotenv
database.default.hostname = dbmysql
database.default.database = appstarter_db
database.default.username = appstarter_user
database.default.password = appstarter_password
database.default.DBDriver = MySQLi
# database.default.DBPrefix =
database.default.port = 3306
```

### PostgreSQL

```dotenv
database.default.hostname = dbpostgres
database.default.database = appstarter_db
database.default.username = appstarter_user
database.default.password = appstarter_password
database.default.DBDriver = Postgre
# database.default.DBPrefix =
database.default.port = 5432
```

Recuerda que si en el fichero docker/.env has modificado alguno de estos valores, tienes que poner los que has
personalizado.

## Inicio y prueba de la aplicación

Para probar que está todo correcto, primero levanta los contenedores con el comando:

```shell
cihispano@pc:~/mi-proyecto$ make restart
```

Y en el navegador visita la url [https://localhost](https://localhost)

> En caso de que aparezca un aviso de riesgo potencia, pulsa en avanzado...
> y después en Aceptar el riesgo y continuar

Esto es debido a que el certificado es autofirmado, pero no lo volverá a pedir.

Para probar la conexión con la base de datos, puedes entrar en el contenedor de PHP

```shell
cihispano@pc:~/mi-proyecto$ make ssh-be
```

Y en el contendor, ejecutar este comando:

```shell
usuario@appstarter-be:/app$ php spark db:table
```

Si todo está bien, verás un mensaje de error indicando que no hay tablas:

```text
Database has no tables!
```
