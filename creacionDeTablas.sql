CREATE SCHEMA ConnectBaseDeDatos;
SET search_path TO ConnectBaseDeDatos;

CREATE TABLE IF NOT EXISTS Usuario(
                                      ID SERIAL PRIMARY KEY,
                                      nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    contrasenia VARCHAR(50) NOT NULL,
    fecharegistro DATE NOT NULL,
    fechaNacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL,
    direccion VARCHAR(50) NOT NULL
    );
CREATE TABLE IF NOT EXISTS Viajero(
    ID SERIAL PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Usuario(ID)
);
CREATE TABLE IF NOT EXISTS Arrendador(
                                         ID SERIAL PRIMARY KEY,
                                         FOREIGN KEY (ID) REFERENCES Usuario(ID)
    );

CREATE TABLE IF NOT EXISTS MensajeIndividual(
                                                ID SERIAL PRIMARY KEY,
                                                cuerpo VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    estado BOOLEAN NOT NULL
    );
CREATE TABLE IF NOT EXISTS ChatIndividual(
                                             ID SERIAL PRIMARY KEY,
                                             fechacreacion DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS Comentarios(
                                          ID SERIAL PRIMARY KEY,
                                          cuerpo VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    estado BOOLEAN NOT NULL,
    cantidadReacciones INTEGER NOT NULL
    );
CREATE TABLE IF NOT EXISTS Resena(
                                     ID SERIAL PRIMARY KEY,
                                     fecha DATE NOT NULL,
                                     valoracion INTEGER NOT NULL,
                                     cuerpo VARCHAR(50) NOT NULL
    );
CREATE TABLE IF NOT EXISTS PublicacionInicio(
                                                ID SERIAL PRIMARY KEY,
                                                contenido VARCHAR(50) NOT NULL,
    compartidos INTEGER NOT NULL,
    meGustas INTEGER NOT NULL,
    estado BOOLEAN NOT NULL,
    fecha DATE NOT NULL,
    cantidadComentarios INTEGER NOT NULL
    );
CREATE TABLE IF NOT EXISTS PublicacionAlojamiento(
                                                     ID SERIAL PRIMARY KEY,
                                                     estado BOOLEAN NOT NULL,
                                                     fecha DATE NOT NULL,
                                                     disponibilidad BOOLEAN NOT NULL,
                                                     promediorating INTEGER NOT NULL,
                                                     cantidadrese˜nas INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS Alojamiento(
                                          ID SERIAL PRIMARY KEY,
                                          PublicacionAlojamientoID INTEGER NOT NULL,
                                          ArrendadorID INTEGER NOT NULL,
                                          FOREIGN KEY (PublicacionAlojamientoID) REFERENCES PublicacionAlojamiento(ID),
    FOREIGN KEY (ArrendadorID) REFERENCES Arrendador(ID)
    );
CREATE TABLE IF NOT EXISTS Publica1(
                                       PublicacionInicioID INTEGER NOT NULL,
                                       UsuarioID INTEGER NOT NULL,
                                       FOREIGN KEY (PublicacionInicioID) REFERENCES PublicacionInicio(ID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(ID)
    );
CREATE TABLE IF NOT EXISTS Publica2(
                                       PublicacionAlojamientoID INTEGER NOT NULL,
                                       UsuarioID INTEGER NOT NULL,
                                       FOREIGN KEY (PublicacionAlojamientoID) REFERENCES PublicacionAlojamiento(ID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(ID)
    );
CREATE TABLE IF NOT EXISTS EsAmigo(
                                      UsuarioID1 INTEGER NOT NULL,
                                      UsuarioID2 INTEGER NOT NULL,
                                      FOREIGN KEY (UsuarioID1) REFERENCES Usuario(ID),
    FOREIGN KEY (UsuarioID2) REFERENCES Usuario(ID)
    );
CREATE TABLE IF NOT EXISTS Responde(
                                       ComentarioID INTEGER NOT NULL,
                                       ComentarioRespuestaID INTEGER NOT NULL,
                                       FOREIGN KEY (ComentarioID) REFERENCES Comentarios(ID),
    FOREIGN KEY (ComentarioRespuestaID) REFERENCES Comentarios(ID)
    );
CREATE TABLE IF NOT EXISTS ContieneComentario(
                                                 PublicacionInicioID INTEGER NOT NULL,
                                                 ComentarioID INTEGER NOT NULL,
                                                 FOREIGN KEY (PublicacionInicioID) REFERENCES PublicacionInicio(ID),
    FOREIGN KEY (ComentarioID) REFERENCES Comentarios(ID)
    );
CREATE TABLE IF NOT EXISTS Asociada(
                                       PublicacionAlojamientoID INTEGER NOT NULL,
                                       AlojamientoID INTEGER NOT NULL,
                                       FOREIGN KEY (PublicacionAlojamientoID) REFERENCES PublicacionAlojamiento(ID),
    FOREIGN KEY (AlojamientoID) REFERENCES Alojamiento(ID)
    );
CREATE TABLE IF NOT EXISTS EscribeResena(
                                            UsuarioID INTEGER NOT NULL,
                                            ResenaID INTEGER NOT NULL,
                                            FOREIGN KEY (UsuarioID) REFERENCES Usuario(ID),
    FOREIGN KEY (ResenaID) REFERENCES Resena(ID)
    );
CREATE TABLE IF NOT EXISTS DuenoDe(
                                      AlojamientoID INTEGER NOT NULL,
                                      UsuarioID INTEGER NOT NULL,
                                      FOREIGN KEY (AlojamientoID) REFERENCES Alojamiento(ID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(ID)
    );
CREATE TABLE IF NOT EXISTS ContieneComentario2(
                                                  ComentarioID INTEGER NOT NULL,
                                                  PublicacionInicioID INTEGER NOT NULL,
                                                  FOREIGN KEY (ComentarioID) REFERENCES Comentarios(ID),
    FOREIGN KEY (PublicacionInicioID) REFERENCES PublicacionInicio(ID)
    );
CREATE TABLE IF NOT EXISTS EscribeIndividual(
                                                MensajeIndividualID INTEGER NOT NULL,
                                                UsuarioID INTEGER NOT NULL,
                                                FOREIGN KEY (MensajeIndividualID) REFERENCES MensajeIndividual(ID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(ID)
    );
CREATE TABLE IF NOT EXISTS ContieneMI(
                                         MensajeIndividualID INTEGER NOT NULL,
                                         ChatIndividualID INTEGER NOT NULL,
                                         FOREIGN KEY (MensajeIndividualID) REFERENCES MensajeIndividual(ID),
    FOREIGN KEY (ChatIndividualID) REFERENCES ChatIndividual(ID)
    );
CREATE TABLE IF NOT EXISTS ParticipaIndividual(
                                                  ChatIndividualID INTEGER NOT NULL,
                                                  Usuario1ID INTEGER NOT NULL,
                                                  Usuario2ID INTEGER NOT NULL,
                                                  FOREIGN KEY (ChatIndividualID) REFERENCES ChatIndividual(ID),
    FOREIGN KEY (Usuario1ID) REFERENCES Usuario(ID),
    FOREIGN KEY (Usuario2ID) REFERENCES Usuario(ID)
    );
CREATE TABLE IF NOT EXISTS Comenta(
                                      ComentarioID INTEGER NOT NULL,
                                      UsuarioID INTEGER NOT NULL,
                                      FOREIGN KEY (ComentarioID) REFERENCES Comentarios(ID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(ID)
    );
