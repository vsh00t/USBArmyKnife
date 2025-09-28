#!/bin/bash

# USB Army Knife - Script de instalación para LILYGO T-Watch S3
# Versión: ab7d82d
# Fecha: 27 de septiembre de 2025

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si esptool está instalado
check_esptool() {
    if ! command -v esptool.py &> /dev/null; then
        print_error "esptool.py no está instalado."
        print_status "Instalando esptool..."
        pip3 install esptool
        print_success "esptool instalado correctamente"
    else
        print_success "esptool.py encontrado"
    fi
}

# Detectar puerto serie automáticamente
detect_port() {
    local ports
    
    # Buscar puertos serie comunes
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        ports=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || true)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ports=$(ls /dev/cu.usbserial* /dev/cu.usbmodem* 2>/dev/null || true)
    else
        ports=$(ls /dev/ttyUSB* /dev/ttyACM* /dev/cu.* 2>/dev/null || true)
    fi
    
    if [ -z "$ports" ]; then
        print_error "No se detectó ningún dispositivo serie"
        print_status "Conecta tu LILYGO T-Watch S3 via USB y vuelve a intentar"
        exit 1
    fi
    
    # Si hay múltiples puertos, mostrar lista
    local port_count=$(echo "$ports" | wc -l)
    if [ $port_count -gt 1 ]; then
        print_warning "Se detectaron múltiples puertos serie:"
        echo "$ports" | cat -n
        read -p "Selecciona el número del puerto correcto (1-$port_count): " selection
        PORT=$(echo "$ports" | sed -n "${selection}p")
    else
        PORT="$ports"
    fi
    
    print_success "Puerto seleccionado: $PORT"
}

# Verificar archivos de firmware
check_firmware_files() {
    local files=("bootloader.bin" "partitions.bin" "firmware.bin")
    
    print_status "Verificando archivos de firmware..."
    
    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            print_error "Archivo faltante: $file"
            print_status "Asegúrate de ejecutar este script desde el directorio firmware/"
            exit 1
        fi
        
        local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        print_success "$file ($size bytes)"
    done
}

# Función principal de instalación
install_firmware() {
    local erase_flash=${1:-true}
    local baud_rate=${2:-460800}
    
    print_status "Iniciando instalación del firmware USB Army Knife..."
    print_status "Dispositivo objetivo: LILYGO T-Watch S3 (ESP32-S3)"
    print_status "Puerto serie: $PORT"
    print_status "Velocidad: $baud_rate baud"
    
    if [ "$erase_flash" = true ]; then
        print_status "Borrando flash completa..."
        esptool.py --chip esp32s3 --port "$PORT" erase_flash
        print_success "Flash borrada"
        
        # Pequeña pausa después del borrado
        sleep 2
    fi
    
    print_status "Escribiendo firmware..."
    esptool.py --chip esp32s3 --port "$PORT" --baud "$baud_rate" write_flash \
        0x0 bootloader.bin \
        0x8000 partitions.bin \
        0x10000 firmware.bin
    
    print_success "¡Firmware instalado correctamente!"
    
    print_status "Verificando instalación..."
    esptool.py --chip esp32s3 --port "$PORT" verify_flash \
        0x0 bootloader.bin \
        0x8000 partitions.bin \
        0x10000 firmware.bin
    
    print_success "Verificación completada"
}

# Mostrar información del dispositivo
show_device_info() {
    print_status "Obteniendo información del dispositivo..."
    esptool.py --chip esp32s3 --port "$PORT" chip_id
    esptool.py --chip esp32s3 --port "$PORT" flash_id
}

# Función de ayuda
show_help() {
    cat << EOF
USB Army Knife - Script de Instalación de Firmware
Versión: ab7d82d (27 de septiembre de 2025)

Uso: $0 [OPCIONES]

OPCIONES:
    -h, --help          Mostrar esta ayuda
    -p, --port PORT     Especificar puerto serie manualmente
    -b, --baud RATE     Velocidad de baudios (default: 460800)
    --no-erase          No borrar flash antes de escribir
    --info              Solo mostrar información del dispositivo
    --verify            Solo verificar firmware existente

EJEMPLOS:
    $0                                  # Instalación automática
    $0 -p /dev/ttyUSB0                 # Puerto específico
    $0 -b 115200                       # Velocidad más lenta
    $0 --no-erase                      # Sin borrado previo
    $0 --info                          # Solo información

REQUISITOS:
    - Python 3 con esptool instalado
    - LILYGO T-Watch S3 conectado via USB
    - Archivos de firmware en el directorio actual

Para más información, consulta README.md
EOF
}

# Procesar argumentos de línea de comandos
PORT=""
BAUD_RATE=460800
ERASE_FLASH=true
INFO_ONLY=false
VERIFY_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -b|--baud)
            BAUD_RATE="$2"
            shift 2
            ;;
        --no-erase)
            ERASE_FLASH=false
            shift
            ;;
        --info)
            INFO_ONLY=true
            shift
            ;;
        --verify)
            VERIFY_ONLY=true
            shift
            ;;
        *)
            print_error "Opción desconocida: $1"
            print_status "Usa --help para ver las opciones disponibles"
            exit 1
            ;;
    esac
done

# Script principal
main() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}     USB Army Knife - Instalador de Firmware   ${NC}"
    echo -e "${BLUE}          LILYGO T-Watch S3 (ESP32-S3)        ${NC}" 
    echo -e "${BLUE}================================================${NC}"
    echo ""
    
    # Verificar esptool
    check_esptool
    
    # Detectar puerto si no se especificó
    if [ -z "$PORT" ]; then
        detect_port
    else
        print_status "Usando puerto especificado: $PORT"
    fi
    
    # Solo mostrar información del dispositivo
    if [ "$INFO_ONLY" = true ]; then
        show_device_info
        exit 0
    fi
    
    # Solo verificar firmware
    if [ "$VERIFY_ONLY" = true ]; then
        check_firmware_files
        print_status "Verificando firmware existente..."
        esptool.py --chip esp32s3 --port "$PORT" verify_flash \
            0x0 bootloader.bin \
            0x8000 partitions.bin \
            0x10000 firmware.bin
        exit 0
    fi
    
    # Verificar archivos de firmware
    check_firmware_files
    
    # Mostrar advertencia
    echo ""
    print_warning "¡ADVERTENCIA!"
    print_warning "Esta operación borrará completamente el firmware del dispositivo."
    print_warning "Asegúrate de que tienes el dispositivo correcto conectado."
    echo ""
    
    read -p "¿Continuar con la instalación? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Instalación cancelada por el usuario"
        exit 0
    fi
    
    # Instalar firmware
    install_firmware "$ERASE_FLASH" "$BAUD_RATE"
    
    echo ""
    print_success "¡Instalación completada exitosamente!"
    print_status "Desconecta y reconecta el dispositivo para iniciar"
    print_status "Accede a la interfaz web en: http://192.168.4.1"
    echo ""
}

# Ejecutar script principal
main "$@"