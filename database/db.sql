-- -----------------------------------------------------
-- banco_sangre_bd
-- -----------------------------------------------------
DROP DATABASE banco_sangre_bd;
CREATE DATABASE banco_sangre_bd;
USE banco_sangre_bd;
SET lc_time_names = 'es_ES';

-- -----------------------------------------------------
-- Tabla Tipo_Documento_Identidad *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Tipo_Documento_Identidad;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Tipo_Documento_Identidad (
  pk_tipo_documento_identidad INT NOT NULL,
  nombre_tipo_documento_identidad VARCHAR(45) NOT NULL
);

ALTER TABLE banco_sangre_bd.Tipo_Documento_Identidad
  ADD CONSTRAINT PK_Tipo_Documento_Identidad PRIMARY KEY (pk_tipo_documento_identidad);
  
ALTER TABLE banco_sangre_bd.Tipo_Documento_Identidad MODIFY banco_sangre_bd.Tipo_Documento_Identidad.pk_tipo_documento_identidad INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Usuario *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Usuario;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Usuario (
  pk_usuario INT NOT NULL,
  correo_usuario VARCHAR(45) NOT NULL,
  contrasena_usuario VARCHAR(45) NOT NULL,
  estado_usuario CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'El usuario podrá tener 2 estados A (activo) I (inactivo)'
);

ALTER TABLE banco_sangre_bd.Usuario
  ADD CONSTRAINT PK_Usuario PRIMARY KEY (pk_usuario);
  
ALTER TABLE banco_sangre_bd.usuario MODIFY banco_sangre_bd.usuario.pk_usuario INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Departamento *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Departamento;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Departamento (
  pk_departamento TINYINT(2) ZEROFILL NOT NULL,
  nombre_departamento VARCHAR(45) NOT NULL
);

ALTER TABLE banco_sangre_bd.Departamento
  ADD CONSTRAINT PK_Departamento PRIMARY KEY (pk_departamento);

ALTER TABLE banco_sangre_bd.departamento MODIFY banco_sangre_bd.departamento.pk_departamento TINYINT(2) ZEROFILL AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Ciudad *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Ciudad;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Ciudad (
  pk_ciudad TINYINT(3) ZEROFILL NOT NULL,
  nombre_ciudad VARCHAR(45) NOT NULL,
  fk_departamento_ciudad TINYINT(2) ZEROFILL NOT NULL
);

ALTER TABLE banco_sangre_bd.Ciudad
  ADD CONSTRAINT PK_Ciudad PRIMARY KEY (pk_ciudad);
  
ALTER TABLE banco_sangre_bd.ciudad MODIFY banco_sangre_bd.ciudad.pk_ciudad TINYINT(3) ZEROFILL AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Ciudad
  ADD CONSTRAINT fk_departamento_ciudad
  FOREIGN KEY (fk_departamento_ciudad) REFERENCES banco_sangre_bd.Departamento(pk_departamento);

-- -----------------------------------------------------
-- Tabla Afiliacion_Salud *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Afiliacion_Salud;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Afiliacion_Salud (
  pk_afiliacion_salud INT NOT NULL,
  nombre_afiliacion_salud VARCHAR(45) NOT NULL
);

ALTER TABLE banco_sangre_bd.Afiliacion_Salud
  ADD CONSTRAINT PK_Afiliacion_Salud PRIMARY KEY (pk_afiliacion_salud);
  
ALTER TABLE banco_sangre_bd.afiliacion_salud MODIFY banco_sangre_bd.afiliacion_salud.pk_afiliacion_salud INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Grupo_Sanguineo *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Grupo_Sanguineo;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Grupo_Sanguineo (
  pk_grupo_sanguineo INT NOT NULL,
  marcador_grupo_sanguineo CHAR(2) NOT NULL COMMENT 'El sistema sanguíneo ABO tiene cuatro grupos sanguíneos:\n\nGrupo A. Este grupo sanguíneo tiene un marcador conocido como “A”.\nGrupo B. Este grupo sanguíneo tiene un marcador conocido como “B”.\nGrupo AB. Este grupo sanguíneo tiene tanto marcadores A como marcadores B.\nGrupo O. Este grupo sanguíneo no tiene marcadores A ni B.',
  rh_grupo_sanguineo TINYINT(1) NOT NULL COMMENT 'La sangre se clasifica como \"Rh positiva\" (lo que significa que tiene el factor Rh) o \"Rh negativa\" (sin el factor Rh), se representará por 1 y 0 respectivamente.'
);

ALTER TABLE banco_sangre_bd.Grupo_Sanguineo
  ADD CONSTRAINT PK_Grupo_Sanguineo PRIMARY KEY (pk_grupo_sanguineo);

ALTER TABLE banco_sangre_bd.grupo_sanguineo MODIFY banco_sangre_bd.grupo_sanguineo.pk_grupo_sanguineo INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Codigo_Nacional *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Codigo_Nacional;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Codigo_Nacional (
  pk_codigo_nacional INT NOT NULL COMMENT 'El codigo nacional es un número con nomenclatura DANE, asignado al banco de sangre por la Coordinación de la Red Nacional de Bancos de Sangre del INS. El código está asignado según la ubicación geográfica del banco de sangre en Colombia y es exclusivo. Los dos primeros dígitos corresponden al departamento en donde está ubicado el banco de sangre, los tres siguientes al municipio y los últimos al orden secuencial de asignación.',
  fk_ciudad_codigo_nacional TINYINT(3) ZEROFILL NOT NULL,
  consecutivo_codigo_nacional BIGINT(20)
);

ALTER TABLE banco_sangre_bd.Codigo_Nacional
  ADD CONSTRAINT PK_Codigo_Nacional PRIMARY KEY (pk_codigo_nacional);
  
ALTER TABLE banco_sangre_bd.codigo_nacional MODIFY banco_sangre_bd.codigo_nacional.pk_codigo_nacional INT AUTO_INCREMENT;

CREATE INDEX consecutivo_codigo_nacional ON banco_sangre_bd.codigo_nacional(consecutivo_codigo_nacional);

ALTER TABLE banco_sangre_bd.Codigo_Nacional
  ADD CONSTRAINT fk_ciudad_codigo_nacional
  FOREIGN KEY (fk_ciudad_codigo_nacional) REFERENCES banco_sangre_bd.ciudad(pk_ciudad);

