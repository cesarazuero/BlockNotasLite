SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`archivo`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`archivo` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(100) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `nombre` (`nombre` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`hojas`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`hojas` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `id_archivo` INT NOT NULL ,
  `nombre` VARCHAR(100) NULL ,
  PRIMARY KEY (`id`, `id_archivo`) ,
  INDEX `fk_hojas_archivo_idx` (`id_archivo` ASC) ,
  CONSTRAINT `fk_hojas_archivo`
    FOREIGN KEY (`id_archivo` )
    REFERENCES `mydb`.`archivo` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`elementos`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`elementos` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `id_hojas` INT NOT NULL ,
  `tipo` VARCHAR(45) NOT NULL ,
  `posx` DECIMAL(10,0) NOT NULL ,
  `posy` DECIMAL(10,0) NOT NULL ,
  `rotation` DECIMAL(10,0) NOT NULL ,
  `scaleX` DECIMAL(10,0) NOT NULL ,
  `scaleY` DECIMAL(10,0) NOT NULL ,
  `data` TEXT NULL ,
  `imagen` BLOB NULL DEFAULT NULL ,
  PRIMARY KEY (`id`, `id_hojas`) ,
  INDEX `fk_elementos_hojas1_idx` (`id_hojas` ASC) ,
  CONSTRAINT `fk_elementos_hojas1`
    FOREIGN KEY (`id_hojas` )
    REFERENCES `mydb`.`hojas` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
