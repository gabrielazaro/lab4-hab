# Proyecto: Arquitectura en AWS - Laboratorio 4

Este repositorio documenta la arquitectura de red implementada en AWS como parte de un laboratorio de aprendizaje. A continuación, se detallan los componentes utilizados, la distribución en subredes y zonas de disponibilidad, y las funcionalidades principales de cada elemento en la arquitectura.

## Descripción de la Arquitectura

La arquitectura desplegada utiliza diversos servicios de AWS en la región `us-east-1` con el objetivo de proveer alta disponibilidad, balanceo de carga, escalabilidad automática, y almacenamiento persistente. Esta arquitectura sigue las mejores prácticas de seguridad y eficiencia en la nube.

## Componentes Principales

- **VPC (Virtual Private Cloud):**
  - **CIDR:** `10.0.0.0/16`
  - Contiene varias subredes distribuidas en distintas zonas de disponibilidad (`us-east-1a` y `us-east-1b`).

- **Subredes Públicas y Privadas:**
  - **Subredes Públicas** (`10.0.1.0/24` y `10.0.2.0/24`):
    - Utilizadas para el acceso a Internet y la configuración del balanceador de carga.
  - **Subredes Privadas:**
    - **Aplicación** (`10.0.3.0/24` y `10.0.4.0/24`): Implementación de instancias EC2 para la aplicación en un grupo de autoescalado.
    - **Base de Datos** (`10.0.5.0/24`, `10.0.6.0/24`): Configuradas para PostgreSQL en modo redundante.
    - **Redis Cache** (`10.0.7.0/24`, `10.0.8.0/24`): Subredes dedicadas a la caché de Redis.

- **Balanceador de Carga (ELB):**
  - Asocia las subredes públicas en las zonas de disponibilidad `us-east-1a` y `us-east-1b`.
  - Distribuye tráfico a las instancias EC2 en el grupo de autoescalado para mejorar la disponibilidad y el rendimiento.

- **Auto Scaling Group:**
  - Gestiona las instancias EC2 distribuidas en subredes privadas.
  - Permite la escalabilidad automática para ajustarse a la demanda de la aplicación.

- **Almacenamiento de Datos:**
  - **PostgreSQL:** Bases de datos distribuidas en subredes privadas en ambas zonas de disponibilidad para garantizar alta disponibilidad.
  - **Redis Cache:** Proporciona almacenamiento en caché de datos para optimizar el rendimiento de la aplicación.

- **Servicios Adicionales de AWS:**
  - **Route 53:** Servicio de DNS para gestionar el enrutamiento de solicitudes de usuario.
  - **CloudWatch:** Monitorea los recursos, el rendimiento y los logs de la infraestructura desplegada.
  - **S3 Bucket:** Proporciona almacenamiento de objetos, usado para almacenamiento de archivos estáticos o backups.

## Configuración del Estado Remoto con Terraform

Para mejorar la seguridad y consistencia de la infraestructura, el estado de Terraform (`tfstate`) se almacena en un bucket de S3. Esta configuración permite:
- **Respaldo:** S3 asegura la persistencia del archivo de estado.
- **Bloqueo de Estado (Locking):** Para evitar cambios simultáneos en la infraestructura, se usa una tabla de DynamoDB para el bloqueo del estado, lo que previene la corrupción del `tfstate`.

## Estructura de la Red

La red está organizada en dos zonas de disponibilidad (`us-east-1a` y `us-east-1b`) para maximizar la disponibilidad y la tolerancia a fallos.

| Zona de Disponibilidad | Subred Pública | Subred Privada de Aplicación | Subred Privada de BD | Subred Privada de Redis |
|------------------------|----------------|------------------------------|-----------------------|--------------------------|
| us-east-1a             | 10.0.1.0/24    | 10.0.3.0/24                  | 10.0.5.0/24          | 10.0.7.0/24              |
| us-east-1b             | 10.0.2.0/24    | 10.0.4.0/24                  | 10.0.6.0/24          | 10.0.8.0/24              |

## Recomendaciones de Seguridad

Para mejorar la seguridad de la infraestructura, se podría implementar las siguientes prácticas adicionales:

1. **Uso de SSL:**
   - Para proteger el tráfico entre los usuarios y el balanceador de carga, se recomienda habilitar SSL en la capa de transporte. Esto asegura que los datos se transmitan de forma segura, evitando que terceros puedan interceptarlos.

2. **AWS Certificate Manager (ACM):**
   - AWS Certificate Manager facilita la obtención y renovación automática de certificados SSL para proteger las comunicaciones. Este servicio podría ser muy útil para simplificar la gestión de certificados y reducir riesgos de caducidad de los mismos.

3. **AWS Secrets Manager:**
   - Para una gestión segura de las credenciales de la base de datos, hubiera sido ideal integrar AWS Secrets Manager. Pero su implementación en la aplicación no fue posible. Este servicio es altamente recomendable en un entorno de producción o de prueba para garantizar la seguridad de los datos y comunicaciones.

## Nota

Durante la creación de la AMI para realizar una web dinámica desde la cual se pudiera acceder desde CloudFront, la configuración del CMS no se completó por razones de tiempo. Para comprobar si el navegador está funcionando, se puede acceder al directorio `/prueba`. El bucket del state está abierto para que el instructor pueda acceder a el para la correción.