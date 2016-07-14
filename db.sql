


CREATE DATABASE `meetupdb` ;
CREATE TABLE `meetupdb`.`accountinfo` (
`MemberID` INT( 5 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`Username` VARCHAR( 25 ) NOT NULL ,
`Email` VARCHAR( 35 ) NOT NULL ,
`Password` VARCHAR( 50 ) NOT NULL ,
`DeviceToken` VARCHAR( 64 ) NOT NULL ,
UNIQUE (`Email`)
) ENGINE = MYISAM ;
