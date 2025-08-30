docs/config/generateFirstBlock.md
# generateFirstBlock – Creación del Bloque Génesis

Este archivo explica cómo crear el **bloque génesis** (primer bloque de la red) en IBAX.  
El bloque génesis es fundamental porque define los parámetros iniciales de la blockchain.

## Ejemplo de uso
```bash
./ibax generateFirstBlock --public-key=public.key

Resultado
Se crea un archivo de bloque génesis en la carpeta de configuración.

Este archivo incluye:

ID de red

Timestamp de creación

Llave pública del nodo inicial

Firma digital

Recomendaciones

Usa la llave pública generada previamente con generateKeys.

Conserva el bloque génesis como respaldo: todos los nodos de la red deben partir de él.

No modifiques el archivo después de su creación.

---

Con esto tendrías el **tercer archivo** de la Fase II.  

