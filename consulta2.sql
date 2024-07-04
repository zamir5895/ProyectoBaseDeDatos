--Consulta para obtener la edad promedio de los pacientes que hayan tenido citas mayor al promedio de
--citas del consultorio en ese año, agrupados por consultorio id y año de las citas,
--ordenas por el año de manera ascendente. es decir para cada año de las citas de los pacientes
SELECT
    consultorio_info.idConsultorio,
    consultorio_info.year,
    AVG(consultorio_info.edad_promedio) AS edad_promedio_final
FROM (
         SELECT
             c.idConsultorio,
             EXTRACT(YEAR FROM c.fecha) AS year,
        per.edad,
        CASE
            WHEN citas_paciente.num_citas > promedio_citas.prom_citas THEN per.edad
            ELSE NULL
        END AS edad_promedio
         FROM
             Cita c
             JOIN
             (SELECT p.dni, per.edad
             FROM Paciente p
             JOIN Persona per ON p.dni = per.dni) AS per
         ON c.dniPaciente = per.dni
             JOIN (
             SELECT
             c1.dniPaciente,
             c1.idConsultorio,
             EXTRACT(YEAR FROM c1.fecha) AS year,
             COUNT(c1.id) AS num_citas
             FROM
             Cita c1
             GROUP BY
             c1.dniPaciente,
             c1.idConsultorio,
             EXTRACT(YEAR FROM c1.fecha)
             ) AS citas_paciente
             ON
             c.dniPaciente = citas_paciente.dniPaciente
             AND c.idConsultorio = citas_paciente.idConsultorio
             AND EXTRACT(YEAR FROM c.fecha) = citas_paciente.year
             JOIN (
             SELECT
             c2.idConsultorio,
             EXTRACT(YEAR FROM c2.fecha) AS year,
             AVG(citas_por_año.citas_totales) AS prom_citas
             FROM
             Cita c2
             JOIN (
             SELECT
             idConsultorio,
             EXTRACT(YEAR FROM fecha) AS year,
             COUNT(id) AS citas_totales
             FROM
             Cita
             GROUP BY
             idConsultorio,
             EXTRACT(YEAR FROM fecha)
             ) AS citas_por_año
             ON
             c2.idConsultorio = citas_por_año.idConsultorio
             AND EXTRACT(YEAR FROM c2.fecha) = citas_por_año.year
             GROUP BY
             c2.idConsultorio,
             EXTRACT(YEAR FROM c2.fecha)
             ) AS promedio_citas
             ON
             c.idConsultorio = promedio_citas.idConsultorio
             AND EXTRACT(YEAR FROM c.fecha) = promedio_citas.year
     ) AS consultorio_info
WHERE
    consultorio_info.edad_promedio IS NOT NULL
GROUP BY
    consultorio_info.idConsultorio,
    consultorio_info.year
ORDER BY
    consultorio_info.year ASC;
--"¿Cuál es la edad promedio de los pacientes que han tenido más citas que el promedio
-- de citas de su consultorio
-- en un año determinado, agrupada por consultorio y año, y ordenada de manera ascendente por año?"