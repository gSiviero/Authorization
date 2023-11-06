-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Authorization
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Authorization
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Authorization` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `Authorization` ;

-- -----------------------------------------------------
-- Table `Authorization`.`EntityTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`EntityTypes` (
  `idEntityTypes` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(250) NULL DEFAULT NULL,
  `category` ENUM('Company', 'Branch', 'Department', 'Project', 'Business Unit') NOT NULL DEFAULT 'Company',
  PRIMARY KEY (`idEntityTypes`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Features` (
  `idFeatures` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(250) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `deletedAt` DATETIME NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `price` DECIMAL(2,0) NOT NULL DEFAULT '0',
  `idEntityType` INT NOT NULL,
  PRIMARY KEY (`idFeatures`),
  INDEX `fk_Features_EntityType_idx` (`idEntityType` ASC) VISIBLE,
  CONSTRAINT `fk_Features_EntityType`
    FOREIGN KEY (`idEntityType`)
    REFERENCES `Authorization`.`EntityTypes` (`idEntityTypes`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Users` (
  `idUser` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(250) NOT NULL,
  `email` VARCHAR(250) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `deletedAt` DATETIME NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idUser`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Acess_LOG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Acess_LOG` (
  `idUser` INT NOT NULL,
  `idFeature` INT NOT NULL,
  `permission` ENUM('read', 'write', 'delete', 'admin') NOT NULL,
  `timeStamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idUser`, `idFeature`),
  INDEX `fk_Acess_LOG_Feature_idx` (`idFeature` ASC) VISIBLE,
  CONSTRAINT `fk_Acess_LOG_Feature`
    FOREIGN KEY (`idFeature`)
    REFERENCES `Authorization`.`Features` (`idFeatures`),
  CONSTRAINT `fk_Acess_LOG_User`
    FOREIGN KEY (`idUser`)
    REFERENCES `Authorization`.`Users` (`idUser`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Entities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Entities` (
  `idEntity` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(250) NOT NULL,
  `description` VARCHAR(250) NULL DEFAULT NULL,
  `parentEntity` INT NULL DEFAULT NULL,
  `createdAt` DATETIME NULL DEFAULT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `deletedAt` DATETIME NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `entityType` INT NOT NULL,
  PRIMARY KEY (`idEntity`, `deleted`),
  INDEX `fk_Entity_EntityType_idx` (`entityType` ASC) VISIBLE,
  CONSTRAINT `fk_Entity_EntityType`
    FOREIGN KEY (`entityType`)
    REFERENCES `Authorization`.`EntityTypes` (`idEntityTypes`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Roles` (
  `idRole` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL,
  `deletedAt` DATETIME NULL DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT '0',
  `updatedAt` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idRole`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Roles_Features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Roles_Features` (
  `idRole` INT NOT NULL,
  `idFeature` INT NOT NULL,
  `permission` ENUM('read', 'write', 'delete', 'admin') NOT NULL,
  PRIMARY KEY (`idRole`, `idFeature`),
  INDEX `fk_Role_Feature_idx` (`idRole` ASC) VISIBLE,
  INDEX `fk_Feature_Role_idx` (`idFeature` ASC) VISIBLE,
  CONSTRAINT `fk_Feature_Role`
    FOREIGN KEY (`idFeature`)
    REFERENCES `Authorization`.`Features` (`idFeatures`),
  CONSTRAINT `fk_Roles_Features`
    FOREIGN KEY (`idRole`)
    REFERENCES `Authorization`.`Roles` (`idRole`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Roles_Features_LOG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Roles_Features_LOG` (
  `logTimeStamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idRole` INT NOT NULL,
  `idFeature` INT NOT NULL,
  `previousState` ENUM('read', 'write', 'delete', 'admin') NULL DEFAULT NULL,
  `newState` ENUM('read', 'write', 'delete', 'admin') NULL DEFAULT NULL,
  `operation` ENUM('create', 'update', 'delete') NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Users_Features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Users_Features` (
  `idUser` INT NOT NULL,
  `idFeature` INT NOT NULL,
  `permission` ENUM('read', 'write', 'delete', 'admin') NOT NULL DEFAULT 'read',
  PRIMARY KEY (`idUser`, `idFeature`),
  INDEX `fk_Feature_User_idx` (`idFeature` ASC) VISIBLE,
  CONSTRAINT `fk_Feature_User`
    FOREIGN KEY (`idFeature`)
    REFERENCES `Authorization`.`Features` (`idFeatures`),
  CONSTRAINT `fk_User_Feature`
    FOREIGN KEY (`idUser`)
    REFERENCES `Authorization`.`Users` (`idUser`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Users_Features_LOG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Users_Features_LOG` (
  `logTimeStamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idUser` INT NULL DEFAULT NULL,
  `idFeature` INT NULL DEFAULT NULL,
  `previousState` ENUM('read', 'write', 'delete', 'admin') NULL DEFAULT NULL,
  `newState` ENUM('read', 'write', 'delete', 'admin') NULL DEFAULT NULL,
  `operation` ENUM('create', 'update', 'delete') NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Authorization`.`Users_Roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`Users_Roles` (
  `idUser` INT NOT NULL,
  `idRole` INT NOT NULL,
  PRIMARY KEY (`idUser`, `idRole`),
  INDEX `fk_Roles_Users_idx` (`idRole` ASC) VISIBLE,
  CONSTRAINT `fk_Roles_Users`
    FOREIGN KEY (`idRole`)
    REFERENCES `Authorization`.`Roles` (`idRole`),
  CONSTRAINT `fk_Users_Roles`
    FOREIGN KEY (`idUser`)
    REFERENCES `Authorization`.`Users` (`idUser`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `Authorization` ;

-- -----------------------------------------------------
-- Placeholder table for view `Authorization`.`User_Permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Authorization`.`User_Permissions` (`idUser` INT, `permission` INT, `from` INT);

-- -----------------------------------------------------
-- View `Authorization`.`User_Permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Authorization`.`User_Permissions`;
USE `Authorization`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `Authorization`.`User_Permissions` AS select `UF`.`idUser` AS `idUser`,`UF`.`permission` AS `permission`,'Personal' AS `from` from `Authorization`.`Users_Features` `UF` union select `UR`.`idUser` AS `idUser`,`RF`.`permission` AS `permission`,`R`.`name` AS `from` from ((`Authorization`.`Users_Roles` `UR` join `Authorization`.`Roles_Features` `RF` on((`UR`.`idRole` = `UR`.`idRole`))) join `Authorization`.`Roles` `R` on((`UR`.`idRole` = `R`.`idRole`)));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `Authorization`;

DELIMITER $$
USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Features_BEFORE_INSERT`
BEFORE INSERT ON `Authorization`.`Features`
FOR EACH ROW
BEGIN
	set NEW.createdAt = now();
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Features_BEFORE_UPDATE`
BEFORE UPDATE ON `Authorization`.`Features`
FOR EACH ROW
BEGIN
	set NEW.updatedAt = now();
    if OLD.deleted = 0 and NEW.deleted = 1 then
		set New.deletedAt = now();
    end if;
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Users_BEFORE_INSERT`
BEFORE INSERT ON `Authorization`.`Users`
FOR EACH ROW
BEGIN
	set NEW.createdAt = now();
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Users_BEFORE_UPDATE`
BEFORE UPDATE ON `Authorization`.`Users`
FOR EACH ROW
BEGIN
	set NEW.updatedAt = now();
    if OLD.deleted = 0 and NEW.deleted = true then set NEW.deletedAt = now();
    end if;
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Entity_BEFORE_INSERT`
BEFORE INSERT ON `Authorization`.`Entities`
FOR EACH ROW
BEGIN
	set NEW.createdAt = now();
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Entity_BEFORE_UPDATE`
BEFORE UPDATE ON `Authorization`.`Entities`
FOR EACH ROW
BEGIN
	set NEW.updatedAt = now();
    if NEW.deleted = 1 and OLD.deleted = 0 then
    set NEW.deletedAt = now();
    end if;
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Roles_BEFORE_INSERT`
BEFORE INSERT ON `Authorization`.`Roles`
FOR EACH ROW
BEGIN
	set NEW.createdAt = now();
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Roles_BEFORE_UPDATE`
BEFORE UPDATE ON `Authorization`.`Roles`
FOR EACH ROW
BEGIN
set NEW.updatedAt = now();
    if NEW.deleted = 1 and OLD.deleted = 0 then
    set NEW.deletedAt = now();
    end if;
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Roles_Features_AFTER_INSERT`
AFTER INSERT ON `Authorization`.`Roles_Features`
FOR EACH ROW
BEGIN
	insert into Roles_Features_LOG (idRole,idFeature,previousState,newState,operation) values (NEW.idRole,NEW.idFeature,NEW.permission,NEW.permission,'create');
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Roles_Features_AFTER_UPDATE`
AFTER UPDATE ON `Authorization`.`Roles_Features`
FOR EACH ROW
BEGIN
	insert into Roles_Features_LOG (idRole,idFeature,previousState,newState,operation) values (NEW.idRole,NEW.idFeature,OLD.permission,NEW.permission,'update');
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Users_Features_AFTER_DELETE`
AFTER DELETE ON `Authorization`.`Users_Features`
FOR EACH ROW
BEGIN
	insert into Users_Features_LOG (idUser,idFeature,previousState,newState,operation) values (OLD.idUser,OLD.idFeature,OLD.permission,OLD.permission,'delete');
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Users_Features_AFTER_INSERT`
AFTER INSERT ON `Authorization`.`Users_Features`
FOR EACH ROW
BEGIN
	insert into Users_Features_LOG (idUser,idFeature,previousState,newState,operation) values (NEW.idUser,NEW.idFeature,NEW.permission,NEW.permission,'create');
END$$

USE `Authorization`$$
CREATE
DEFINER=CURRENT_USER
TRIGGER `Authorization`.`Users_Features_AFTER_UPDATE`
AFTER UPDATE ON `Authorization`.`Users_Features`
FOR EACH ROW
BEGIN
	insert into Users_Features_LOG (idUser,idFeature,previousState,newState,operation) values (NEW.idUser,NEW.idFeature,OLD.permission,NEW.permission,'update');
END$$


DELIMITER ;
