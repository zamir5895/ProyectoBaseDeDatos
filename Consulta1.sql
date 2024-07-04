SELECT
    CASE
        WHEN tipo_medicamento = true THEN 'Generico'
        ELSE 'No Generico'
        END AS tipo_medicamento,
    (SUM(total_consumo) * 100.0 / (SELECT SUM(total_consumo)
                                   FROM (
                                            SELECT medicamentos.generico AS tipo_medicamento, COUNT(*) AS total_consumo
                                            FROM (
                                                     SELECT c.dniPaciente
                                                     FROM Cita c
                                                     WHERE c.fecha >= CURRENT_DATE - INTERVAL '10 years'
                                                     GROUP BY c.dniPaciente, EXTRACT(YEAR FROM c.fecha)
                                                     HAVING COUNT(*) > 5
                                                 ) AS pacientes_filtrados
                                                     JOIN (
                                                SELECT r.dniPaciente, r.id AS receta_id
                                                FROM Receta r
                                            ) AS recetas ON pacientes_filtrados.dniPaciente = recetas.dniPaciente
                                                     JOIN (
                                                SELECT co.idReceta, co.idMedicamento
                                                FROM Contiene co
                                            ) AS contenidos ON recetas.receta_id = contenidos.idReceta
                                                     JOIN (
                                                SELECT m.id AS medicamento_id, m.generico
                                                FROM Medicamento m
                                            ) AS medicamentos ON contenidos.idMedicamento = medicamentos.medicamento_id
                                            GROUP BY medicamentos.generico
                                        ) AS subquery)) AS porcentaje_consumo
FROM (
         SELECT medicamentos.generico AS tipo_medicamento, COUNT(*) AS total_consumo
         FROM (
                  SELECT c.dniPaciente
                  FROM Cita c
                  WHERE c.fecha >= CURRENT_DATE - INTERVAL '10 years'
                  GROUP BY c.dniPaciente, EXTRACT(YEAR FROM c.fecha)
                  HAVING COUNT(*) > 5
              ) AS pacientes_filtrados
                  JOIN (
             SELECT r.dniPaciente, r.id AS receta_id
             FROM Receta r
         ) AS recetas ON pacientes_filtrados.dniPaciente = recetas.dniPaciente
                  JOIN (
             SELECT co.idReceta, co.idMedicamento
             FROM Contiene co
         ) AS contenidos ON recetas.receta_id = contenidos.idReceta
                  JOIN (
             SELECT m.id AS medicamento_id, m.generico
             FROM Medicamento m
         ) AS medicamentos ON contenidos.idMedicamento = medicamentos.medicamento_id
         GROUP BY medicamentos.generico
     ) AS medicamentos_consumo
GROUP BY tipo_medicamento;

--"¿Cuál es el porcentaje de consumo de medicamentos genéricos
-- versus no genéricos por pacientes que han tenido más de 5 citas por año en los últimos 10 años?"

