-- Consulta para obtener el porcentaje de citas con medicamentos genéricos por consultorio y año,
-- pero solo para consultorios que hayan tenido un promedio de citas mayor al promedio general

SELECT
    idConsultorio,
    year,
    (SUM(generico::int) / COUNT(*)) * 100 AS porcentaje_genericos
FROM (
    SELECT
    c.idConsultorio,
    EXTRACT(YEAR FROM c.fecha) AS year,
    (SELECT m.generico
    FROM Medicamento m
    WHERE m.id = (SELECT co.idMedicamento
    FROM Contiene co
    WHERE co.idReceta = (SELECT r.id
    FROM Receta r
    WHERE r.idCita = c.id)
    )
    ) AS generico
    FROM Cita c
    WHERE
    EXISTS (
    SELECT 1
    FROM (
    SELECT
    idConsultorio,
    EXTRACT(YEAR FROM fecha) AS year,
    COUNT(id) AS num_citas,
    AVG(COUNT(id)) OVER (PARTITION BY EXTRACT(YEAR FROM fecha)) AS prom_citas_general
    FROM Cita
    GROUP BY
    idConsultorio,
    EXTRACT(YEAR FROM fecha)
    ) AS promedio_consultorios
    WHERE
    c.idConsultorio = promedio_consultorios.idConsultorio
    AND EXTRACT(YEAR FROM c.fecha) = promedio_consultorios.year
    AND promedio_consultorios.num_citas > promedio_consultorios.prom_citas_general
    )
    ) AS consultorio_info
WHERE generico = TRUE
GROUP BY
    idConsultorio,
    year
ORDER BY
    year ASC;
