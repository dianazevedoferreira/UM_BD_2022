-- Universidade do Minho
-- Bases de Dados 2022
-- Caso de Estudo: Hospital Portucalense


-- -----------------------------------------------------
-- Schema hospitalPortucalense
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hospitalPortucalense` DEFAULT CHARACTER SET utf8 ;
USE `hospitalPortucalense` ;

-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`procedimentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`procedimentos` (
  `cod_procedimento` INT NOT NULL AUTO_INCREMENT,
  `des_procedimento` VARCHAR(45) NOT NULL,
  `preco` DECIMAL(5,2) NOT NULL,
  CONSTRAINT `chk_preco`
	CHECK(`preco` > 0.00),
  PRIMARY KEY (`cod_procedimento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`Horario_Agendamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`Horario_Agendamento` (
  `id_agenda` INT NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `hora_ini` TIME NOT NULL,
  `hora_fim` TIME NOT NULL,
  `estado` TINYINT(1) NULL DEFAULT 0,
  CONSTRAINT `chk_estado`
	CHECK(`estado` IN (0,1)),
  PRIMARY KEY (`id_agenda`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`pacientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`pacientes` (
  `nr_sequencial` INT(6) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `sexo` CHAR(1) NOT NULL,
  `dta_nascimento` DATE NOT NULL,
  `NIF` CHAR(9) NOT NULL UNIQUE,
  `nr_utente` CHAR(9) NOT NULL UNIQUE,
  `estado_civil` CHAR(1) NULL,
  `rua` VARCHAR(100) NOT NULL,
  `localidade` VARCHAR(45) NOT NULL,
  `cod_postal` CHAR(8) NOT NULL,
  PRIMARY KEY (`nr_sequencial`),
  CONSTRAINT `chk_sexo`
	CHECK(`sexo` IN ('F','M','I')),
  CONSTRAINT `chk_estado_civil`
	CHECK(`estado_civil` IN ('S', 'C', 'D', 'V')))
ENGINE = InnoDB;

-- CREATE UNIQUE INDEX `NIF_UNIQUE` ON `hospitalPortucalense`.`pacientes` (`NIF`);
-- CREATE UNIQUE INDEX `nr_utente_UNIQUE` ON `hospitalPortucalense`.`pacientes` (`nr_utente`);



-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`farmacos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`farmacos` (
  `id_farmaco` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(150) NULL,
  PRIMARY KEY (`id_farmaco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`funcionarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`funcionarios` (
  `num_mec` INT NOT NULL AUTO_INCREMENT,
  `dta_ini_servico` DATE NOT NULL,
  PRIMARY KEY (`num_mec`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`especialidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`especialidades` (
  `cod_especialidade` INT NOT NULL AUTO_INCREMENT,
  `des_especialidade` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cod_especialidade`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`medicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`medicos` (
  `num_mec` INT NOT NULL,
  `nome_medico` VARCHAR(45) NOT NULL,
  `cod_especialidade` INT NOT NULL,
  PRIMARY KEY (`num_mec`),
  INDEX `fk_Médico_Especialidade_idx` (`cod_especialidade` ASC) VISIBLE,
  CONSTRAINT `fk_Médico_Funcionário`
    FOREIGN KEY (`num_mec`)
    REFERENCES `hospitalPortucalense`.`funcionarios` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Médico_Especialidade`
    FOREIGN KEY (`cod_especialidade`)
    REFERENCES `hospitalPortucalense`.`especialidades` (`cod_especialidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Médico_Especialidade_idx` ON `hospitalPortucalense`.`medicos` (`cod_especialidade` ASC) VISIBLE;



-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`administrativos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`administrativos` (
  `num_mec` INT NOT NULL,
  `nome_administrativo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`num_mec`),
  CONSTRAINT `fk_Administrativo_Funcionário`
    FOREIGN KEY (`num_mec`)
    REFERENCES `hospitalPortucalense`.`funcionarios` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`consultas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`consultas` (
  `nr_episodio` INT NOT NULL AUTO_INCREMENT,
  `id_paciente` INT NOT NULL,
  `id_medico` INT NOT NULL,
  `id_agenda` INT NOT NULL,
  `id_proc` INT NULL,
  `id_secretaria` INT NULL,
  `hora_ini` DATETIME NULL,
  `hora_fim` DATETIME NULL,
  `preco` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`nr_episodio`, `id_paciente`, `id_medico`),
  CONSTRAINT `chk_preco2`
	CHECK(`preco` > 0.00),
  INDEX `fk_Consulta_Paciente_idx` (`id_paciente` ASC) VISIBLE,
  INDEX `fk_Consulta_Médico_idx` (`id_medico` ASC) VISIBLE,
  INDEX `fk_Consulta_Horario_Agendamento_idx` (`id_agenda` ASC) VISIBLE,
  INDEX `fk_Consulta_Procedimento_idx` (`id_proc` ASC) VISIBLE,
  INDEX `fk_Consulta_Administrativo_idx` (`id_secretaria` ASC) VISIBLE,
  CONSTRAINT `fk_Consulta_Paciente`
    FOREIGN KEY (`id_paciente`)
    REFERENCES `hospitalPortucalense`.`pacientes` (`nr_sequencial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Médico`
    FOREIGN KEY (`id_medico`)
    REFERENCES `hospitalPortucalense`.`medicos` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Horario_Agendamento`
    FOREIGN KEY (`id_agenda`)
    REFERENCES `hospitalPortucalense`.`Horario_Agendamento` (`id_agenda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Procedimento`
    FOREIGN KEY (`id_proc`)
    REFERENCES `hospitalPortucalense`.`procedimentos` (`cod_procedimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Administrativo`
    FOREIGN KEY (`id_secretaria`)
    REFERENCES `hospitalPortucalense`.`administrativos` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Consulta_Paciente_idx` ON `hospitalPortucalense`.`consultas` (`id_paciente` ASC) VISIBLE;
-- CREATE INDEX `fk_Consulta_Médico_idx` ON `hospitalPortucalense`.`consultas` (`id_medico` ASC) VISIBLE;
-- CREATE INDEX `fk_Consulta_Horario_Agendamento_idx` ON `hospitalPortucalense`.`consultas` (`id_agenda` ASC) VISIBLE;
-- CREATE INDEX `fk_Consulta_Procedimento_idx` ON `hospitalPortucalense`.`consultas` (`id_proc` ASC) VISIBLE;
-- CREATE INDEX `fk_Consulta_Administrativo_idx` ON `hospitalPortucalense`.`consultas` (`id_secretaria` ASC) VISIBLE;



-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`administradores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`administradores` (
  `num_mec` INT NOT NULL,
  `nome_administrador` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`num_mec`),
  CONSTRAINT `fk_Administrador_Funcionário`
    FOREIGN KEY (`num_mec`)
    REFERENCES `hospitalPortucalense`.`funcionarios` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`prescricoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`prescricoes` (
  `nr_episodio` INT NOT NULL,
  `id_paciente` INT NOT NULL,
  `id_medico` INT NOT NULL,
  `id_farmaco` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `unidade` VARCHAR(5) NOT NULL,
  `data_validade` DATETIME NOT NULL,
  `data_prescricao` DATETIME NOT NULL,
  `posologia` VARCHAR(45) NULL,
  `PVP` DECIMAL(5,2) NULL,
  `comparticipacao` DECIMAL(5,2) NULL,
  PRIMARY KEY (`nr_episodio`, `id_paciente`, `id_medico`, `id_farmaco`),
  CONSTRAINT `chk_quantidade`
	CHECK(`quantidade` > 0),
  CONSTRAINT `chk_PVP`
	CHECK(`PVP` > 0.00),
  CONSTRAINT `chk_comparticipacao`
	CHECK(`comparticipacao` >= 0.00),
  CONSTRAINT `chk_unidade`
	CHECK(`unidade` IN ('ml','mg')),
  INDEX `fk_Prescricao_Medicamento_idx` (`id_farmaco` ASC) VISIBLE,
  INDEX `fk_Prescricao_Consulta_idx` (`nr_episodio` ASC, `id_paciente` ASC, `id_medico` ASC) VISIBLE,
  CONSTRAINT `fk_Prescricao_Consulta`
    FOREIGN KEY (`nr_episodio` , `id_paciente` , `id_medico`)
    REFERENCES `hospitalPortucalense`.`consultas` (`nr_episodio` , `id_paciente` , `id_medico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prescricao_Medicamento`
    FOREIGN KEY (`id_farmaco`)
    REFERENCES `hospitalPortucalense`.`farmacos` (`id_farmaco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Prescricao_Medicamento_idx` ON `hospitalPortucalense`.`prescricoes` (`id_farmaco` ASC) VISIBLE;
-- CREATE INDEX `fk_Prescricao_Consulta_idx` ON `hospitalPortucalense`.`prescricoes` (`nr_episodio` ASC, `id_paciente` ASC, `id_medico` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`telefones_pac`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`telefones_pac` (
  `telefone` CHAR(9) NOT NULL,
  `nr_sequencial` INT(6) NOT NULL,
  PRIMARY KEY (`telefone`, `nr_sequencial`),
  INDEX `fk_Telefones_Pacientes_Paciente_idx` (`nr_sequencial` ASC) VISIBLE,
  CONSTRAINT `fk_Telefones_Pacientes_Paciente`
    FOREIGN KEY (`nr_sequencial`)
    REFERENCES `hospitalPortucalense`.`pacientes` (`nr_sequencial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Telefones_Pacientes_Paciente_idx` ON `hospitalPortucalense`.`telefones_pac` (`nr_sequencial` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`emails_pac`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`emails_pac` (
  `email` VARCHAR(45) NOT NULL,
  `nr_sequencial` INT(6) NOT NULL,
  PRIMARY KEY (`email`, `nr_sequencial`),
  INDEX `fk_Emails_Pacientes_Paciente_idx` (`nr_sequencial` ASC) VISIBLE,
  CONSTRAINT `fk_Emails_Pacientes_Paciente`
    FOREIGN KEY (`nr_sequencial`)
    REFERENCES `hospitalPortucalense`.`pacientes` (`nr_sequencial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Emails_Pacientes_Paciente_idx` ON `hospitalPortucalense`.`emails_pac` (`nr_sequencial` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`telefones_func`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`telefones_func` (
  `telefone` CHAR(9) NOT NULL,
  `num_mec` INT NOT NULL,
  PRIMARY KEY (`telefone`),
  INDEX `fk_Telefones_Func_Funcionário_idx` (`num_mec` ASC) VISIBLE,
  CONSTRAINT `fk_Telefones_Func_Funcionário`
    FOREIGN KEY (`num_mec`)
    REFERENCES `hospitalPortucalense`.`funcionarios` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Telefones_Func_Funcionário_idx` ON `hospitalPortucalense`.`telefones_func` (`num_mec` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `hospitalPortucalense`.`emails_func`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitalPortucalense`.`emails_func` (
  `email` VARCHAR(45) NOT NULL,
  `num_mec` INT NOT NULL,
  PRIMARY KEY (`email`),
  INDEX `fk_Emails_Func_Funcionário_idx` (`num_mec` ASC) VISIBLE,
  CONSTRAINT `fk_Emails_Func_Funcionário`
    FOREIGN KEY (`num_mec`)
    REFERENCES `hospitalPortucalense`.`funcionarios` (`num_mec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- CREATE INDEX `fk_Emails_Func_Funcionário_idx` ON `hospitalPortucalense`.`emails_func` (`num_mec` ASC) VISIBLE;