DECLARE @TableName NVARCHAR(256)
DECLARE @ColumnName NVARCHAR(256)
DECLARE @SQL NVARCHAR(MAX)
DECLARE @Count INT
DECLARE @TotalTables INT = 0
DECLARE @TablesWithResults INT = 0

-- Tabla para almacenar TODOS los resultados (con y sin coincidencias)
DECLARE @Results TABLE (
    TableName NVARCHAR(256),
    ColumnName NVARCHAR(256),
    FoundCount INT,
    Status NVARCHAR(50)
)

-- Cursor para recorrer todas las tablas y columnas de tipo texto
DECLARE column_cursor CURSOR FOR
SELECT 
    t.TABLE_NAME,
    c.COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.TABLES t
    INNER JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_NAME = c.TABLE_NAME
WHERE 
    t.TABLE_TYPE = 'BASE TABLE'
    AND c.DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar', 'text', 'ntext')
    AND t.TABLE_SCHEMA = 'dbo' -- Cambiar por el esquema deseado

OPEN column_cursor

FETCH NEXT FROM column_cursor INTO @TableName, @ColumnName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @TotalTables = @TotalTables + 1
    SET @Count = 0
    
    SET @SQL = N'SELECT @Count = COUNT(*) FROM [' + @TableName + '] WHERE [' + @ColumnName + '] LIKE ''%soltero%'''
    
    BEGIN TRY
        EXEC sp_executesql @SQL, N'@Count INT OUTPUT', @Count OUTPUT
        
        INSERT INTO @Results (TableName, ColumnName, FoundCount, Status)
        VALUES (
            @TableName, 
            @ColumnName, 
            @Count,
            CASE WHEN @Count > 0 THEN 'ENCONTRADO' ELSE 'SIN RESULTADOS' END
        )
        
        IF @Count > 0
            SET @TablesWithResults = @TablesWithResults + 1
            
    END TRY
    BEGIN CATCH
        INSERT INTO @Results (TableName, ColumnName, FoundCount, Status)
        VALUES (@TableName, @ColumnName, 0, 'ERROR')
    END CATCH
    
    FETCH NEXT FROM column_cursor INTO @TableName, @ColumnName
END

CLOSE column_cursor
DEALLOCATE column_cursor

-- RESULTADO FINAL ÚNICO
PRINT '======================================================='
PRINT 'BÚSQUEDA COMPLETADA - RESUMEN FINAL'
PRINT '======================================================='
PRINT 'Total de columnas analizadas: ' + CAST(@TotalTables AS VARCHAR(10))
PRINT 'Columnas con coincidencias: ' + CAST(@TablesWithResults AS VARCHAR(10))
PRINT 'Columnas sin coincidencias: ' + CAST((@TotalTables - @TablesWithResults) AS VARCHAR(10))
PRINT '======================================================='

-- Mostrar solo las tablas que tienen resultados
SELECT 
    TableName AS 'Tabla',
    ColumnName AS 'Columna',
    FoundCount AS 'Registros con "soltero"',
    Status AS 'Estado'
FROM @Results
WHERE Status = 'ENCONTRADO'
ORDER BY FoundCount DESC, TableName, ColumnName

-- Si no hay resultados, mostrar mensaje
IF @TablesWithResults = 0
BEGIN
    PRINT ''
    PRINT 'NO SE ENCONTRÓ EL VALOR "soltero" EN NINGUNA TABLA/COLUMNA'
    PRINT ''
END

-- Opcional: Para ver TODAS las tablas analizadas (comentado por defecto)
/*
PRINT ''
PRINT '--- DETALLE COMPLETO DE TODAS LAS COLUMNAS ANALIZADAS ---'
SELECT 
    TableName AS 'Tabla',
    ColumnName AS 'Columna',
    FoundCount AS 'Registros',
    Status AS 'Estado'
FROM @Results
ORDER BY Status DESC, TableName, ColumnName
*/