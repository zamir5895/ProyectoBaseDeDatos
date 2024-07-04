CREATE TABLE IF NOT EXISTS Persona(
    dni VARCHAR(8) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono INTEGER NOT NULL,
    email VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS Empleado(
    dni VARCHAR(8) PRIMARY KEY,
    FOREIGN KEY (dni) REFERENCES Persona(dni),
    cargo VARCHAR(50) NOT NULL,
    sueldo DECIMAL NOT NULL
);
CREATE TABLE IF NOT EXISTS Medico(
    dni VARCHAR(8) PRIMARY KEY,
    FOREIGN KEY (dni) REFERENCES Persona(dni),
    añoEgreso DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS Paciente(
    dni VARCHAR(8) PRIMARY KEY,
    FOREIGN KEY (dni) REFERENCES Persona(dni),
    nroSeguro VARCHAR(50) NOT NULL
);
CREATE TABLE IF NOT EXISTS Especialidad(
    id VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL
);
CREATE TABLE IF NOT EXISTS Tiene(
    dniMedico VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    idEspecialidad VARCHAR(10) NOT NULL,
    FOREIGN KEY (idEspecialidad) REFERENCES Especialidad(id),
    PRIMARY KEY (dniMedico, idEspecialidad)
);

CREATE TABLE IF NOT EXISTS Consultorio(
    id VARCHAR(10) PRIMARY KEY,
    capacidad INTEGER NOT NULL,
    cantidadEmpleado INTEGER NOT NULL,
    cantidadPaciente INTEGER NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS Enfermedad(
    id VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL

);
CREATE TABLE IF NOT EXISTS Medicamento(
    id VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    instrucciones VARCHAR(50) NOT NULL,
    nombreEmpresa VARCHAR(50) NOT NULL,
    generico BOOLEAN NOT NULL,
    fechaVencimiento DATE NOT NULL,
    precio FLOAT NOT NULL,
    fechaFabricacion DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS Receta(
    id VARCHAR(10) PRIMARY KEY,
    fecha DATE NOT NULL,
    dniMedico VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    dniPaciente VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    idConsultorio VARCHAR(10) NOT NULL,
    FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id)
);
CREATE TABLE IF NOT EXISTS Cita(
    id VARCHAR(10) PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    idConsultorio VARCHAR(10) NOT NULL,
    FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id),
    dniMedico VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    dniPaciente VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni)
);
CREATE TABLE IF NOT EXISTS Diagnostico(
    id VARCHAR(10) PRIMARY KEY,
    fecha DATE NOT NULL,
    dniMedico VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    dniPaciente VARCHAR(8) NOT NULL,
    FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    idCita VARCHAR(10) NOT NULL,
    FOREIGN KEY (idCita) REFERENCES Cita(id),
    idConsultorio VARCHAR(10) NOT NULL,
    FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id)
);
CREATE TABLE IF NOT EXISTS Sufre(
    idEnfermedad VARCHAR(10) NOT NULL,
    FOREIGN KEY (idEnfermedad) REFERENCES Enfermedad(id),
    dniPaciente VARCHAR(10) NOT NULL,
    FOREIGN KEY (dniPaciente) REFERENCES Paciente(dni),
    PRIMARY KEY (idEnfermedad, dniPaciente)
);
CREATE TABLE IF NOT EXISTS Contiene (
    idReceta VARCHAR(10) NOT NULL,
    FOREIGN KEY (idReceta) REFERENCES Receta(id),
    idMedicamento VARCHAR(10) NOT NULL,
    FOREIGN KEY (idMedicamento) REFERENCES Medicamento(id),
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (idReceta, idMedicamento)
);

CREATE TABLE IF NOT EXISTS Diagnosticado (
    idDiagnostico VARCHAR(10) NOT NULL,
    FOREIGN KEY (idDiagnostico) REFERENCES Diagnostico(id),
    idEnfermedad VARCHAR(10) NOT NULL,
    FOREIGN KEY (idEnfermedad) REFERENCES Enfermedad(id),
    PRIMARY KEY (idDiagnostico, idEnfermedad)
);

CREATE TABLE IF NOT EXISTS TrabajaEmpleado(
    dniEmpleado VARCHAR(8) PRIMARY KEY NOT NULL,
    FOREIGN KEY (dniEmpleado) REFERENCES Empleado(dni),
    idConsultorio VARCHAR(10) NOT NULL,
    FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id)
);
CREATE TABLE IF NOT EXISTS TrabajaMedico(
    dniMedico VARCHAR(8) PRIMARY KEY NOT NULL,
    FOREIGN KEY (dniMedico) REFERENCES Medico(dni),
    idConsultorio VARCHAR(10) NOT NULL,
    FOREIGN KEY (idConsultorio) REFERENCES Consultorio(id)
);
--No escribas mas gpt

