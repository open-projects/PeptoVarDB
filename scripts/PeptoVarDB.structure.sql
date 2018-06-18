-- MySQL dump 10.13  Distrib 5.7.19, for Linux (x86_64)
--
-- Host: 192.168.1.2    Database: PeptoVar
-- ------------------------------------------------------
-- Server version	5.7.22-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `peptides`
--

DROP TABLE IF EXISTS `peptides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peptides` (
  `pept_id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `chrom` char(3) NOT NULL,
  `transcript_id` varchar(128) NOT NULL,
  `beg` decimal(12,1) NOT NULL,
  `end` decimal(12,1) NOT NULL,
  `upstream_fshifts` longtext,
  `variations` text,
  `peptide` varchar(14) NOT NULL,
  `length` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pept_id`),
  KEY `peptide` (`peptide`),
  KEY `transcript_id` (`transcript_id`),
  KEY `pos` (`beg`,`end`,`chrom`,`transcript_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `var2pept`
--

DROP TABLE IF EXISTS `var2pept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `var2pept` (
  `pept_id` bigint(11) unsigned NOT NULL,
  `chain` int(11) unsigned NOT NULL,
  `snp_id` varchar(128) NOT NULL,
  `type` char(3) NOT NULL,
  `nonsyn` int(1) NOT NULL,
  `location` char(3) NOT NULL,
  KEY `pept_id` (`pept_id`),
  KEY `snp_id` (`snp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `variations`
--

DROP TABLE IF EXISTS `variations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variations` (
  `var_id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `chrom` char(3) NOT NULL,
  `transcript_id` varchar(128) NOT NULL,
  `variation_id` varchar(128) NOT NULL,
  `beg` int(11) NOT NULL,
  `end` int(11) NOT NULL,
  `allele_id` varchar(128) NOT NULL,
  `synonymous` char(1) NOT NULL,
  `upstream_fshifts` longtext,
  `prefix_alleles` text,
  `prefix` varchar(8) NOT NULL,
  `allele` varchar(128) NOT NULL,
  `suffix` varchar(8) NOT NULL,
  `suffix_alleles` text,
  `translation` varchar(128) NOT NULL,
  PRIMARY KEY (`var_id`),
  KEY `variation_id` (`variation_id`),
  KEY `transcript_id` (`transcript_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-18 13:33:44
