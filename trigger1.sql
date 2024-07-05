-- Añadir la columna totalMedicos y cantidadEmpleados a la tabla Consultorio
ALTER TABLE Consultorio
    ADD COLUMN totalMedicos INTEGER DEFAULT 0,
ADD COLUMN cantidadEmpleados INTEGER DEFAULT 0;

-- Crear la función de trigger
CREATE OR REPLACE FUNCTION update_totals()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'TrabajaMedico' THEN
       UPDATE Consultorio
       SET totalMedicos = totalMedicos + 1
       WHERE id = NEW.idConsultorio;
    ELSIF TG_TABLE_NAME = 'TrabajaEmpleado' THEN
          UPDATE Consultorio
          SET cantidadEmpleados = cantidadEmpleados + 1
          WHERE id = NEW.idConsultorio;
    END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_total_medicos
    AFTER INSERT ON TrabajaMedico
    FOR EACH ROW
    EXECUTE FUNCTION update_totals();

CREATE TRIGGER trg_update_total_empleados
    AFTER INSERT ON TrabajaEmpleado
    FOR EACH ROW
    EXECUTE FUNCTION update_totals();
