# 🔧 USB Army Knife - Firmware para LILYGO T-Watch S3

## 📦 Contenido del Firmware

Este directorio contiene el firmware compilado para el dispositivo **LILYGO T-Watch S3** del proyecto USB Army Knife.

### Archivos Incluidos

- `bootloader.bin` - Bootloader del ESP32-S3 (19KB)
- `partitions.bin` - Tabla de particiones (3KB)  
- `firmware.bin` - Firmware principal de USB Army Knife (2.2MB)
- `manifest.json` - Manifest para ESPWebTool
- `index.html` - Página web de instalación

## 🚀 Métodos de Instalación

### Método 1: ESPWebTool (Recomendado)

1. Abre `index.html` en un navegador compatible (Chrome, Edge, Opera)
2. Conecta tu LILYGO T-Watch S3 via USB
3. Haz clic en "📥 Instalar USB Army Knife"
4. Sigue las instrucciones en pantalla

### Método 2: Línea de Comandos (esptool)

```bash
# Instalar esptool si no lo tienes
pip install esptool

# Borrar la flash (opcional pero recomendado)
esptool.py --chip esp32s3 --port /dev/ttyACM0 erase_flash

# Escribir el firmware completo
esptool.py --chip esp32s3 --port /dev/ttyACM0 --baud 460800 write_flash \
    0x0 bootloader.bin \
    0x8000 partitions.bin \
    0x10000 firmware.bin
```

### Método 3: PlatformIO

```bash
# Desde el directorio raíz del proyecto
pio run -e LILYGO-T-Watch-S3 -t upload
```

## 📱 Dispositivo Compatible

### LILYGO T-Watch S3 Especificaciones

- **Microcontrolador**: ESP32-S3 Dual-core Xtensa @ 240MHz
- **Flash Memory**: 16MB
- **RAM**: 320KB SRAM + 8MB PSRAM  
- **Pantalla**: 1.54" IPS TFT 240x240 píxeles
- **Conectividad**: WiFi 802.11 b/g/n, Bluetooth 5.0
- **Interfaces**: USB-C, Pantalla táctil capacitiva
- **Sensores**: Micrófono I2S, Emisor IR, Sensor táctil
- **Batería**: 300mAh LiPo integrada

## ⚠️ Advertencias Importantes

1. **Compatibilidad**: Este firmware está específicamente compilado para LILYGO T-Watch S3. No lo uses en otros dispositivos.

2. **Pérdida de datos**: La instalación borrará completamente el firmware existente y todos los datos del dispositivo.

3. **Navegador compatible**: Para usar ESPWebTool necesitas Chrome, Edge, Opera o navegadores basados en Chromium con Web Serial API.

4. **Puerto serie**: En algunos sistemas puede requerir drivers adicionales para el chip USB-Serial del dispositivo.

## 🌐 Acceso Después de la Instalación

### Modo Access Point (AP)
- **SSID**: `USBArmyKnife_XXXXXX` 
- **Password**: `usbarmy123`
- **IP**: `192.168.4.1`
- **URL**: http://192.168.4.1

### Modo Station (STA) 
Configurable desde la interfaz web una vez conectado en modo AP.

## 🔧 Características del Firmware

### Capacidades Principales

- **DuckyScript Engine**: Ejecución completa de payloads DuckyScript
- **ESP32 Marauder**: Ataques WiFi/Bluetooth integrados
- **Interfaz Web Moderna**: Control completo desde navegador (ahora en español)
- **Gestión de Archivos**: Explorador integrado para payloads
- **Múltiples Layouts**: Soporte para diferentes distribuciones de teclado
- **Agent Commands**: Ejecución remota de comandos del SO
- **Audio Recording**: Captura de audio del dispositivo objetivo
- **VNC Access**: Acceso remoto al escritorio
- **OTA Updates**: Actualizaciones por aire

### Modos USB Disponibles

- **HID Keyboard**: Inyección de teclado
- **HID Mouse**: Control de ratón  
- **Mass Storage**: Almacenamiento masivo
- **CDC Serial**: Comunicación serie
- **NCM Ethernet**: Adaptador Ethernet USB

## 📊 Información de Compilación

- **Fecha**: 27 de septiembre de 2025
- **Versión**: `ab7d82d93c1ee93bdcaebb2b0174d089e388be13`
- **Entorno**: `LILYGO-T-Watch-S3`
- **Framework**: Arduino ESP32 v3.0.5
- **Tamaño RAM**: 32.6% utilizado (106,816 / 327,680 bytes)
- **Tamaño Flash**: 69.3% utilizado (2,315,593 / 3,342,336 bytes)

## 🛠️ Solución de Problemas

### El dispositivo no se detecta
1. Verifica que el cable USB transmita datos (no solo carga)
2. Instala los drivers del chip USB-Serial si es necesario
3. Presiona el botón BOOT mientras conectas para entrar en modo flash

### Error en la instalación
1. Asegúrate de usar un navegador compatible (Chrome/Edge)
2. Cierra otros programas que puedan usar el puerto serie
3. Reinicia el dispositivo y vuelve a intentar

### El dispositivo no arranca después de la instalación
1. Desconecta y reconecta el dispositivo
2. Presiona el botón RESET si está disponible
3. Verifica que todos los archivos se escribieron correctamente

## 📞 Soporte

Para problemas, reportes de bugs o solicitudes de características:

- **GitHub Issues**: https://github.com/vsh00t/USBArmyKnife/issues
- **Documentación**: Ver carpeta `docs/` del proyecto
- **Ejemplos**: Ver carpeta `examples/` del proyecto

## 📄 Licencia

Este proyecto está licenciado bajo los términos especificados en el archivo LICENSE del repositorio principal.

---

**⚡ ¡Disfruta usando USB Army Knife de forma responsable y ética! ⚡**