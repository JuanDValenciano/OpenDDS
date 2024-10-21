# Usamos una imagen base de Ubuntu
FROM ubuntu:16.04

ARG TARGETARCH

# Instalar dependencias y tzdata de manera no interactiva
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    cmake \
    tar \
    perl \
    tzdata \
    libssl-dev \
    bash \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Configurar la zona horaria automáticamente
ENV TZ=America/Bogota

RUN mkdir /opt/opendds

RUN wget https://github.com/objectcomputing/OpenDDS/releases/download/DDS-3.9/OpenDDS-3.9.tar.gz -P /opt/opendds/

WORKDIR /opt/opendds

RUN tar --strip-components=1 -xvf OpenDDS-3.9.tar.gz

# Configurar OpenDDS
RUN ./configure --prefix=/usr/local

# Compilar OpenDDS
RUN make -j$(nproc)

# Compilar los ejemplos de OpenDDS
RUN make examples

# Establecer variables de entorno necesarias para OpenDDS
ENV DDS_ROOT=/opt/opendds \
    ACE_ROOT=/opt/opendds/ACE_wrappers

# Comando para mantener el contenedor en ejecución y permitir acceso manual
CMD [ "bash" ]
