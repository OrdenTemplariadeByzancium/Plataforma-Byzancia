Guía de Contribución – Plataforma Byzancia Exchange

Gracias por tu interés en contribuir a la **Plataforma Byzancia Exchange**, iniciativa de la Orden Templaria de Bizancio.  
Este documento explica cómo colaborar de forma ordenada, técnica y en armonía con el marco ceremonial del proyecto.

Reglas generales
- Todo contribuidor debe respetar la **Licencia Propia Templaria (LPT v1.0)**.
- Cada propuesta de cambio debe alinearse con la misión del Orden: fraternidad, sostenibilidad y equilibrio.
- Se aceptan contribuciones en **español, inglés o checo**.

Flujo de trabajo (adaptado al ecosistema templario)
1. **Clona el repositorio oficial** en tu equipo local:
   bash
   git clone https://github.com/OrdenTemplariadeByzancium/Plataforma-Bizancio.git
   cd Plataforma-Bizancio
   
2. Crea una nueva rama para tu cambio:
Para nuevas funciones:

git checkout -b feat/nombre-del-modulo
Ejemplo: feat/dao-votaciones

Para correcciones:
git checkout -b fix/nombre-del-error
Ejemplo: fix/correccion-subastas

3. Realiza tus cambios en código, documentación o imágenes.

4. Registra tus cambios con un commit claro y ceremonial:
git add .
git commit -m "feat: integración inicial del módulo Penélope (wallets)"

5. Envía los cambios al repositorio remoto:
git push origin nombre-de-la-rama

Crea un Pull Request (PR) hacia la rama principal para revisión y validación.

Describe el cambio realizado.

Cada PR será revisado en clave técnica y ceremonial antes de fusionarse.

Estilo de commits

Usamos convención tipo Conventional Commits:

feat: → nueva funcionalidad

fix: → corrección de errores

docs: → cambios en documentación

style: → formato/código (sin cambiar lógica)

refactor: → cambios internos sin alterar comportamiento externo

test: → añadir o modificar pruebas

Issues
- Usa los **Issues** para reportar errores, proponer mejoras o abrir debates.
- Etiqueta correctamente (`bug`, `feature`, `doc`, `discussion`).
- Sé claro, respeta el marco ceremonial: cada aporte debe sumar al equilibrio del proyecto.

*Contribuir aquí es más que escribir código: es participar en la construcción de un Altar digital de servicio.*
