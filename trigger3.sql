CREATE OR REPLACE FUNCTION actualizar_stock_medicamento()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Medicamento
        WHERE id = NEW.idMedicamento
        AND stock >= NEW.cantidad
    ) THEN
UPDATE Medicamento
SET stock = stock - NEW.cantidad
WHERE id = NEW.idMedicamento;
ELSE
    RAISE EXCEPTION 'Stock insuficiente para el medicamento o el medicamento no existe';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
