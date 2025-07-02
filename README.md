# Buscador de Valores en Base de Datos SQL Server

Este proyecto contiene un script SQL Server que permite buscar un valor específico en todas las tablas y columnas de tipo texto de una base de datos.

## 📋 Descripción

El script `buscarValorTabla.sql` es una herramienta útil para realizar búsquedas exhaustivas de valores específicos en toda una base de datos SQL Server. En este caso particular, está configurado para buscar el valor "soltero" en todas las columnas de tipo texto.

## 🚀 Características

- **Búsqueda exhaustiva**: Analiza todas las tablas y columnas de tipo texto en la base de datos
- **Resultado único**: Muestra un solo resumen al final del proceso
- **Manejo de errores**: Continúa la búsqueda aunque encuentre errores en alguna tabla
- **Estadísticas completas**: Proporciona un resumen con el total de columnas analizadas
- **Filtrado inteligente**: Solo muestra las tablas/columnas que contienen el valor buscado

## 📊 Tipos de datos soportados

El script busca en columnas con los siguientes tipos de datos:
- `varchar`
- `nvarchar` 
- `char`
- `nchar`
- `text`
- `ntext`

## 🔧 Instalación y Uso

### Prerrequisitos
- SQL Server Management Studio (SSMS) o cualquier cliente SQL Server
- Permisos de lectura en la base de datos objetivo

### Instrucciones de uso

1. **Conectarse a la base de datos**:
   ```sql
   USE [NombreDeTuBaseDeDatos]
   ```

2. **Ejecutar el script**:
   - Abrir el archivo `buscarValorTabla.sql` en SSMS
   - Ejecutar el script completo (F5)

3. **Personalizar la búsqueda** (opcional):
   - Cambiar `'%soltero%'` por el valor que deseas buscar
   - Modificar el esquema si no es 'dbo': `AND t.TABLE_SCHEMA = 'tu_esquema'`

## 📈 Ejemplo de salida

```
=======================================================
BÚSQUEDA COMPLETADA - RESUMEN FINAL
=======================================================
Total de columnas analizadas: 150
Columnas con coincidencias: 3
Columnas sin coincidencias: 147
=======================================================

Tabla        Columna           Registros con "soltero"    Estado
Empleados    EstadoCivil       25                         ENCONTRADO
Clientes     Observaciones     2                          ENCONTRADO
Personas     InfoAdicional     1                          ENCONTRADO
```

Si no se encuentran resultados:
```
NO SE ENCONTRÓ EL VALOR "soltero" EN NINGUNA TABLA/COLUMNA
```

## ⚙️ Configuración avanzada

### Ver todas las columnas analizadas
Para ver un detalle completo de todas las columnas procesadas (incluyendo las que no tienen coincidencias), descomenta la sección al final del script:

```sql
PRINT ''
PRINT '--- DETALLE COMPLETO DE TODAS LAS COLUMNAS ANALIZADAS ---'
SELECT 
    TableName AS 'Tabla',
    ColumnName AS 'Columna',
    FoundCount AS 'Registros',
    Status AS 'Estado'
FROM @Results
ORDER BY Status DESC, TableName, ColumnName
```

### Cambiar el valor de búsqueda
Modifica esta línea para buscar otros valores:
```sql
SET @SQL = N'SELECT @Count = COUNT(*) FROM [' + @TableName + '] WHERE [' + @ColumnName + '] LIKE ''%soltero%'''
```

Por ejemplo, para buscar "casado":
```sql
SET @SQL = N'SELECT @Count = COUNT(*) FROM [' + @TableName + '] WHERE [' + @ColumnName + '] LIKE ''%casado%'''
```

## 🔍 Casos de uso

- **Auditoría de datos**: Verificar la consistencia de valores en diferentes tablas
- **Migración de datos**: Identificar registros que requieren actualización
- **Limpieza de datos**: Encontrar valores que necesitan estandarización
- **Análisis de contenido**: Buscar patrones específicos en los datos

## ⚠️ Consideraciones importantes

- El script puede tomar tiempo considerable en bases de datos grandes
- Se recomienda ejecutar en horarios de bajo uso del sistema
- El uso de LIKE con wildcards puede impactar el rendimiento
- Asegúrate de tener los permisos necesarios antes de ejecutar

## 🤝 Contribución

Si encuentras mejoras o errores, por favor:
1. Abre un issue describiendo el problema
2. Propón cambios mediante pull requests
3. Documenta cualquier modificación importante

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

**Juan Ochoa** - INMEL INGENIERIA SAS

---

*Última actualización: Julio 2025*
