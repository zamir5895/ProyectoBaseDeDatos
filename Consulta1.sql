
--Cuáles médicos han diagnosticado enfermedades que han sido diagnosticadas
-- más de cinco veces en el año 2022, cuántas consultas han realizado
-- y cuáles son los nombres de los pacientes y las enfermedades asociadas
--Ayuda a analizar los patrones de diagnóstico de enfermedades en el año 2022,
--y asi asignar asignar recursos eficientemente, evaluar la calidad de atención,
SELECT
    med.dni AS "DNI del Médico",
    p.nombre AS "Nombre del Paciente",
    COUNT(med.dni) AS "Cantidad de Consultas",
    e.nombre AS "Nombre de la Enfermedad"
FROM
    Cita c
        JOIN Medico med ON (c.dniMedico = med.dni)
        JOIN Paciente p ON (c.dniPaciente = p.dni)
        JOIN Diagnostico d ON (p.dni = d.dniPaciente)
        JOIN Diagnosticado diag ON (d.id = diag.idDiagnostico)
        JOIN Enfermedad e ON (diag.idEnfermedad = e.id)
WHERE
    e.nombre IN (
        SELECT
            nombre
        FROM (
                 SELECT
                     e.nombre,
                     COUNT(diag.idEnfermedad) AS total_diagnosticos
                 FROM
                     Enfermedad e
                         JOIN Diagnosticado diag ON e.id = diag.idEnfermedad
                         JOIN Diagnostico d ON diag.idDiagnostico = d.id
                         JOIN Cita c ON d.idCita = c.id
                 WHERE
                     EXTRACT(YEAR FROM c.fecha) = '2022'
                 GROUP BY
                     e.nombre
             ) AS Subconsulta
        WHERE
            total_diagnosticos > 5
    )
GROUP BY
    med.dni, p.nombre, e.nombre
ORDER BY
    "Cantidad de Consultas" DESC;
--Consulta para seleccionar los médicos que han diagnosticado
-- más de 5 veces una enfermedad en el año 2022