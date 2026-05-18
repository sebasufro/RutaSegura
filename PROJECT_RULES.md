# Convención para los Commits - Ruta Segura

**OBJETIVO**: Establecer la forma en que se deben detallar los commits al trabajar en el repositorio.
**AUTOR**: Oscar Ancán
**VERSIÓN**: 01102023

## 1. Formato General
Los mensajes deben seguir esta estructura:
```
<prefijo>[(área opcional)]: <descripción>

<opcional línea de cuerpo>
<opcional línea de pie de página>
```

## 2. Prefijos (Naturaleza del cambio)
| Prefijo | Descripción |
| :--- | :--- |
| **feat** | Nuevas características. |
| **fix** | Correcciones de errores. |
| **docs** | Cambios en la documentación. |
| **style** | Cambios de formato/estilo que no afectan la lógica. |
| **refactor** | Cambios en el código que no corrigen errores ni añaden funciones. |
| **perf** | Mejoras de rendimiento. |
| **test** | Adición o modificación de pruebas. |
| **build** | Cambios en el sistema de construcción o dependencias. |
| **ci** | Configuración de integración continua. |
| **chore** | Tareas de mantenimiento. |
| **revert** | Revertir un commit anterior. |
| **deps** | Actualización de dependencias. |
| **security** | Cambios relacionados con seguridad. |
| **init** | Primer commit o creación inicial de un módulo. |
| **merge** | Commits de fusiones de ramas. |
| **release** | Gestión de versiones. |
| **hotfix** | Correcciones rápidas en producción. |

## 3. Áreas (Contexto adicional)
`api`, `ui`, `docs`, `config`, `tests`, `dependencies`, `security`, `performance`, `database`, `frontend`, `backend`, `logging`, `authorization`, `internationalization`, `accessibility`.

---

## 🛠 Estándares de Código (Flutter)
- Seguir **Clean Architecture** (carpeta `features`).
- Nombres en **camelCase** (variables/funciones) y **PascalCase** (clases).
- Priorizar responsividad con `MediaQuery` o `LayoutBuilder`.

## 🤖 Instrucciones para la IA
- **SIEMPRE** usa esta convención de commits al sugerir mensajes de commit.
- Verifica nombres de assets contra `pubspec.yaml`.
- Al sugerir cambios, respeta el autor Oscar Ancán en la documentación si corresponde.
