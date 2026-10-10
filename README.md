# Ultra mini sistema operativo

Un pequeño _sistema operativo_, o al menos un sistema de arranque, con dos comandos que imprimen una cadena de texto.


## Instalación y uso

### Modalidad 1

Se instala el programa **Qemu**:

```bash
sudo dnf install @virtualization
```
Ulteriormente, se descarga el compilador **ASM** (**NASM**) y se instala:

```bash
sudo dnf install ./nasm-3.02-0.fc43.x86_64.rpm -y
```
> [!NOTE]
> Ingresa el nombre correcto del archivo **rpm** que usted descargó.

Una vez realizado lo anterior, compilamos el archivo `boot.asm`:

```bash
nasm -fbin boot.asm
```

Ejecutamos el sistema operativo:

```bash
qemu-system-x86_64 -fda boot
```

Y ya puedes explorar el software.

### Modalidad 2

Descarga el binario correspondiente en la sección [Releases](https://github.com/rosendocamal/ultramini-os/releases) de este repositorio y una vez descarga ingresa en su terminal y ejecuta el binario con:

```bash
qemu-system-x86_64 -fda boot
```
> [!IMPORTANT]
> Se requiere instalar el programa de virtualización **Qemu** antes de ejecutar el comando anterior.

## Licencia

El código se publica bajo la licencia MIT. Consulta el archivo [LICENSE.](LICENSE)

## Autor

Proyecto desarrollado por **Rosendo Camal**.

Contacto:
+ [GitHub](https://www.github.com/rosendocamal)
+ [Linkedin](https://www.linkedin.com/in/rosendocamal)
