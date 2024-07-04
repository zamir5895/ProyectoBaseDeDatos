CREATE TABLE IF NOT EXISTS Persona(
    dni VARCHAR(7),
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono INTEGER NOT NULL,
    email VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL
);
ALTER TABLE Persona ADD CONSTRAINT persona_primary_key PRIMARY KEY (dni);

CREATE TABLE IF NOT EXISTS Empleado(
    dni VARCHAR(7) ,
    cargo VARCHAR(50) NOT NULL,
    sueldo DECIMAL NOT NULL
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
    id VARCHAR(10),
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
    id VARCHAR(10) ,
    capacidad INTEGER NOT NULL,
    cantidadEmpleado INTEGER NOT NULL,
    cantidadPaciente INTEGER NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono INTEGER NOT NULL
);

ALTER TABLE Consultorio
    ADD CONSTRAINT pk_consultorio PRIMARY KEY (id);


CREATE TABLE IF NOT EXISTS Enfermedad(
    id VARCHAR(10),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);
ALTER TABLE Enfermedad
    ADD CONSTRAINT pk_enfermedad PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS Medicamento(
    id VARCHAR(10),
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

CREATE TABLE IF NOT EXISTS Receta(
    id VARCHAR(10) ,
    fecha DATE NOT NULL,
    dniMedico VARCHAR(7) NOT NULL,
    dniPaciente VARCHAR(7) NOT NULL,
    descripcion VARCHAR(50) NOT NULL
);
ALTER TABLE Receta
    ADD CONSTRAINT fk_receta_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_receta_paciente FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    ADD CONSTRAINT pk_receta PRIMARY KEY (id, dniMedico, dniPaciente);

CREATE TABLE IF NOT EXISTS Cita(
    id VARCHAR(10),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    idConsultorio VARCHAR(10) NOT NULL,
    dniMedico VARCHAR(7) NOT NULL,
    dniPaciente VARCHAR(7) NOT NULL
);
ALTER TABLE Cita
    ADD CONSTRAINT fk_cita_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_cita_paciente FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    ADD CONSTRAINT fk_cita_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_cita PRIMARY KEY (id, dniMedico, dniPaciente, idConsultorio);

CREATE TABLE IF NOT EXISTS Diagnostico(
    id VARCHAR(10) ,
    dniMedico VARCHAR(7) NOT NULL,
    dniPaciente VARCHAR(7) NOT NULL,
    idCita VARCHAR(10) NOT NULL,
    idConsultorio VARCHAR(10) NOT NULL
);
ALTER TABLE Diagnostico
    ADD CONSTRAINT fk_diagnostico_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_diagnostico_paciente FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    ADD CONSTRAINT fk_diagnostico_cita FOREIGN KEY (idCita) REFERENCES Cita(id),
    ADD CONSTRAINT fk_diagnostico_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_diagnostico PRIMARY KEY (id, dniMedico, dniPaciente, idCita, idConsultorio);

CREATE TABLE IF NOT EXISTS Contiene (
    idReceta VARCHAR(10) NOT NULL,
    idMedicamento VARCHAR(10) NOT NULL,
    cantidad INTEGER NOT NULL
);
ALTER TABLE Contiene
    ADD CONSTRAINT fk_contiene_receta FOREIGN KEY (idReceta) REFERENCES Receta(id),
    ADD CONSTRAINT fk_contiene_medicamento FOREIGN KEY (idMedicamento) REFERENCES Medicamento(id),
    ADD CONSTRAINT pk_contiene PRIMARY KEY (idReceta, idMedicamento);

CREATE TABLE IF NOT EXISTS Diagnosticado (
    idDiagnostico VARCHAR(10) NOT NULL,
    idEnfermedad VARCHAR(10) NOT NULL,
    idConsultorio VARCHAR(10) NOT NULL,
    idPaciente VARCHAR(7) NOT NULL,
    idMedico VARCHAR(7) NOT NULL
);
ALTER TABLE Diagnosticado
    ADD CONSTRAINT fk_diagnosticado_diagnostico FOREIGN KEY (idDiagnostico) REFERENCES Diagnostico(id),
    ADD CONSTRAINT fk_diagnosticado_enfermedad FOREIGN KEY (idEnfermedad) REFERENCES Enfermedad(id),
    ADD CONSTRAINT fk_diagnosticado_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT fk_diagnosticado_paciente FOREIGN KEY (idPaciente) REFERENCES Paciente(dni),
    ADD CONSTRAINT fk_diagnosticado_medico FOREIGN KEY (idMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT pk_diagnosticado PRIMARY KEY (idDiagnostico, idEnfermedad, idConsultorio, idPaciente, idMedico);

CREATE TABLE IF NOT EXISTS TrabajaEmpleado(
    dniEmpleado VARCHAR(7) NOT NULL,
    idConsultorio VARCHAR(10) NOT NULL
);

ALTER TABLE TrabajaEmpleado
    ADD CONSTRAINT fk_trabajaempleado_empleado FOREIGN KEY (dniEmpleado) REFERENCES Empleado(dni),
    ADD CONSTRAINT fk_trabajaempleado_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_trabajaempleado PRIMARY KEY (dniEmpleado);

CREATE TABLE IF NOT EXISTS TrabajaMedico(
    dniMedico VARCHAR(7) NOT NULL,
    idConsultorio VARCHAR(10) NOT NULL
);
ALTER TABLE TrabajaMedico
    ADD CONSTRAINT fk_trabajamedico_medico FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    ADD CONSTRAINT fk_trabajamedico_consultorio FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    ADD CONSTRAINT pk_trabajamedico PRIMARY KEY (dniMedico, idConsultorio);
--No escribas mas gpt

