-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.41-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema t_30
--

CREATE DATABASE IF NOT EXISTS t_30;
USE t_30;

--
-- Definition of table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `p_id` int(10) unsigned NOT NULL auto_increment,
  `pname` varchar(45) NOT NULL,
  `qty` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`p_id`,`pname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` (`p_id`,`pname`,`qty`) VALUES 
 (1,'A',2);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;


--
-- Definition of table `purchase`
--

DROP TABLE IF EXISTS `purchase`;
CREATE TABLE `purchase` (
  `pur_id` int(10) unsigned NOT NULL auto_increment,
  `p_id` int(10) unsigned NOT NULL,
  `price` double NOT NULL,
  `pdate` date NOT NULL,
  `qty` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`pur_id`),
  KEY `FK_purchase_pid` (`p_id`),
  CONSTRAINT `FK_purchase_pid` FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `purchase`
--

/*!40000 ALTER TABLE `purchase` DISABLE KEYS */;
INSERT INTO `purchase` (`pur_id`,`p_id`,`price`,`pdate`,`qty`) VALUES 
 (1,1,126,'2017-01-01',1),
 (2,1,200,'2017-01-02',2);
/*!40000 ALTER TABLE `purchase` ENABLE KEYS */;


--
-- Definition of trigger `before_purchase`
--

DROP TRIGGER /*!50030 IF EXISTS */ `before_purchase`;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER `before_purchase` BEFORE INSERT ON `purchase` FOR EACH ROW BEGIN
update product
set qty = qty+NEW.qty
where p_id=NEW.p_id;
END $$

DELIMITER ;

--
-- Definition of table `sale`
--

DROP TABLE IF EXISTS `sale`;
CREATE TABLE `sale` (
  `s_id` int(10) unsigned NOT NULL auto_increment,
  `p_id` int(10) unsigned NOT NULL,
  `price` double NOT NULL,
  `sdate` date NOT NULL,
  `qty` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`s_id`),
  KEY `FK_sale_pid` (`p_id`),
  CONSTRAINT `FK_sale_pid` FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sale`
--

/*!40000 ALTER TABLE `sale` DISABLE KEYS */;
INSERT INTO `sale` (`s_id`,`p_id`,`price`,`sdate`,`qty`) VALUES 
 (1,1,300,'2017-01-07',1);
/*!40000 ALTER TABLE `sale` ENABLE KEYS */;


--
-- Definition of trigger `before_sale`
--

DROP TRIGGER /*!50030 IF EXISTS */ `before_sale`;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER `before_sale` BEFORE INSERT ON `sale` FOR EACH ROW BEGIN
update product
set qty = qty-NEW.qty
where p_id=NEW.p_id;
END $$

DELIMITER ;
--
-- Create schema userlog
--

CREATE DATABASE IF NOT EXISTS userlog;
USE userlog;

--
-- Definition of table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `u_id` int(10) unsigned NOT NULL auto_increment,
  `userName` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY  (`u_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`u_id`,`userName`,`password`) VALUES 
 (1,'Bari','123'),
 (2,'Nazrul','234'),
 (3,'Nayem','346');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

--
-- Create schema t_30
--

CREATE DATABASE IF NOT EXISTS t_30;
USE t_30;

--
-- Definition of function `getProductid`
--

DROP FUNCTION IF EXISTS `getProductid`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getProductid`(product_name VARCHAR(50)) RETURNS int(11)
BEGIN
return (select p_id from product where pname=product_name);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `getProductQty`
--

DROP FUNCTION IF EXISTS `getProductQty`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getProductQty`(product_name VARCHAR(50)) RETURNS int(11)
BEGIN
return(select qty from product where pname=product_name);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `avg_price`
--

DROP PROCEDURE IF EXISTS `avg_price`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `avg_price`(productid INT)
BEGIN
select TRUNCATE((sum(price*qty)/sum(qty)),2) avgprice from purchase
where p_id=productid;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `listProduct`
--

DROP PROCEDURE IF EXISTS `listProduct`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listProduct`()
BEGIN
select pname from product;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `saveProduct`
--

DROP PROCEDURE IF EXISTS `saveProduct`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveProduct`(productname VARCHAR(45))
BEGIN
insert into product(pname)
values(productname);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `savePurchase`
--

DROP PROCEDURE IF EXISTS `savePurchase`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `savePurchase`(IN id INT,IN price DOUBLE,IN dt DATE,IN qt INT)
BEGIN
insert into purchase(p_id,price,pdate,qty)
values(id,price,dt,qt);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `saveSale`
--

DROP PROCEDURE IF EXISTS `saveSale`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveSale`(IN id INT,IN price DOUBLE,IN dt DATE,IN qt INT)
BEGIN
insert into sale(p_id,price,sdate,qty)
values(id,price,dt,qt);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
