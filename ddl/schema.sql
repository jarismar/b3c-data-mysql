-- MySQL Script generated by MySQL Workbench
-- Sun Jan 15 07:49:38 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema b3c
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema b3c
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `b3c` DEFAULT CHARACTER SET utf8 ;
USE `b3c` ;

-- -----------------------------------------------------
-- Table `b3c`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`user` (
  `usr_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `usr_uuid` CHAR(36) NOT NULL,
  `usr_ext_uuid` VARCHAR(36) NOT NULL,
  `usr_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`usr_id`),
  UNIQUE INDEX `UI_USR_UUID` (`usr_uuid` ASC) VISIBLE,
  UNIQUE INDEX `UI_USR_NAME` (`usr_name` ASC) VISIBLE,
  UNIQUE INDEX `UI_USR_EXT_UUID` (`usr_ext_uuid` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`tax_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`tax_group` (
  `tgr_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tgr_source` CHAR(3) NOT NULL,
  `tgr_external_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`tgr_id`),
  INDEX `IX_TGR_EXT_ID` (`tgr_external_id` ASC, `tgr_source` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`broker_invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`broker_invoice` (
  `biv_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `usr_id` INT UNSIGNED NOT NULL,
  `tgr_id` INT UNSIGNED NOT NULL,
  `biv_filename` VARCHAR(30) NOT NULL,
  `biv_number` INT UNSIGNED NOT NULL,
  `biv_market_date` DATE NOT NULL,
  `biv_billing_date` DATE NOT NULL,
  `biv_raw_value` DECIMAL(10,2) NOT NULL,
  `biv_net_value` DECIMAL(10,2) NOT NULL,
  `biv_total_sold` DECIMAL(10,2) NOT NULL,
  `bit_total_acquired` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`biv_id`),
  INDEX `IXFK_BIV_USR` (`usr_id` ASC) VISIBLE,
  INDEX `IX_BIV_BANK_DATE` (`biv_billing_date` ASC) VISIBLE,
  INDEX `IX_BIV_MARKET_DATE` (`biv_market_date` ASC) VISIBLE,
  UNIQUE INDEX `IU_BIV_FILENAME` (`biv_filename` ASC) VISIBLE,
  INDEX `IXFK_BIV_TGR` (`tgr_id` ASC) VISIBLE,
  CONSTRAINT `FK_BIV_USR1`
    FOREIGN KEY (`usr_id`)
    REFERENCES `b3c`.`user` (`usr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_BIV_TGR`
    FOREIGN KEY (`tgr_id`)
    REFERENCES `b3c`.`tax_group` (`tgr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`company` (
  `cmp_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cmp_code` VARCHAR(10) NOT NULL,
  `cmp_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`cmp_id`),
  UNIQUE INDEX `IU_CMP_CODE` (`cmp_code` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`broker_invoice_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`broker_invoice_item` (
  `bii_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cmp_id` INT UNSIGNED NOT NULL,
  `biv_id` INT UNSIGNED NOT NULL,
  `biv_market_date` DATE NOT NULL,
  `bii_order` INT UNSIGNED NOT NULL,
  `bii_qty` INT UNSIGNED NOT NULL,
  `bii_price` DECIMAL(10,2) UNSIGNED NOT NULL,
  `bii_debit` BIT(1) NOT NULL,
  PRIMARY KEY (`bii_id`),
  INDEX `IXFK_BII_CMP` (`cmp_id` ASC) VISIBLE,
  INDEX `IXFK_BII_BIV` (`biv_id` ASC) VISIBLE,
  INDEX `IX_BII_CMP_BIV` (`biv_id` ASC, `cmp_id` ASC) VISIBLE,
  UNIQUE INDEX `UI_BII_CMP_ORD` (`biv_id` ASC, `cmp_id` ASC, `bii_order` ASC) VISIBLE,
  CONSTRAINT `FK_BII_CMP`
    FOREIGN KEY (`cmp_id`)
    REFERENCES `b3c`.`company` (`cmp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_BII_BIV`
    FOREIGN KEY (`biv_id`)
    REFERENCES `b3c`.`broker_invoice` (`biv_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`tax`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`tax` (
  `tax_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tax_code` VARCHAR(10) NOT NULL,
  `tax_source` VARCHAR(10) NOT NULL,
  `tax_rate` DOUBLE NULL,
  PRIMARY KEY (`tax_id`),
  UNIQUE INDEX `IU_TAX_CODE` (`tax_code` ASC) VISIBLE,
  INDEX `IX_TAX_SOURCE` (`tax_source` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`earning`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`earning` (
  `ear_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ear_uuid` CHAR(36) NOT NULL,
  `cmp_id` INT UNSIGNED NOT NULL,
  `usr_id` INT UNSIGNED NOT NULL,
  `tgr_id` INT UNSIGNED NOT NULL,
  `ear_type` CHAR(3) NOT NULL,
  `ear_pay_date` DATE NOT NULL,
  `ear_raw_value` DECIMAL(10,2) NOT NULL,
  `ear_net_value` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`ear_id`),
  INDEX `IXFK_EAR_CMP` (`cmp_id` ASC) VISIBLE,
  INDEX `IXFK_EAR_USR` (`usr_id` ASC) VISIBLE,
  INDEX `IX_EAR_PAYDATE` (`ear_pay_date` ASC) VISIBLE,
  UNIQUE INDEX `UI_EAR_UUID` (`ear_uuid` ASC) VISIBLE,
  INDEX `IXFK_EAR_TGR` (`tgr_id` ASC) VISIBLE,
  CONSTRAINT `FK_EAR_CMP`
    FOREIGN KEY (`cmp_id`)
    REFERENCES `b3c`.`company` (`cmp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_EAR_USR`
    FOREIGN KEY (`usr_id`)
    REFERENCES `b3c`.`user` (`usr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_EAR_TGR`
    FOREIGN KEY (`tgr_id`)
    REFERENCES `b3c`.`tax_group` (`tgr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`company_batch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`company_batch` (
  `cbt_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cmp_id` INT UNSIGNED NOT NULL,
  `usr_id` INT UNSIGNED NOT NULL,
  `cbt_start_date` DATE NOT NULL,
  `cbt_qty` INT UNSIGNED NOT NULL,
  `cbt_avg_price` DOUBLE UNSIGNED NOT NULL,
  `cbt_total_price` DOUBLE UNSIGNED NOT NULL,
  PRIMARY KEY (`cbt_id`),
  INDEX `IXFK_CBT_CMP` (`cmp_id` ASC) VISIBLE,
  INDEX `IXFK_CBT_USR` (`usr_id` ASC) VISIBLE,
  CONSTRAINT `FK_CBT_CMP`
    FOREIGN KEY (`cmp_id`)
    REFERENCES `b3c`.`company` (`cmp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_CBT_USR`
    FOREIGN KEY (`usr_id`)
    REFERENCES `b3c`.`user` (`usr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`item_batch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`item_batch` (
  `itb_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cbt_id` INT UNSIGNED NOT NULL,
  `bii_id` INT UNSIGNED NOT NULL,
  `tgr_id` INT UNSIGNED NOT NULL,
  `itb_qty` INT UNSIGNED NOT NULL,
  `itb_avg_price` DOUBLE UNSIGNED NOT NULL,
  `itb_raw_price` DECIMAL(10,2) UNSIGNED NOT NULL,
  `itb_total_tax` DOUBLE UNSIGNED NOT NULL,
  PRIMARY KEY (`itb_id`),
  INDEX `IXFK_ITB_CBT` (`cbt_id` ASC) VISIBLE,
  INDEX `IXFK_ITB_TGR` (`tgr_id` ASC) VISIBLE,
  INDEX `IXFK_ITB_BII` (`bii_id` ASC) VISIBLE,
  CONSTRAINT `FK_ITB_CBT`
    FOREIGN KEY (`cbt_id`)
    REFERENCES `b3c`.`company_batch` (`cbt_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ITB_TGR`
    FOREIGN KEY (`tgr_id`)
    REFERENCES `b3c`.`tax_group` (`tgr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ITB_BII`
    FOREIGN KEY (`bii_id`)
    REFERENCES `b3c`.`broker_invoice_item` (`bii_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`trade_batch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`trade_batch` (
  `trb_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tgr_id` INT UNSIGNED NOT NULL,
  `usr_id` INT UNSIGNED NOT NULL,
  `trb_start_date` DATE NOT NULL,
  `trb_acc_loss` DOUBLE NOT NULL,
  `trb_current_results` DOUBLE NOT NULL,
  `trb_total_trade` DECIMAL(10,2) NOT NULL,
  `trb_total_tax` DOUBLE NOT NULL,
  PRIMARY KEY (`trb_id`),
  INDEX `IXFK_TRB_TGR` (`tgr_id` ASC) VISIBLE,
  INDEX `IXFK_TRB_USR` (`usr_id` ASC) INVISIBLE,
  UNIQUE INDEX `UX_USR_DATE` (`usr_id` ASC, `trb_start_date` ASC) VISIBLE,
  CONSTRAINT `FK_TRB_TGR`
    FOREIGN KEY (`tgr_id`)
    REFERENCES `b3c`.`tax_group` (`tgr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TRB_USR`
    FOREIGN KEY (`usr_id`)
    REFERENCES `b3c`.`user` (`usr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`trade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`trade` (
  `trd_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cbt_id` INT UNSIGNED NOT NULL,
  `trb_id` INT UNSIGNED NOT NULL,
  `bii_id` INT UNSIGNED NOT NULL,
  `tgr_id` INT UNSIGNED NOT NULL,
  `biv_market_date` DATE NOT NULL,
  `trd_qty` INT UNSIGNED NOT NULL,
  `cbt_avg_price` DOUBLE UNSIGNED NOT NULL,
  `trd_avg_price` DOUBLE UNSIGNED NOT NULL,
  `trd_raw_results` DOUBLE NOT NULL,
  `trd_raw_price` DECIMAL(10,2) UNSIGNED NOT NULL,
  `trd_total_tax` DOUBLE UNSIGNED NOT NULL,
  PRIMARY KEY (`trd_id`),
  INDEX `IXFK_TRD_CBT` (`cbt_id` ASC) VISIBLE,
  INDEX `IXFK_TRD_TRB` (`trb_id` ASC) VISIBLE,
  INDEX `IXFK_TRD_BII` (`bii_id` ASC) VISIBLE,
  INDEX `IXFK_TRD_TGR` (`tgr_id` ASC) VISIBLE,
  CONSTRAINT `FK_TRD_CBT`
    FOREIGN KEY (`cbt_id`)
    REFERENCES `b3c`.`company_batch` (`cbt_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TRD_TRB`
    FOREIGN KEY (`trb_id`)
    REFERENCES `b3c`.`trade_batch` (`trb_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TRD_BII`
    FOREIGN KEY (`bii_id`)
    REFERENCES `b3c`.`broker_invoice_item` (`bii_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TRD_TGR`
    FOREIGN KEY (`tgr_id`)
    REFERENCES `b3c`.`tax_group` (`tgr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `b3c`.`tax_instance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `b3c`.`tax_instance` (
  `tin_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tgr_id` INT UNSIGNED NOT NULL,
  `tax_id` INT UNSIGNED NOT NULL,
  `tin_market_date` DATE NOT NULL,
  `tin_tax_value` DOUBLE NOT NULL,
  `tin_base_value` DOUBLE NULL,
  `tin_tax_rate` DOUBLE NULL,
  PRIMARY KEY (`tin_id`),
  INDEX `IXFK_TIN_TGR` (`tgr_id` ASC) VISIBLE,
  INDEX `IXFK_TIN_TAX` (`tax_id` ASC) INVISIBLE,
  UNIQUE INDEX `IU_TGR_TAX` (`tgr_id` ASC, `tax_id` ASC) VISIBLE,
  CONSTRAINT `FK_TIN_TGR`
    FOREIGN KEY (`tgr_id`)
    REFERENCES `b3c`.`tax_group` (`tgr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TIN_TAX`
    FOREIGN KEY (`tax_id`)
    REFERENCES `b3c`.`tax` (`tax_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
