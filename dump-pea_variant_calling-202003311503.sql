-- MySQL dump 10.13  Distrib 8.0.19, for Linux (x86_64)
--
-- Host: localhost    Database: pea_variant_calling
-- ------------------------------------------------------
-- Server version	8.0.19-0ubuntu0.19.10.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `contigs`
--

DROP TABLE IF EXISTS `contigs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contigs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `genome_id` int NOT NULL,
  `length` bigint NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contigs_FK` (`genome_id`),
  CONSTRAINT `contigs_FK` FOREIGN KEY (`genome_id`) REFERENCES `genome` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contigs`
--

LOCK TABLES `contigs` WRITE;
/*!40000 ALTER TABLE `contigs` DISABLE KEYS */;
/*!40000 ALTER TABLE `contigs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genome`
--

DROP TABLE IF EXISTS `genome`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genome` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genome`
--

LOCK TABLES `genome` WRITE;
/*!40000 ALTER TABLE `genome` DISABLE KEYS */;
/*!40000 ALTER TABLE `genome` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variant_subtype`
--

DROP TABLE IF EXISTS `variant_subtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variant_subtype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='subtypes dict';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_subtype`
--

LOCK TABLES `variant_subtype` WRITE;
/*!40000 ALTER TABLE `variant_subtype` DISABLE KEYS */;
/*!40000 ALTER TABLE `variant_subtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variant_type`
--

DROP TABLE IF EXISTS `variant_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variant_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_type`
--

LOCK TABLES `variant_type` WRITE;
/*!40000 ALTER TABLE `variant_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `variant_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variants_table_doublelinked`
--

DROP TABLE IF EXISTS `variants_table_doublelinked`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variants_table_doublelinked` (
  `internal_variant_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'synthetic key',
  `run_id` int NOT NULL COMMENT 'foreign key to vcaller run',
  `contig_id` int NOT NULL COMMENT 'foreign key to contig (chr)',
  `alleles` json DEFAULT NULL COMMENT 'alleles list',
  `pos` bigint NOT NULL COMMENT 'position',
  `alt` varchar(100) DEFAULT NULL COMMENT 'main alt allele',
  `ref` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'seq in reference',
  `alt_alleles_list` json DEFAULT NULL COMMENT 'for multiallelic loci',
  `qual` decimal(5,5) DEFAULT NULL COMMENT 'quality',
  `var_type_id` int DEFAULT NULL,
  `var_subtype_id` int DEFAULT NULL,
  `start` bigint DEFAULT NULL,
  `end` bigint DEFAULT NULL,
  `affected_start` bigint DEFAULT NULL,
  `affected_end` bigint DEFAULT NULL,
  `af` float DEFAULT NULL COMMENT 'allele frequency',
  `ac` int DEFAULT NULL COMMENT 'allele count',
  `mapq` decimal(5,5) DEFAULT NULL COMMENT 'mapping quality',
  `dp` int DEFAULT NULL COMMENT 'gatk coverage depth',
  `info_dict` json DEFAULT NULL COMMENT 'whole INFO record as json',
  `samples_dict` json DEFAULT NULL COMMENT 'samples dict as json',
  PRIMARY KEY (`internal_variant_id`),
  KEY `variants_table_doublelinked_FK` (`run_id`),
  KEY `variants_table_doublelinked_FK_1` (`contig_id`),
  KEY `variants_table_doublelinked_FK_2` (`var_type_id`),
  KEY `variants_table_doublelinked_FK_3` (`var_subtype_id`),
  CONSTRAINT `variants_table_doublelinked_FK` FOREIGN KEY (`run_id`) REFERENCES `vcaller_run` (`id`),
  CONSTRAINT `variants_table_doublelinked_FK_1` FOREIGN KEY (`contig_id`) REFERENCES `contigs` (`id`),
  CONSTRAINT `variants_table_doublelinked_FK_2` FOREIGN KEY (`var_type_id`) REFERENCES `variant_type` (`id`),
  CONSTRAINT `variants_table_doublelinked_FK_3` FOREIGN KEY (`var_subtype_id`) REFERENCES `variant_subtype` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variants_table_doublelinked`
--

LOCK TABLES `variants_table_doublelinked` WRITE;
/*!40000 ALTER TABLE `variants_table_doublelinked` DISABLE KEYS */;
/*!40000 ALTER TABLE `variants_table_doublelinked` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vcaller_run`
--

DROP TABLE IF EXISTS `vcaller_run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vcaller_run` (
  `id` int NOT NULL AUTO_INCREMENT,
  `run_date` datetime DEFAULT NULL,
  `ref_genome_id` int NOT NULL,
  `phenotype` varchar(100) DEFAULT NULL,
  `format` varchar(100) DEFAULT NULL COMMENT 'format field description',
  `filter` json DEFAULT NULL COMMENT 'filter field as json',
  PRIMARY KEY (`id`),
  KEY `vcaller_run_FK` (`ref_genome_id`),
  CONSTRAINT `vcaller_run_FK` FOREIGN KEY (`ref_genome_id`) REFERENCES `genome` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vcaller_run`
--

LOCK TABLES `vcaller_run` WRITE;
/*!40000 ALTER TABLE `vcaller_run` DISABLE KEYS */;
/*!40000 ALTER TABLE `vcaller_run` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'pea_variant_calling'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-31 15:03:46
