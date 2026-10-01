# Imagen base de Linux (Ubuntu LTS, ideal para prácticas)
FROM ubuntu:22.04

# Evita preguntas interactivas durante apt install
ENV DEBIAN_FRONTEND=noninteractive

# Herramientas mínimas: bash + timeout (coreutils) + ping/ip para diagnosticar
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    coreutils \
    iproute2 \
    iputils-ping \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia el script al contenedor
COPY check_port.sh /app/check_port.sh

# Da permiso de ejecución
RUN chmod +x /app/check_port.sh

# El puerto se pasa como argumento: docker run --rm port-checker 80
ENTRYPOINT ["/app/check_port.sh"]
CMD ["80"]