-- -----------------------------------------------------
-- Tabla Banco_Sangre *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Banco_Sangre;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Banco_Sangre (
  pk_banco_sangre INT NOT NULL,
  razon_social_banco_sangre VARCHAR(45) NOT NULL COMMENT 'Corresponde al nombre con que el banco de sangre está registrado en la Cámara de Comercio, en el INVIMA, en el INS (Coordinación Red Nacional de Bancos de Sangre y Servicios de Transfusión) y en la Red Departamental o Distrital de Bancos de Sangre',
  estado_banco_sangre CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'El banco de sangre tiene 2 estados A (activo) o I (inactivo)',
  codigo_registro_banco_sangre VARCHAR(45),
  direccion_banco_sangre VARCHAR(45) NULL,
  fk_codigo_nacional_banco_sangre INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Banco_Sangre
  ADD CONSTRAINT PK_Banco_Sangre PRIMARY KEY (pk_banco_sangre);

CREATE INDEX idx_codigo_registro_banco_sangre ON banco_sangre_bd.Banco_Sangre (codigo_registro_banco_sangre);
ALTER TABLE banco_sangre_bd.banco_sangre MODIFY banco_sangre_bd.banco_sangre.pk_banco_sangre INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Banco_Sangre
  ADD CONSTRAINT fk_codigo_nacional_banco_sangre
  FOREIGN KEY (fk_codigo_nacional_banco_sangre) REFERENCES banco_sangre_bd.codigo_nacional(pk_codigo_nacional);

-- -----------------------------------------------------
-- Tabla Persona *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Persona;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Persona (
  pk_persona INT NOT NULL,
  nombres_persona VARCHAR(45) NOT NULL,
  apellidos_persona VARCHAR(45) NOT NULL,
  sexo_persona CHAR(1) NOT NULL COMMENT 'El sexo de la persona, en este caso, hace referencia al \'sexo biológico\' tambien conocido como \'sexo asignado al nacer\'. Cuenta con dos opciones: Hombre o Mujer representados por H y M, respectivamente.',
  peso_persona DOUBLE NOT NULL COMMENT 'El peso de la persona se maneja en unidades de kilogramos (kg).',
  altura_persona DOUBLE NOT NULL COMMENT 'La altura de la persona se maneja en unidades de metros (m).',
  imc_persona DOUBLE GENERATED ALWAYS AS (peso_persona / (altura_persona * altura_persona)) VIRTUAL COMMENT 'El Indice de Masa Corporal (IMC) es un número que se calcula con base en el peso y la estatura de la persona, usado para identificar las categorías de peso.',
  fk_ciudad_residencia_persona TINYINT(3) ZEROFILL NOT NULL,
  fk_ciudad_nacimiento_persona TINYINT(3) ZEROFILL,
  fecha_nacimiento_persona DATE NOT NULL,
  numero_identificacion_persona VARCHAR(10) NOT NULL,
  fk_tipo_documento_identidad_persona INT NOT NULL,
  fk_afiliacion_salud_persona INT NOT NULL,
  fk_grupo_sanguineo_persona INT NOT NULL,
  fk_usuario_persona INT NOT NULL,
  estado_persona CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'El estado de la persona podrá ser A (activa) o I (inactiva)',
  fk_banco_sangre_persona INT NULL
);

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT PK_Persona PRIMARY KEY (pk_persona);
  
ALTER TABLE banco_sangre_bd.persona MODIFY banco_sangre_bd.persona.pk_persona INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_ciudad_nacimiento_persona
  FOREIGN KEY (fk_ciudad_nacimiento_persona) REFERENCES banco_sangre_bd.ciudad(pk_ciudad);
  
ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_ciudad_residencia_persona
  FOREIGN KEY (fk_ciudad_residencia_persona) REFERENCES banco_sangre_bd.ciudad(pk_ciudad);

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_tipo_documento_identidad_persona
  FOREIGN KEY (fk_tipo_documento_identidad_persona) REFERENCES banco_sangre_bd.tipo_documento_identidad(pk_tipo_documento_identidad);

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_afiliacion_salud_persona
  FOREIGN KEY (fk_afiliacion_salud_persona) REFERENCES banco_sangre_bd.afiliacion_salud(pk_afiliacion_salud);

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_grupo_sanguineo_persona
  FOREIGN KEY (fk_grupo_sanguineo_persona) REFERENCES banco_sangre_bd.grupo_sanguineo(pk_grupo_sanguineo);

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_usuario_persona
  FOREIGN KEY (fk_usuario_persona) REFERENCES banco_sangre_bd.usuario(pk_usuario);

ALTER TABLE banco_sangre_bd.Persona
  ADD CONSTRAINT fk_banco_sangre_persona
  FOREIGN KEY (fk_banco_sangre_persona) REFERENCES banco_sangre_bd.banco_sangre(pk_banco_sangre);

-- -----------------------------------------------------
-- Tabla Telefono *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Telefono;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Telefono (
  pk_telefono INT NOT NULL,
  numero_telefono VARCHAR(10) NOT NULL,
  fk_persona_telefono INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Telefono
  ADD CONSTRAINT PK_Telefono PRIMARY KEY (pk_telefono);
  
ALTER TABLE banco_sangre_bd.telefono MODIFY banco_sangre_bd.telefono.pk_telefono INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.telefono
  ADD CONSTRAINT fk_persona_telefono
  FOREIGN KEY (fk_persona_telefono) REFERENCES banco_sangre_bd.persona(pk_persona);

-- -----------------------------------------------------
-- Tabla Solicitud_Sangre*
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Solicitud_Sangre;

DROP TABLE IF EXISTS banco_sangre_bd.Solicitud_Sangre;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Solicitud_Sangre (
  pk_solicitud_sangre INT NOT NULL,
  cantidad_sangre_solicitud_sangre DOUBLE NOT NULL DEFAULT 1,
  fecha_inicio_solicitud_sangre DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_fin_solicitud_sangre DATE NOT NULL,
  estado_solicitud_sangre CHAR(1) NOT NULL DEFAULT 'S' COMMENT 'La solicitud de sangre tiene 3 estados, I (incompleta), C (completa) o S (Sin respuesta)',
  sexo_donador_solicitud_sangre CHAR(1) NOT NULL COMMENT 'El sexo de la persona, en este caso, hace referencia al \'sexo biológico\' tambien conocido como \'sexo asignado al nacer\'. Cuenta con dos opciones: Hombre o Mujer representados por H y M, respectivamente.',
  fk_grupo_sanguineo_solicitud_sangre INT NOT NULL,
  fk_banco_sangre_solicitud_sangre INT NOT NULL,
  fk_persona_receptora_solicitud_sangre INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Solicitud_Sangre
  ADD CONSTRAINT PK_Solicitud_Sangre PRIMARY KEY (pk_solicitud_sangre);
  
ALTER TABLE banco_sangre_bd.solicitud_sangre MODIFY banco_sangre_bd.solicitud_sangre.pk_solicitud_sangre INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Solicitud_Sangre
  ADD CONSTRAINT fk_grupo_sanguineo_solicitud_sangre
  FOREIGN KEY (fk_grupo_sanguineo_solicitud_sangre) REFERENCES banco_sangre_bd.grupo_sanguineo(pk_grupo_sanguineo);

ALTER TABLE banco_sangre_bd.Solicitud_Sangre
  ADD CONSTRAINT fk_banco_sangre_solicitud_sangre
  FOREIGN KEY (fk_banco_sangre_solicitud_sangre) REFERENCES banco_sangre_bd.banco_sangre(pk_banco_sangre);
  
ALTER TABLE banco_sangre_bd.Solicitud_Sangre
  ADD CONSTRAINT fk_persona_receptora_solicitud_sangre
  FOREIGN KEY (fk_persona_receptora_solicitud_sangre) REFERENCES banco_sangre_bd.persona(pk_persona);
  
-- -----------------------------------------------------
-- Tabla Donacion*
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Donacion;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Donacion (
  pk_donacion INT NOT NULL,
  cantidad_sangre_donacion DOUBLE NOT NULL,
  fecha_donacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado_donacion CHAR(1) NOT NULL DEFAULT 'D' COMMENT 'La donación tendrá un estado de sangre en donación el cual podrá ser D (disponible) U (usada) X (Desechada)',
  fk_solicitud_sangre_donacion INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Donacion
  ADD CONSTRAINT PK_Donacion PRIMARY KEY (pk_donacion);
  
ALTER TABLE banco_sangre_bd.donacion MODIFY banco_sangre_bd.donacion.pk_donacion INT AUTO_INCREMENT;
  
ALTER TABLE banco_sangre_bd.Donacion
  ADD CONSTRAINT fk_solicitud_sangre_donacion
  FOREIGN KEY (fk_solicitud_sangre_donacion) REFERENCES banco_sangre_bd.solicitud_sangre(pk_solicitud_sangre);


-- -----------------------------------------------------
-- Tabla Encuesta_Donante *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Encuesta_Donante;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Encuesta_Donante (
  pk_encuesta_donante INT NOT NULL,
  fecha_encuesta_donante DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resultado_encuesta_donante CHAR(1) NOT NULL DEFAULT 'S',
  observaciones_encuesta_donante TEXT NULL,
  fk_persona_encuesta_donante INT NOT NULL,
  fk_donacion_encuesta_donante INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Encuesta_Donante
  ADD CONSTRAINT PK_Encuesta_Donante PRIMARY KEY (pk_encuesta_donante);
  
ALTER TABLE banco_sangre_bd.encuesta_donante MODIFY banco_sangre_bd.encuesta_donante.pk_encuesta_donante INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Encuesta_Donante
  ADD CONSTRAINT fk_persona_encuesta_donante
  FOREIGN KEY (fk_persona_encuesta_donante) REFERENCES banco_sangre_bd.persona(pk_persona);

ALTER TABLE banco_sangre_bd.Encuesta_Donante
  ADD CONSTRAINT fk_donacion_encuesta_donante
  FOREIGN KEY (fk_donacion_encuesta_donante) REFERENCES banco_sangre_bd.donacion(pk_donacion);

-- -----------------------------------------------------
-- Tabla Pregunta *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Pregunta;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Pregunta (
  pk_pregunta INT NOT NULL,
  texto_pregunta LONGTEXT NOT NULL
);

ALTER TABLE banco_sangre_bd.Pregunta
  ADD CONSTRAINT PK_Pregunta PRIMARY KEY (pk_pregunta);
  
ALTER TABLE banco_sangre_bd.pregunta MODIFY banco_sangre_bd.pregunta.pk_pregunta INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Respuesta*
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Respuesta;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Respuesta (
  pk_respuesta INT NOT NULL,
  texto_respuesta LONGTEXT NOT NULL,
  fk_pregunta_respuesta INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Respuesta
  ADD CONSTRAINT PK_Respuesta PRIMARY KEY (pk_respuesta);
  
ALTER TABLE banco_sangre_bd.respuesta MODIFY banco_sangre_bd.respuesta.pk_respuesta INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Respuesta
  ADD CONSTRAINT fk_pregunta_respuesta
  FOREIGN KEY (fk_pregunta_respuesta) REFERENCES banco_sangre_bd.pregunta(pk_pregunta);

-- -----------------------------------------------------
-- Tabla Detalle_Encuesta *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Detalle_Encuesta;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Detalle_Encuesta (
  pk_detalle_encuesta INT NOT NULL,
  fk_encuesta_donante_detalle_encuesta INT NOT NULL,
  fk_pregunta_detalle_encuesta INT NOT NULL,
  resultado_detalle_encuesta CHAR(3) COMMENT 'Se define el resultado de la evaluación a la respuesta del donante potencial, se manejan tres posibles: B (bajo). R (regular) o E (Excelente) '
);

ALTER TABLE banco_sangre_bd.Detalle_Encuesta
  ADD CONSTRAINT PK_Detalle_Encuesta PRIMARY KEY (pk_detalle_encuesta);
  
ALTER TABLE banco_sangre_bd.detalle_encuesta MODIFY banco_sangre_bd.detalle_encuesta.pk_detalle_encuesta INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.Detalle_Encuesta
  ADD CONSTRAINT fk_encuesta_donante_detalle_encuesta
  FOREIGN KEY (fk_encuesta_donante_detalle_encuesta) REFERENCES banco_sangre_bd.encuesta_donante(pk_encuesta_donante);

ALTER TABLE banco_sangre_bd.Detalle_Encuesta
  ADD CONSTRAINT fk_pregunta_detalle_encuesta 
  FOREIGN KEY (fk_pregunta_detalle_encuesta) REFERENCES banco_sangre_bd.pregunta(pk_pregunta);

-- -----------------------------------------------------
-- Tabla Rol *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Rol;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Rol (
  pk_rol INT NOT NULL,
  nombre_rol VARCHAR(45) NULL,
  descripcion_rol TEXT NULL,
  estado_rol CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'El permiso de un rol podrá tener 2 estados A (activo) I (inactivo)'
);

ALTER TABLE banco_sangre_bd.Rol
  ADD CONSTRAINT PK_Rol PRIMARY KEY (pk_rol);
  
ALTER TABLE banco_sangre_bd.rol MODIFY banco_sangre_bd.rol.pk_rol INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Permiso *
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Permiso;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Permiso (
  pk_permiso INT NOT NULL,
  nombre_permiso VARCHAR(45) NULL,
  descripcion_permiso TEXT NULL
);

ALTER TABLE banco_sangre_bd.Permiso
  ADD CONSTRAINT PK_Permiso PRIMARY KEY (pk_permiso);
  
ALTER TABLE banco_sangre_bd.permiso MODIFY banco_sangre_bd.permiso.pk_permiso INT AUTO_INCREMENT;

-- -----------------------------------------------------
-- Tabla Rol_Permiso
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Rol_Permiso;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Rol_Permiso (
  pk_rol_permiso INT NOT NULL,
  fk_rol_rol_permiso INT NOT NULL,
  fk_permiso_rol_permiso INT NOT NULL,
  estado_rol_permiso CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'El estado del rol podrá ser A (activo) o I (inactivo)'
);

ALTER TABLE banco_sangre_bd.Rol_Permiso
  ADD CONSTRAINT PK_Rol_Permiso PRIMARY KEY (pk_rol_permiso);
  
ALTER TABLE banco_sangre_bd.rol_permiso MODIFY banco_sangre_bd.rol_permiso.pk_rol_permiso INT AUTO_INCREMENT;

ALTER TABLE banco_sangre_bd.rol_permiso
  ADD CONSTRAINT fk_rol_rol_permiso
  FOREIGN KEY (fk_rol_rol_permiso) REFERENCES banco_sangre_bd.rol(pk_rol);
  
ALTER TABLE banco_sangre_bd.rol_permiso
  ADD CONSTRAINT fk_permiso_rol_permiso
  FOREIGN KEY (fk_permiso_rol_permiso) REFERENCES banco_sangre_bd.permiso(pk_permiso);
  
-- -----------------------------------------------------
-- Tabla Usuario_Rol
-- -----------------------------------------------------
DROP TABLE IF EXISTS banco_sangre_bd.Usuario_Rol;

CREATE TABLE IF NOT EXISTS banco_sangre_bd.Usuario_Rol (
  pk_usuario_rol INT NOT NULL,
  fk_usuario_usuario_rol INT NOT NULL,
  fk_rol_usuario_rol INT NOT NULL
);

ALTER TABLE banco_sangre_bd.Usuario_Rol
  ADD CONSTRAINT pk_usuario_rol PRIMARY KEY (pk_usuario_rol);
  
ALTER TABLE banco_sangre_bd.usuario_rol MODIFY banco_sangre_bd.usuario_rol.pk_usuario_rol INT AUTO_INCREMENT;
  
ALTER TABLE banco_sangre_bd.Usuario_Rol
  ADD CONSTRAINT fk_usuario_usuario_rol
  FOREIGN KEY (fk_usuario_usuario_rol) REFERENCES banco_sangre_bd.usuario(pk_usuario);

ALTER TABLE banco_sangre_bd.Usuario_Rol
  ADD CONSTRAINT fk_rol_usuario_rol
  FOREIGN KEY (fk_rol_usuario_rol) REFERENCES banco_sangre_bd.rol(pk_rol);


-- ------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------
-- Funcion fn_convert_rh_grupo_sanguineo
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS fn_convert_rh_grupo_sanguineo;
DELIMITER $$
CREATE FUNCTION fn_convert_rh_grupo_sanguineo (rh TINYINT) 
RETURNS CHAR
DETERMINISTIC
BEGIN 
  DECLARE resp CHAR;
  CASE rh
  		WHEN 1
  			THEN SET resp = '+';
  		ELSE
  			SET resp = '-';
  END CASE;
  
  RETURN resp;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Funcion fn_convert_estado_solicitud_sangre
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS fn_convert_estado_solicitud_sangre;
DELIMITER $$
CREATE FUNCTION fn_convert_estado_solicitud_sangre (estado CHAR) 
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN 
  DECLARE resp VARCHAR(45);
  CASE estado
  		WHEN 'I'
  			THEN SET resp = 'Inactiva';
  		WHEN 'A'
  			THEN SET resp = 'Activa';
  	
  END CASE;
  
  RETURN resp;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Funcion fn_convert_sex
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS fn_convert_sex;
DELIMITER $$
CREATE FUNCTION fn_convert_sex (sex CHAR) 
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN 
  DECLARE resp VARCHAR(45);
  CASE sex
  		WHEN 'h'
  			THEN SET resp = 'Hombre';
  		ELSE
  			SET resp = 'Mujer';
  END CASE;
  
  RETURN resp;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Funcion fn_convert_state_solicitud_sangre
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS fn_convert_state_solicitud_sangre;
DELIMITER $$
CREATE FUNCTION fn_convert_state_solicitud_sangre (state CHAR) 
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN 
  DECLARE resp VARCHAR(45);
  CASE state
  		WHEN 'I'
  			THEN SET resp = 'Incompleta';
  		WHEN 'C'
  			THEN SET resp = 'Completa';
  		WHEN 'S'
  			THEN SET resp = 'Sin respuesta';
  		ELSE 
  			SET resp = 'X';
  END CASE;
  
  RETURN resp;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Funcion fn_verify_cod_registro_banco_sangre
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS fn_verify_cod_registro_banco_sangre;
DELIMITER $$
CREATE FUNCTION fn_verify_cod_registro_banco_sangre (cod VARCHAR(45)) 
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN 
  DECLARE resp TINYINT(1);
  
  SET resp = 0;
  SET @EXIST_COD := (SELECT COUNT(1) FROM banco_sangre_bd.banco_sangre WHERE codigo_registro_banco_sangre = cod);
  IF @EXIST_COD > 0 THEN
    SET resp = 1;
  END IF;
  
  RETURN resp;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Funcion fn_get_pk_banco_sangre
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS fn_get_pk_banco_sangre;
DELIMITER $$
CREATE FUNCTION fn_get_pk_banco_sangre (cod VARCHAR(45)) 
RETURNS INT
DETERMINISTIC
BEGIN 
  DECLARE resp INT;
  SET resp = NULL;
  SET resp = (SELECT banco_sangre.pk_banco_sangre FROM banco_sangre_bd.banco_sangre WHERE codigo_registro_banco_sangre = cod);
    
  RETURN resp;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Funcion fn_get_cant_sangre_donaciones_solicitud
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS banco_sangre_bd.fn_get_cs_don_sol;
DELIMITER $$
CREATE FUNCTION banco_sangre_bd.fn_get_cs_don_sol (id_donacion INT) 
RETURNS INT
DETERMINISTIC
BEGIN 
  DECLARE resp INT;
  SET resp = NULL;
  SET resp = (SELECT SUM(donacion.cantidad_sangre_donacion) 
											FROM banco_sangre_bd.donacion
											INNER JOIN banco_sangre_bd.solicitud_sangre ON donacion.fk_solicitud_sangre_donacion = solicitud_sangre.pk_solicitud_sangre
											WHERE solicitud_sangre.pk_solicitud_sangre = id_donacion
											LIMIT 1);
    
  RETURN resp;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Funcion fn_get_cant_sangre_solicitud
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS banco_sangre_bd.fn_get_cant_sangre_solicitud;
DELIMITER $$
CREATE FUNCTION banco_sangre_bd.fn_get_cant_sangre_solicitud (id_solicitud INT) 
RETURNS INT
DETERMINISTIC
BEGIN 
  DECLARE resp INT;
  SET resp = NULL;
  SET resp = (SELECT solicitud_sangre.cantidad_sangre_solicitud_sangre
											FROM banco_sangre_bd.solicitud_sangre
											WHERE id_solicitud = solicitud_sangre.pk_solicitud_sangre
											LIMIT 1);
    
  RETURN resp;
END$$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------
-- Vista vw_get_solicitudes
-- -----------------------------------------------------
CREATE OR REPLACE VIEW vw_get_solicitudes AS
	SELECT 
		solicitud_sangre.pk_solicitud_sangre AS id,
		CONCAT(grupo_sanguineo.marcador_grupo_sanguineo, fn_convert_rh_grupo_sanguineo(grupo_sanguineo.rh_grupo_sanguineo)) AS 'grupo_sanguineo',
		solicitud_sangre.cantidad_sangre_solicitud_sangre AS 'cantidad',
		DATE_FORMAT(solicitud_sangre.fecha_fin_solicitud_sangre, '%d - %M - %Y') AS 'fecha_fin',
		fn_convert_state_solicitud_sangre(solicitud_sangre.estado_solicitud_sangre) AS 'estado',
		fn_convert_sex(solicitud_sangre.sexo_donador_solicitud_sangre) AS 'sexo_donante',
		CONCAT (ciudad.nombre_ciudad, ', ', departamento.nombre_departamento) AS 'lugar',
		banco_sangre.razon_social_banco_sangre AS 'banco_sangre'
	FROM grupo_sanguineo
	INNER JOIN solicitud_sangre ON solicitud_sangre.fk_grupo_sanguineo_solicitud_sangre = grupo_sanguineo.pk_grupo_sanguineo
	INNER JOIN banco_sangre ON solicitud_sangre.fk_banco_sangre_solicitud_sangre = banco_sangre.pk_banco_sangre
	INNER JOIN codigo_nacional ON banco_sangre.fk_codigo_nacional_banco_sangre = codigo_nacional.pk_codigo_nacional
	INNER JOIN ciudad ON codigo_nacional.fk_ciudad_codigo_nacional = ciudad.pk_ciudad
	INNER JOIN departamento ON ciudad.fk_departamento_ciudad = departamento.pk_departamento
	WHERE solicitud_sangre.estado_solicitud_sangre != 'X'
	ORDER BY cantidad DESC;
SELECT * FROM vw_get_solicitudes;

-- -----------------------------------------------------
-- Vista vw_get_sangre_grupo_sanguineo_banco_sangre
-- -----------------------------------------------------
CREATE OR REPLACE VIEW banco_sangre_bd.vw_get_sangre_grupo_sanguineo_banco_sangre AS
	SELECT 
		CONCAT(grupo_sanguineo.marcador_grupo_sanguineo, fn_convert_rh_grupo_sanguineo(grupo_sanguineo.rh_grupo_sanguineo)) AS 'grupo_sangre',
		SUM(donacion.cantidad_sangre_donacion) AS cantidad
	FROM grupo_sanguineo
	INNER JOIN banco_sangre_bd.solicitud_sangre ON solicitud_sangre.fk_grupo_sanguineo_solicitud_sangre = grupo_sanguineo.pk_grupo_sanguineo
	INNER JOIN banco_sangre_bd.banco_sangre ON solicitud_sangre.fk_banco_sangre_solicitud_sangre = banco_sangre.pk_banco_sangre
	INNER JOIN banco_sangre_bd.donacion ON donacion.fk_solicitud_sangre_donacion = solicitud_sangre.pk_solicitud_sangre
	WHERE banco_sangre_bd.donacion.estado_donacion = 'D'
	GROUP BY grupo_sangre
	ORDER BY cantidad DESC;
SELECT * FROM vw_get_sangre_grupo_sanguineo_banco_sangre;


-- ------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------
-- Se simula una secuencia para el atributo consecutivo 
-- en la tabla codigo_nacional y codigo_registro en banco_sangre
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Tabla sequence_data
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS banco_sangre_bd.sequence_data (
  SEQUENCE_NAME VARCHAR(45) DEFAULT NULL,
  SEQUENCE_INCREMENT INT(11) DEFAULT '1',
  SEQUENCE_MIN_VALUE INT(11) DEFAULT '1',
  SEQUENCE_MAX_VALUE BIGINT(20) UNSIGNED DEFAULT '18446744073709551615',
  SEQUENCE_CUR_VALUE BIGINT(20) UNSIGNED DEFAULT NULL
);


-- -----------------------------------------------------
-- Funciones fn_CURRVAL y fn_NEXTVALUE
-- -----------------------------------------------------
DELIMITER $$
DROP FUNCTION IF EXISTS fn_CURRVAL;
CREATE FUNCTION fn_CURRVAL (SEQ_NAME VARCHAR(11)) 
RETURNS BIGINT(20)
BEGIN
  DECLARE EXIST_SEQ INT;
  DECLARE CUR_VALUE BIGINT(20);
  
  SET EXIST_SEQ = (SELECT COUNT(1) FROM sequence_data WHERE SEQUENCE_NAME = SEQ_NAME);
  SET CUR_VALUE = NULL;
  
  IF EXIST_SEQ > 0 THEN
    SET CUR_VALUE = (SELECT SEQUENCE_CUR_VALUE FROM sequence_data WHERE SEQUENCE_NAME = SEQ_NAME);
  END IF;
  
  RETURN CUR_VALUE; 
END$$

DROP FUNCTION IF EXISTS fn_NEXTVALUE;
CREATE FUNCTION fn_NEXTVALUE(SEQ_NAME VARCHAR(50)) 
RETURNS BIGINT(20)
BEGIN
	
  DECLARE EXIST_SEQ INT;
  DECLARE CUR_VALUE BIGINT(20);
  
  SET EXIST_SEQ = (SELECT COUNT(1) FROM sequence_data WHERE SEQUENCE_NAME = SEQ_NAME);
  
  IF EXIST_SEQ > 0 THEN
    UPDATE sequence_data
    SET SEQUENCE_CUR_VALUE = IF ( (IFNULL(SEQUENCE_CUR_VALUE,0) + SEQUENCE_INCREMENT) < SEQUENCE_MAX_VALUE ,
                                    IFNULL(SEQUENCE_CUR_VALUE,0) + SEQUENCE_INCREMENT,
                                    SEQUENCE_MAX_VALUE);
  END IF;
  
  SET CUR_VALUE = (SELECT SEQUENCE_CUR_VALUE FROM sequence_data WHERE SEQUENCE_NAME = SEQ_NAME);
  
	RETURN CUR_VALUE;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- Insert SEQ_COD_NAC en sequence_data
-- -----------------------------------------------------
DELETE FROM banco_sangre_bd.sequence_data WHERE SEQUENCE_NAME = 'SEQ_COD_NAC';
INSERT INTO banco_sangre_bd.sequence_data (SEQUENCE_NAME, SEQUENCE_CUR_VALUE) VALUES
	('SEQ_COD_NAC', 100);


-- -----------------------------------------------------
-- Trigger tg_update_seq_cod_nac
-- -----------------------------------------------------
DROP TRIGGER IF EXISTS banco_sangre_bd.tg_insert_seq_cod_nac;
DELIMITER $$
CREATE TRIGGER banco_sangre_bd.tg_insert_seq_cod_nac
BEFORE INSERT ON banco_sangre_bd.codigo_nacional
FOR EACH ROW
BEGIN
	SET NEW.consecutivo_codigo_nacional = (SELECT (fn_NEXTVALUE('SEQ_COD_NAC')-1) LIMIT 1);
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Insert SEQ_COD_REG_BS
-- -----------------------------------------------------
DELETE FROM banco_sangre_bd.sequence_data WHERE SEQUENCE_NAME = 'SEQ_COD_REG_BS';
INSERT INTO banco_sangre_bd.sequence_data (SEQUENCE_NAME, SEQUENCE_CUR_VALUE) VALUES
	('SEQ_COD_REG_BS', 99);


-- -----------------------------------------------------
-- Trigger tg_update_seq_cod_nac
-- -----------------------------------------------------
DROP TRIGGER IF EXISTS banco_sangre_bd.tg_insert_seq_cod_reg_bs;
DELIMITER $$
CREATE TRIGGER banco_sangre_bd.tg_insert_seq_cod_reg_bs
BEFORE INSERT ON banco_sangre_bd.banco_sangre
FOR EACH ROW
BEGIN
	SET NEW.codigo_registro_banco_sangre = CONCAT((SELECT fn_NEXTVALUE('SEQ_COD_REG_BS') LIMIT 1), (SELECT 100 + ROUND(RAND() * (999 - 100))));
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Trigger tg_update_estado_solicitud_donacion
-- -----------------------------------------------------
DROP TABLE IF EXISTS logs;
create table logs (logstring nvarchar(845));
DROP TRIGGER IF EXISTS banco_sangre_bd.tg_update_estado_solicitud_donacion;
DELIMITER $$
CREATE TRIGGER banco_sangre_bd.tg_update_estado_solicitud_donacion
AFTER INSERT ON banco_sangre_bd.donacion
FOR EACH ROW
BEGIN

	DECLARE cant_sangre_solicitud INT;
  	DECLARE cant_sangre_donacion BIGINT(20);
  	DECLARE estado CHAR(1);
  	
	SET cant_sangre_solicitud:= (SELECT fn_get_cant_sangre_solicitud(NEW.fk_solicitud_sangre_donacion));
	SET cant_sangre_donacion := (SELECT fn_get_cs_don_sol(NEW.fk_solicitud_sangre_donacion));
	
	IF (cant_sangre_solicitud > cant_sangre_donacion) THEN 
		SET estado = 'I';
	ELSE
		SET estado = 'C';
	END IF;
	
	INSERT INTO LOGS VALUES (CONCAT('sol = ', cant_sangre_solicitud, ' dona= ', cant_sangre_donacion, '--> COMPARACION =', cant_sangre_solicitud > cant_sangre_donacion, 'Estado = ', estado));
	
	UPDATE solicitud_sangre
			SET estado_solicitud_sangre =  estado
			WHERE pk_solicitud_sangre = NEW.fk_solicitud_sangre_donacion;
END$$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------
-- Procedimiento pd_registrar_usuario
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_registrar_usuario;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_registrar_usuario(
	IN _correo VARCHAR(45),
	IN _contrasena VARCHAR(45),
	IN _nombres VARCHAR(45),
	IN _apellidos VARCHAR(45),
	IN _sexo CHAR(1),
	IN _peso DOUBLE,
	IN _altura DOUBLE,
	IN _ciudad_nacimiento TINYINT(3),
	IN _ciudad_residencia TINYINT(3),
	IN _fecha_nacimiento DATE,
	IN _numero_identificacion VARCHAR(10),
	IN _tipo_identificacion INT,
	IN _afiliacion_salud INT,
	IN _grupo_sanguineo INT,
	IN _codigo_registro_banco_sangre VARCHAR(45)
)
BEGIN
	INSERT INTO banco_sangre_bd.usuario (correo_usuario, contrasena_usuario) VALUES (_correo, _contrasena);
	
	SET @last_id_in_usuario := (SELECT MAX(pk_usuario) FROM banco_sangre_bd.usuario);
	
	IF ((SELECT fn_verify_cod_registro_banco_sangre(_codigo_registro_banco_sangre)) > 0)
   	THEN SET @u_rol := 4;
   ELSE
   	SET @u_rol := 1;
	END IF;
	
	
	INSERT INTO banco_sangre_bd.persona (nombres_persona, apellidos_persona, sexo_persona, peso_persona, altura_persona, fk_ciudad_nacimiento_persona, fk_ciudad_residencia_persona, fecha_nacimiento_persona, numero_identificacion_persona, fk_tipo_documento_identidad_persona, fk_afiliacion_salud_persona, fk_grupo_sanguineo_persona, fk_usuario_persona, fk_banco_sangre_persona) VALUES
	(_nombres, _apellidos, _sexo, _peso, _altura, _ciudad_nacimiento, _ciudad_residencia, _fecha_nacimiento, _numero_identificacion, _tipo_identificacion, _afiliacion_salud, _grupo_sanguineo, @last_id_in_usuario, (SELECT(fn_get_pk_banco_sangre(_codigo_registro_banco_sangre))));
	

	INSERT INTO banco_sangre_bd.usuario_rol (fk_usuario_usuario_rol, fk_rol_usuario_rol) VALUES (@last_id_in_usuario, @u_rol);
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Procedimiento pd_registrar_banco_sangre
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_registrar_banco_sangre;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_registrar_banco_sangre(
	IN _razon_social VARCHAR(45), 
	IN _direccion VARCHAR(45), 
	IN _fk_codigo_nacional INT 
)
BEGIN
	INSERT INTO banco_sangre_bd.banco_sangre (razon_social_banco_sangre, direccion_banco_sangre, fk_codigo_nacional_banco_sangre ) 
		VALUES (_razon_social, _direccion, _fk_codigo_nacional);
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Procedimiento pd_registrar_solicitud_sangre
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_registrar_solicitud_sangre;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_registrar_solicitud_sangre(
	IN _cantidad_sangre INT, 
	IN _fecha_fin DATE, 
	IN _sexo_donador CHAR(1),
	IN _fk_grupo_sanguineo INT,
	IN _fk_banco_sangre INT,
	IN _fk_persona_receptora INT
)
BEGIN
	INSERT INTO solicitud_sangre (cantidad_sangre_solicitud_sangre, fecha_fin_solicitud_sangre, sexo_donador_solicitud_sangre, fk_grupo_sanguineo_solicitud_sangre, fk_banco_sangre_solicitud_sangre, fk_persona_receptora_solicitud_sangre)
		VALUES (_cantidad_sangre, _fecha_fin, _sexo_donador, _fk_grupo_sanguineo, _fk_banco_sangre, _fk_persona_receptora);
		
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Procedimiento pd_update_solicitud_sangre
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_update_solicitud_sangre;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_update_solicitud_sangre(
	IN _id INT,
	IN _cantidad_sangre INT, 
	IN _fecha_fin DATE, 
	IN _sexo_donador CHAR(1),
	IN _fk_grupo_sanguineo INT,
	IN _fk_banco_sangre INT
)
BEGIN
	UPDATE solicitud_sangre 
	SET cantidad_sangre_solicitud_sangre = _cantidad_sangre,
	 	 fecha_fin_solicitud_sangre = _fecha_fin, 
		 sexo_donador_solicitud_sangre = _sexo_donador, 
		 fk_grupo_sanguineo_solicitud_sangre = _fk_grupo_sanguineo,
		 fk_banco_sangre_solicitud_sangre = _fk_banco_sangre
	WHERE pk_solicitud_sangre = _id;
	
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Procedimiento pd_registrar_donacion
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_registrar_donacion;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_registrar_donacion(
	IN _cantidad_sangre INT,
	IN _fk_solicitud_sangre INT
)
BEGIN
	INSERT INTO donacion (cantidad_sangre_donacion, fk_solicitud_sangre_donacion) 
		VALUES (_cantidad_sangre, _fk_solicitud_sangre);
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Procedimiento pd_iniciar_sesion
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_iniciar_sesion;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_iniciar_sesion(
	IN _correo VARCHAR(45),
	IN _contrasena VARCHAR(45)
)
BEGIN
	SELECT rol.pk_rol AS id_rol, 
			 rol.nombre_rol AS nombre_rol 
	FROM banco_sangre_bd.usuario
	INNER JOIN banco_sangre_bd.usuario_rol ON usuario_rol.fk_usuario_usuario_rol = usuario.pk_usuario
	INNER JOIN banco_sangre_bd.rol ON usuario_rol.fk_rol_usuario_rol = rol.pk_rol
	WHERE (usuario.correo_usuario = _correo AND usuario.contrasena_usuario = _contrasena);
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Procedimiento pd_permisos_rol
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS banco_sangre_bd.pd_permisos_rol;
DELIMITER $$
CREATE PROCEDURE banco_sangre_bd.pd_permisos_rol(
	IN _pk_rol VARCHAR(45)
)
BEGIN
	SELECT permiso.pk_permiso AS id_permiso, 
			 permiso.nombre_permiso AS nombre_permiso
	FROM banco_sangre_bd.rol
	INNER JOIN banco_sangre_bd.rol_permiso ON rol_permiso.fk_rol_rol_permiso = rol.pk_rol
	INNER JOIN banco_sangre_bd.permiso ON rol_permiso.fk_permiso_rol_permiso = permiso.pk_permiso
	WHERE _pk_rol = rol.pk_rol;
END$$
DELIMITER ;




-- ------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------
FLUSH TABLES;
INSERT INTO tipo_documento_identidad (nombre_tipo_documento_identidad) VALUES
	('Cédula de ciudadanía'),
	('Pasaporte'),
	('Tarjeta de identidad');
	
INSERT INTO rol (nombre_rol, descripcion_rol) VALUES
	('Receptor', 'Persona que solicita una donación'),
	('Donante', 'Persona quien podrá gestionar su usuario en el sistema, a través de tramitar la encuesta como donante potencial, además podrá consultar los bancos de sangre y gestionar solicitudes de sangre.'),
	('Admin BS', 'Administrador del banco de sangre que registre'),
	('Empleado', 'Persona empleada en el banco de sangre y registrada con un único usuario en el sistema, el cual podrá gestionar y quien tendrá permisos tales como: registrar y consultar usuarios, además de actualizar usuarios donantes y consultar la diligenciación y resultados de las encuestas realizadas por ellos (donantes). De igual forma podrá gestionar las unidades, solicitudes y donaciones de sangre.');

INSERT INTO departamento (nombre_departamento) VALUES
	('Caquetá'),
	('Huila'),
	('Cundinamarca'),
	('Putumayo'),
	('Valle del cauca');
	
INSERT INTO ciudad (nombre_ciudad, fk_departamento_ciudad) VALUES
	('Florencia', 01),
	('Cauca', 05),
	('Mocoa', 04),
	('Pitalito', 02),
	('Bogotá', 03);

INSERT INTO afiliacion_salud (nombre_afiliacion_salud) VALUES
	('Asmet Salud'),
	('Cafesalud E.P.S. S.A.'),
	('Colseguros E.P.S.'),
	('Coomeva E.P.S. S.A.'),
	('Caprecom E.P.S. ');
	
INSERT INTO grupo_sanguineo (marcador_grupo_sanguineo, rh_grupo_sanguineo) VALUES
	('A', 1),
	('A', 0),
	('B', 1),
	('B', 0),
	('AB', 1),
	('AB', 0),
	('O', 1),
	('O', 0);

INSERT INTO codigo_nacional (fk_ciudad_codigo_nacional) VALUES
	(001),
	(005),
	(004),
	(003),
	(002);

	
/*  		CALL pd_registrar_banco_sangre ('Fundación Hematologica Colombia', 'Cra. 65 #81 - 67', 1);
 		CALL pd_registrar_banco_sangre ('Hospital Maria Inmaculada', 'Cra 7 #17-24', 2);
 		CALL pd_registrar_banco_sangre ('E.S.E. Hospital Departamental San  Antonio', 'Avenida, Juan Bosco', 3);
 	 	CALL pd_registrar_banco_sangre ('Hemocentro Valle del Cauca - Banco ', 'Cl. 5 #36 - 08', 4);
*/

-- INSERT INTO usuario (correo_usuario, contrasena_usuario) VALUES
-- 	('st.cardenas@udla.edu.co', '1006410968'),
-- 	('f.yate@udla.edu.co', '1006513423'),
-- 	('valerie19@gmail.com', '2342352'),
-- 	('martha6@hotmail.com', 'martha06'),
-- 	('sebastian99@gmail.com', 'sebastian1999'),
-- 	('camila_27@hotmail.com', 'camila27'),
-- 	('duverney_j@gmail.com', 'duver1923'),
-- 	('viviana22@outlook.es', 'viviana22'),
-- 	('yu.yate@udla.edu.co', 'yu.yate'),
-- 	('davidanacona@hotmail.com', 'pxndx');

/* INSERT INTO persona (nombres_persona, apellidos_persona, sexo_persona, peso_persona, altura_persona, fk_ciudad_nacimiento_persona, fk_ciudad_residencia_persona, fecha_nacimiento_persona, numero_identificacion_persona, fk_tipo_documento_identidad_persona, fk_afiliacion_salud_persona, fk_grupo_sanguineo_persona, fk_usuario_persona, fk_banco_sangre_persona) VALUES
 	('Fabian', 'Yate Ramirez', 'H', 65, 1.7, 001, 001, '1999-02-15', '1006513247', 1, 1, 7, 2, NULL),
 	('Stefany', 'Cárdenas', 'M', 43, 1.6, 001, 001, '2000-11-19', '1006410968', 1, 1, 7, 1, 1),
 	('Camila', 'Perdomo', 'M', 60, 1.6, 001, 001, '1999-01-27', '1247126412', 1, 4, 7, 6, NULL),
 	('Viviana', 'Ramirez', 'M', 70, 1.65, 001, 001, '1992-11-22', '1117223232', 1, 1, 7, 8, NULL),
 	('Duverney', 'Morales', 'H', 70, 1.68, 002, 002, '1990-03-07', '5043934', 1, 5, 4, 7, 4),
 	('Martha', 'Martínez', 'M', 74, 1.7, 001, 001, '1947-04-27', '4353534', 1, 1, 3, 4, 3);
*/
/*	CALL banco_sangre_bd.pd_registrar_usuario ('st.cardenas@udla.edu.co', '1006410968', 'Stefany', 'Cárdenas', 'M', 43, 1.6, 001, 001, '2000-11-19', '1006410968', 1, 1, 7, 105366);
 	CALL banco_sangre_bd.pd_registrar_usuario ('f.yate@udla.edu.co', '1006513423', 'Fabian', 'Yate Ramirez', 'H', 65, 1.7, 001, 001, '1999-02-15', '1006513247', 1, 1, 7,  NULL);
 	CALL banco_sangre_bd.pd_registrar_usuario ('valerie19@gmail.com', '2342352', 'Valerie', 'Cardenas Martinez', 'M', 60, 1.6, 001, 001, '1999-01-27', '1247126412', 1, 4, 7, NULL);
 	CALL banco_sangre_bd.pd_registrar_usuario ('martha6@hotmail.com', 'martha06', 'Martha', 'Martínez', 'M', 74, 1.7, 001, 001, '1947-04-27', '4353534', 1, 1, 3, 105366);
	CALL banco_sangre_bd.pd_registrar_usuario ('viviana22@outlook.es', 'viviana22', 'Viviana', 'Ramirez', 'M', 70, 1.65, 001, 001, '1992-11-22', '1117223232', 1, 1, 7, NULL);
	
	
INSERT INTO telefono (numero_telefono, fk_persona_telefono) VALUES
	('3224567765', 1),
	('3224567165', 1),
	('3224567765', 2),
	('3121167765', 4),
	('3222167765', 5),
	('3224567765', 5); 
*/	

/*INSERT INTO encuesta_donante (observaciones_encuesta_donante, fk_persona_encuesta_donante) VALUES
	('Sin observaciones' , 1);
*/

INSERT INTO pregunta (texto_pregunta) VALUES
	('¿Ha donado sangre anteriormente? ¿Hace cuánto? (escribir fecha) ¿Ha tenido reacción adversa a la donación? ¿Qué presento?'),
	('¿Ha sido declarado alguna vez no apto para donar sangre? ¿Por qué?'),
	('¿Se ha sentido bien de salud en las últimas (2) dos semanas?'),
	('¿En los últimos 12 meses estuvo hospitalizado, bajo tratamiento médico o le han realizado alguna cirugía? ¿Cuál?'),
	('¿Alguna vez usted o su pareja, han recibido transfusión sanguínea, trasplante de órganos, tejidos u hormona del crecimiento? '),
	('¿Ha tenido una nueva pareja sexual en los últimos seis (6) meses? '),
	('¿Ha tenido relaciones sexuales con personas pertenecientes a alguna de las poblaciones clave (trabajadores sexuales, habitantes de calle, personas que se inyectan drogas, hombres que tienen relaciones sexuales con hombres, mujeres transgénero)?'),
	('En el último mes, ¿ha tomado algún medicamento? ¿Cuál? ¿Para qué le fue formulado? ');
	
/* INSERT INTO respuesta (texto_respuesta, fk_pregunta_respuesta) VALUES
	('No', 5),
	('No', 1),
	('No', 3),
	('Sí', 4); */

/*INSERT INTO detalle_encuesta (fk_encuesta_donante_detalle_encuesta, fk_pregunta_detalle_encuesta) VALUES
	(1, 5),
	(1, 1, 'A'),
	(1, 3);*/

/*INSERT INTO solicitud_sangre (cantidad_sangre_solicitud_sangre, fecha_fin_solicitud_sangre, sexo_donador_solicitud_sangre, fk_grupo_sanguineo_solicitud_sangre, fk_banco_sangre_solicitud_sangre, fk_persona_receptora_solicitud_sangre) VALUES
	(5, '2021-09-07', 'M', 1, 1, 2),
	(2, '2021-11-04', 'H', 5, 2, 2),
	(10, '2021-08-07', 'M', 2, 2, 2),
	(10, '2021-08-07', 'M', 3, 1, 1);


INSERT INTO donacion (cantidad_sangre_donacion, fk_respuesta_solicitud_sangre, fk_persona_donacion) VALUES
	(5, 2, 1);
*/

INSERT INTO permiso (nombre_permiso, descripcion_permiso) VALUES 
	('Donar', 'Donar - Solicitudes afines'),
	('Mis-solicitudes', 'Visualizar, editar y eliminar las solicitudes propias'),
	('Crear-solicitud', ''),
	('Lista-bancos-sangre', ''),
	('Registrar-banco-sangre', ''),
	('Responder-encuesta', ''),
	('Historial-encuestas', 'Las encuestas que se han realizado'),
	('Historial-donaciones', 'Las donaciones realizadas'),
	('Perfil', 'Visualizar y editar perfil'),
	('Donaciones', 'Programar donacion'),
	('Listado-empleados', ''),
	('Listado-sangre-grupo-sanguineo', ''),
	('Banco-sangre-perfil', 'Visualizar y editar perfil del banco de sangre'),
	('Ver-encuestas', ''),
	('Actualizar encuestas', '');
	
INSERT INTO rol_permiso (fk_rol_rol_permiso, fk_permiso_rol_permiso) VALUES 
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 5),
	(1, 6),
	(1, 7),
	(1, 8),
	(1, 9),
	(2, 1),
	(3, 1),
	(3, 2),
	(3, 3),
	(4, 1),
	(4, 2);

/*INSERT INTO usuario_rol () VALUES
	(1, 1, 2),
	(2, 9, 1),
	(3, 8, 4),
	(4, 2, 3),
	(5, 3, 1);
*/



CALL banco_sangre_bd.pd_registrar_banco_sangre ('E.S.E. Hospital Departamental San  Antonio', 'Avenida, Juan Bosco', 3);
CALL pd_registrar_banco_sangre ('Fundación Hematologica Colombia', 'Cra. 65 #81 - 67', 1);
CALL pd_registrar_banco_sangre ('Hospital Maria Inmaculada', 'Cra 7 #17-24', 2);
CALL pd_registrar_banco_sangre ('E.S.E. Hospital Departamental San  Antonio', 'Avenida, Juan Bosco', 3);
CALL pd_registrar_banco_sangre ('Hemocentro Valle del Cauca - Banco ', 'Cl. 5 #36 - 08', 4);

CALL banco_sangre_bd.pd_registrar_usuario ('st.cardenas@udla.edu.co', '1006410968', 'Stefany', 'Cárdenas', 'M', 43, 1.6, 001, 001, '2000-11-19', '1006410968', 1, 1, 7, 123);
CALL banco_sangre_bd.pd_registrar_usuario ('f.yate@udla.edu.co', '1006513423', 'Fabian', 'Yate Ramirez', 'H', 65, 1.7, 001, 001, '1999-02-15', '1006513247', 1, 1, 7,  NULL);
CALL banco_sangre_bd.pd_registrar_usuario ('valerie19@gmail.com', '2342352', 'Valerie', 'Cardenas Martinez', 'M', 60, 1.6, 001, 001, '1999-01-27', '1247126412', 1, 4, 7, NULL);
CALL banco_sangre_bd.pd_registrar_usuario ('martha6@hotmail.com', 'martha06', 'Martha', 'Martínez', 'M', 74, 1.7, 001, 001, '1947-04-27', '4353534', 1, 1, 3, NULL);
CALL banco_sangre_bd.pd_registrar_usuario ('viviana22@outlook.es', 'viviana22', 'Viviana', 'Ramirez', 'M', 70, 1.65, 001, 001, '1992-11-22', '1117223232', 1, 1, 7, NULL);
	
CALL banco_sangre_bd.pd_registrar_solicitud_sangre('2', '2021-06-06', 'M', '3', '1', '1');
CALL banco_sangre_bd.pd_registrar_solicitud_sangre('3', '2021-06-06', 'H', '3', '1', '1');

SELECT * FROM vw_get_sangre_grupo_sanguineo_banco_sangre;
SELECT * FROM vw_get_solicitudes;

CALL `pd_registrar_donacion`('1', '1');
