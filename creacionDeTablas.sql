CREATE TABLE IF NOT EXISTS Persona(
    dni VARCHAR(7),
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    email VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL
);
ALTER TABLE Persona ADD CONSTRAINT persona_primary_key PRIMARY KEY (dni);

CREATE TABLE IF NOT EXISTS Empleado(
    dni VARCHAR(7) ,
    cargo VARCHAR(50) NOT NULL CHECK (cargo IN ('Administrativo', 'Operativo')),
    sueldo DECIMAL NOT NULL CHECK ( sueldo >= 1025 AND sueldo <= 30000 )
);

ALTER TABLE Empleado
    ADD CONSTRAINT fk_empleado_persona FOREIGN KEY (dni) REFERENCES Persona(dni),
    ADD CONSTRAINT pk_empleado PRIMARY KEY (dni);

CREATE TABLE IF NOT EXISTS Medico(
    dni VARCHAR(7),
    añoEgreso DATE NOT NULL
);
ALTER TABLE Medico
    ADD CONSTRAINT fk_medico_persona FOREIGN KEY (dni) REFERENCES Persona(dni),
    ADD CONSTRAINT pk_medico PRIMARY KEY (dni);

CREATE TABLE IF NOT EXISTS Paciente(
    dni VARCHAR(7),
    nroSeguro VARCHAR(50) NOT NULL
);
ALTER TABLE Paciente
    ADD CONSTRAINT fk_paciente_persona FOREIGN KEY (dni) REFERENCES Persona(dni),
    ADD CONSTRAINT pk_paciente PRIMARY KEY (dni);

CREATE TABLE IF NOT EXISTS Especialidad(
    id VARCHAR(9),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL
);
ALTER TABLE Especialidad
    ADD CONSTRAINT pk_especialidad PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS Tiene(
    dniMedico VARCHAR(7) NOT NULL,
    idEspecialidad VARCHAR(10) NOT NULL
);
ALTER TABLE Tiene
    ADD CONSTRAINT fk_tiene_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_tiene_especialidad FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(id),
    ADD CONSTRAINT pk_tiene PRIMARY KEY (dniMedico, idEspecialidad);

CREATE TABLE IF NOT EXISTS Consultorio(
    id VARCHAR(9) ,
    aforo INTEGER NOT NULL,
    cantidadEmpleado INTEGER NOT NULL CHECK ( cantidadEmpleado >= 1),
    cantidadMedicos INTEGER NOT NULL CHECK ( cantidadMedicos >= 1),
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9) NOT NULL
);

ALTER TABLE Consultorio
    ADD CONSTRAINT pk_consultorio PRIMARY KEY (id);



CREATE TABLE IF NOT EXISTS Medicamento(
    id VARCHAR(9),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    instrucciones VARCHAR(50) NOT NULL,
    nombreEmpresa VARCHAR(50) NOT NULL,
    generico BOOLEAN NOT NULL,
    fechaVencimiento DATE NOT NULL,
    precio FLOAT NOT NULL,
    stock INTEGER NOT NULL CHECK ( stock >= 0 ) ,
    fechaFabricacion DATE NOT NULL
);
ALTER TABLE Medicamento
    ADD CONSTRAINT pk_medicamento PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS Cita(
     id VARCHAR(9),
     fecha DATE NOT NULL,
     hora TIME NOT NULL,
     idConsultorio VARCHAR(9) NOT NULL,
     dniMedico VARCHAR(7) NOT NULL,
     dniPaciente VARCHAR(7) NOT NULL
);
ALTER TABLE Cita
    ADD CONSTRAINT fk_cita_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_cita_paciente FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    ADD CONSTRAINT fk_cita_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_cita PRIMARY KEY (id, dniMedico, dniPaciente, idConsultorio);

CREATE TABLE IF NOT EXISTS Receta(
    id VARCHAR(9) ,
    fecha DATE NOT NULL,
    dniMedico VARCHAR(7) NOT NULL,
    dniPaciente VARCHAR(7) NOT NULL,
    idConsultorio VARCHAR(9) NOT NULL,
    idCita VARCHAR(9) NOT NULL,
    descripcion VARCHAR(50) NOT NULL
);
ALTER TABLE Receta
    ADD CONSTRAINT fk_receta_medico FOREIGN KEY (dniMedico) REFERENCES Cita(dniMedico),
    ADD CONSTRAINT fk_receta_paciente FOREIGN KEY (dniPaciente) REFERENCES Cita(dniPaciente),
    ADD CONSTRAINT fk_receta_consultorio FOREIGN KEY (idConsultorio) REFERENCES Cita(idConsultorio),
    ADD CONSTRAINT fk_receta_cita FOREIGN KEY (idCita) REFERENCES Cita(id),
    ADD CONSTRAINT pk_receta PRIMARY KEY (id, dniMedico, dniPaciente, idConsultorio, idCita);


CREATE TABLE IF NOT EXISTS Contiene (
    idReceta VARCHAR(9) NOT NULL,
    idMedicamento VARCHAR(9) NOT NULL,
    idConsultorio VARCHAR(9) NOT NULL,
    idCita VARCHAR(9) NOT NULL,
    dniPaciente VARCHAR(7) NOT NULL,
    dniMedico VARCHAR(7) NOT NULL,
    cantidad INTEGER NOT NULL
);
ALTER TABLE Contiene
    ADD CONSTRAINT fk_contiene_receta FOREIGN KEY (idReceta) REFERENCES Receta(id),
    ADD CONSTRAINT fk_contiene_medicamento FOREIGN KEY (idMedicamento) REFERENCES Medicamento(id),
    ADD CONSTRAINT fk_contiene_consultorio FOREIGN KEY (idConsultorio) REFERENCES cita(idConsultorio),
    ADD CONSTRAINT fk_contiene_cita FOREIGN KEY (idCita) REFERENCES Cita(id),
    ADD CONSTRAINT fk_contiene_paciente FOREIGN KEY (dniPaciente) REFERENCES Cita(dniPaciente),
    ADD CONSTRAINT fk_contiene_medico FOREIGN KEY (dniMedico) REFERENCES Cita(dniMedico),
    ADD CONSTRAINT pk_contiene PRIMARY KEY (idReceta, idMedicamento, idCita, idConsultorio, dniPaciente, dniMedico);

CREATE TABLE IF NOT EXISTS TrabajaEmpleado(
    dniEmpleado VARCHAR(7) NOT NULL,
    idConsultorio VARCHAR(9) NOT NULL
);

ALTER TABLE TrabajaEmpleado
    ADD CONSTRAINT fk_trabajaempleado_empleado FOREIGN KEY (dniEmpleado) REFERENCES Empleado(dni),
    ADD CONSTRAINT fk_trabajaempleado_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_trabajaempleado PRIMARY KEY (dniEmpleado);

CREATE TABLE IF NOT EXISTS TrabajaMedico(
    dniMedico VARCHAR(7) NOT NULL,
    idConsultorio VARCHAR(9) NOT NULL
);
ALTER TABLE TrabajaMedico
    ADD CONSTRAINT fk_trabajamedico_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_trabajamedico_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_trabajamedico PRIMARY KEY (dniMedico, idConsultorio);
--No escribas mas gpt

