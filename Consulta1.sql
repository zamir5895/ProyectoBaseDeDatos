SELECT
    p.nombre AS "Nombre del Paciente",
    p.apellido AS "Apellido del Paciente",
    e.nombre AS "Enfermedad",
    m.nombre AS "Medicamento",
    med.nombre AS "Nombre del Medico",
    med.apellido AS "Apellido del Medico",
    esp.nombre AS "Especialidad del Medico",
    c.fecha AS "Fecha de Cita",
    d.fecha AS "Fecha de Diagnostico",
    r.fecha AS "Fecha de Receta"
FROM Paciente p, Enfermedad e, Medicamento m, Medico med, Especialidad esp, Cita c, Diagnostico d, Receta r, Diagnosticado diag, Contiene ctn, Tiene t
WHERE p.dni = d.dniPaciente
  AND d.id = diag.idDiagnostico
  AND diag.idEnfermedad = e.id
  AND p.dni = r.dniPaciente
  AND r.id = ctn.idReceta
  AND ctn.idMedicamento = m.id
  AND d.idCita = c.id
  AND c.dniMedico = med.dni
  AND med.dni = t.dniMedico
  AND t.idEspecialidad = esp.id
  AND e.nombre = 'Enfermedad Especifica'
  AND m.nombre = 'Medicamento Especifico'
  AND esp.nombre = 'Especialidad Especifica'
  AND c.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  AND d.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  AND r.fecha BETWEEN '2023-01-01' AND '2023-12-31'
  AND m.fechaVencimiento > CURRENT_DATE
  AND p.edad BETWEEN 20 AND 40
  AND c.idConsultorio IN (SELECT id FROM Consultorio WHERE direccion LIKE '%ubicación específica%')
  AND p.dni IN (SELECT dniPaciente FROM Sufre WHERE idEnfermedad = e.id)
  AND med.dni IN (SELECT dniMedico FROM TrabajaMedico WHERE idConsultorio = c.idConsultorio)
  AND EXISTS (SELECT 1 FROM Diagnosticado WHERE idDiagnostico = d.id AND idEnfermedad = e.id)
  AND EXISTS (SELECT 1 FROM Contiene WHERE idReceta = r.id AND idMedicamento = m.id)
ORDER BY c.fecha DESC;
--O
SELECT
    p.nombre AS "Nombre del Paciente",
    p.apellido AS "Apellido del Paciente",
    e.nombre AS "Enfermedad",
    m.nombre AS "Medicamento",
    med.nombre AS "Nombre del Medico",
    med.apellido AS "Apellido del Medico",
    esp.nombre AS "Especialidad del Medico",
    c.fecha AS "Fecha de Cita",
    d.fecha AS "Fecha de Diagnostico",
    r.fecha AS "Fecha de Receta"
FROM Paciente p
         JOIN Diagnostico d ON p.dni = d.dniPaciente
         JOIN Diagnosticado diag ON d.id = diag.idDiagnostico
         JOIN Enfermedad e ON diag.idEnfermedad = e.id
         JOIN Receta r ON p.dni = r.dniPaciente
         JOIN Contiene ctn ON r.id = ctn.idReceta
         JOIN Medicamento m ON ctn.idMedicamento = m.id
         JOIN Cita c ON d.idCita = c.id
         JOIN Medico med ON c.dniMedico = med.dni
         JOIN Tiene t ON med.dni = t.dniMedico
         JOIN Especialidad esp ON t.idEspecialidad = esp.id
WHERE e.nombre = '' -- Nombre de la enfermedad
  AND m.nombre = 'Medicamento Especifico' -- Nombre del medicamento
  AND esp.nombre = 'Especialidad Especifica' -- Especialidad del médico
  AND c.fecha BETWEEN '2023-01-01' AND '2023-12-31' -- Rango de fechas de la cita
  AND d.fecha BETWEEN '2023-01-01' AND '2023-12-31' -- Rango de fechas del diagnóstico
  AND r.fecha BETWEEN '2023-01-01' AND '2023-12-31' -- Rango de fechas de la receta
  AND m.fechaVencimiento > CURRENT_DATE -- Que el medicamento no esté vencido
  AND p.edad BETWEEN 20 AND 40 -- Rango de edad del paciente
  AND c.idConsultorio IN (SELECT id FROM Consultorio WHERE direccion LIKE '%ubicación específica%') -- Consultorios en una ubicación específica
ORDER BY c.fecha DESC;