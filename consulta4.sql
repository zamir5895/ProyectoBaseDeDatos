-- Consulta para obtener la cantidad promedio de medicamentos recetados a pacientes menores de 18 años
-- por cada doctor agrupado por la cantidad de especializaciones, y considerando solo doctores con más de 5 años de experiencia

SELECT
    num_especializaciones,
    AVG(cantidad_medicamentos) AS promedio_medicamentos
FROM (
         SELECT
             m.dni AS idMedico,
             COUNT(DISTINCT t.idEspecialidad) AS num_especializaciones,
             COUNT(co.idMedicamento) AS cantidad_medicamentos
         FROM Medico m
                  JOIN Tiene t ON m.dni = t.dniMedico
                  JOIN Receta r ON m.dni = r.dniMedico
                  JOIN Contiene co ON r.id = co.idReceta
                  JOIN Cita c ON r.idCita = c.id
                  JOIN Paciente p ON c.dniPaciente = p.dni
                  JOIN Persona per ON p.dni = per.dni
         WHERE
             per.edad < 18
           AND m.añoEgreso <= (EXTRACT(YEAR FROM CURRENT_DATE) - 5)
         GROUP BY
             m.dni
     ) AS doctor_medicamentos
GROUP BY
    num_especializaciones
ORDER BY
    num_especializaciones ASC;
--0
-- Consulta para obtener la cantidad promedio de medicamentos recetados a pacientes menores de 18 años
-- por cada doctor, agrupado por la cantidad de especializaciones, y considerando solo doctores con más de 5 años de experiencia

SELECT
    especializaciones.num_especializaciones,
    AVG(medicamentos.cantidad_medicamentos) AS promedio_medicamentos
FROM (
         -- Subconsulta para obtener el número de especializaciones por médico
         SELECT
             t.dniMedico,
             COUNT(DISTINCT t.idEspecialidad) AS num_especializaciones
         FROM Tiene t
         GROUP BY t.dniMedico
     ) AS especializaciones
         JOIN (
    -- Subconsulta para obtener la cantidad de medicamentos recetados a pacientes menores de 18 años por médico
    SELECT
        r.dniMedico,
        COUNT(co.idMedicamento) AS cantidad_medicamentos
    FROM Receta r
             JOIN Contiene co ON r.id = co.idReceta
    WHERE EXISTS (
        SELECT 1
        FROM Cita c
                 JOIN Paciente p ON c.dniPaciente = p.dni
                 JOIN Persona per ON p.dni = per.dni
        WHERE c.id = r.idCita
          AND per.edad < 18
    )
    GROUP BY r.dniMedico
) AS medicamentos ON especializaciones.dniMedico = medicamentos.dniMedico
         JOIN (
    -- Subconsulta para filtrar médicos con más de 5 años de experiencia
    SELECT
        m.dni
    FROM Medico m
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM m.añoEgreso) > 5
) AS medicos_experiencia ON especializaciones.dniMedico = medicos_experiencia.dni
GROUP BY especializaciones.num_especializaciones
ORDER BY especializaciones.num_especializaciones ASC;
