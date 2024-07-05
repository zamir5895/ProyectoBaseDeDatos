CREATE OR REPLACE FUNCTION validate_medicamento_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fechaFabricacion >= NEW.fechaVencimiento THEN
        RAISE EXCEPTION 'La fecha de fabricación debe ser anterior a la fecha de vencimiento';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_medicamento_dates
    BEFORE INSERT ON Medicamento
    FOR EACH ROW
    EXECUTE FUNCTION validate_medicamento_dates();
