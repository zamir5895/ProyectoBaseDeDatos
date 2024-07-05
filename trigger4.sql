ALTER TABLE Consultorio ADD COLUMN numCitas INTEGER DEFAULT 0;
ALTER TABLE Medico ADD COLUMN numCitas INTEGER DEFAULT 0;
ALTER TABLE Paciente ADD COLUMN numCitas INTEGER DEFAULT 0;

CREATE OR REPLACE FUNCTION actualizar_registros_cita()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Paciente
        WHERE dni = NEW.dniPaciente
    ) THEN
        IF EXISTS (
            SELECT 1
            FROM Medico
            WHERE dni = NEW.dniMedico
        ) THEN
            IF EXISTS (
                SELECT 1
                FROM TrabajaMedico
                WHERE dniMedico = NEW.dniMedico
                AND idConsultorio = NEW.idConsultorio
            ) THEN
                  UPDATE Consultorio
                  SET numCitas = numCitas + 1
                  WHERE id = NEW.idConsultorio;
                  UPDATE Medico
                  SET numCitas = numCitas + 1
                  WHERE dni = NEW.dniMedico;
                  UPDATE Paciente
                  SET numCitas = numCitas + 1
                  WHERE dni = NEW.dniPaciente;
            ELSE
                RAISE EXCEPTION 'El médico no trabaja en el consultorio especificado';
            END IF;
        ELSE
            RAISE EXCEPTION 'El médico no existe';
        END IF;
    ELSE
        RAISE EXCEPTION 'El paciente no existe';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_registros_cita
    AFTER INSERT ON Cita
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_registros_cita();
