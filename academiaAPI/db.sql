CREATE DATABASE  IF NOT EXISTS `academia` DEFAULT CHARACTER SET utf8 ;
USE `academia`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: academia
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aluno`
--

DROP TABLE IF EXISTS `aluno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aluno` (
  `matricula` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `identidade` char(9) NOT NULL,
  `cpf` char(11) NOT NULL,
  `endereco` int(11) NOT NULL,
  `plano_atual` varchar(6) NOT NULL,
  PRIMARY KEY (`matricula`),
  UNIQUE KEY `identidade` (`identidade`),
  UNIQUE KEY `cpf` (`cpf`),
  KEY `endereco` (`endereco`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aluno`
--

LOCK TABLES `aluno` WRITE;
/*!40000 ALTER TABLE `aluno` DISABLE KEYS */;
INSERT INTO `aluno` VALUES (1,'Guilherme Assis de Andrade','272089121','96981495487',5,'Mensal'),(2,'Alice da Silva Gomes','220204022','54128854410',28,'Anual'),(3,'Nicolas Ramos Carneiro','462587199','41652646386',13,'Mensal'),(4,'Miguel Pinto de Souza Melo','572970903','71224369861',3,'Anual'),(5,'Maria Eduarda Pessanha Nabit','484045406','77392139268',17,'Mensal'),(6,'Giovana Pereira Leite','813122995','16179420644',29,'Anual'),(7,'Sofia Carneiro da Silva','137768214','89689320182',20,'Mensal'),(8,'Rafael de Oliveira Neto','952405497','23989076243',11,'Anual'),(9,'Arthur Rodrigues de Souza','527341463','11224358346',2,'Mensal'),(10,'Samuel Maia da Silva Junior','713867669','55971793703',22,'Anual'),(11,'Helena Martins Junqueira','369888190','46408253440',18,'Mensal'),(12,'Bernardo Franciscano','162123836','22895212005',4,'Anual'),(13,'Lara Correa Costa','713748653','26380023348',9,'Mensal'),(14,'Valentina Fernandes Alves','354897779','27098765545',26,'Anual'),(15,'Heitor Salvador Filete','336684280','19355466158',27,'Mensal'),(16,'Gustavo Santos Otero','159769136','35882829894',25,'Anual'),(17,'Murilo Cardoso Teixeira','699430950','48003580119',1,'Mensal'),(18,'Laura Andrade Lima','297673722','10860981049',14,'Anual'),(19,'Davi Tavares Lopes','769506668','76327996919',16,'Mensal'),(20,'Mariana Ferreira de Lima','626412157','62917818410',12,'Anual'),(21,'Isabella Rosa Benvenutti','650956574','69040153831',30,'Mensal'),(22,'Benício Dias Oliveira','794291442','78321548971',23,'Anual'),(23,'João Pedro Machado Abreu','175158153','51924126337',7,'Mensal'),(24,'Pedro Tinoco','939212652','39983869301',6,'Anual'),(25,'Maria Clara Pinheiro Vieira','658352140','35188250251',15,'Anual'),(26,'Julia Gomes Menezes','956727176','63125341315',24,'Anual'),(27,'Gabriel Brito Mattos','834606662','40776906304',19,'Mensal'),(28,'Matheus Macedo Novaes','186200050','16687988590',10,'Mensal'),(29,'Henrique Vieira Almeida','466855819','10072307780',8,'Mensal'),(30,'Maria Luiza Rocha Monteiro','791583737','12879955931',21,'Anual');
/*!40000 ALTER TABLE `aluno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aula`
--

DROP TABLE IF EXISTS `aula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aula` (
  `id_aula` int(11) NOT NULL AUTO_INCREMENT,
  `nome_aula` varchar(30) NOT NULL,
  `horario_inicio` time NOT NULL,
  `horario_fim` time NOT NULL,
  `dia_semana` set('Dom','Seg','Ter','Qua','Qui','Sex','Sab') NOT NULL,
  `sala` char(4) NOT NULL,
  `instrutor` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_aula`),
  KEY `instrutor` (`instrutor`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aula`
--

LOCK TABLES `aula` WRITE;
/*!40000 ALTER TABLE `aula` DISABLE KEYS */;
INSERT INTO `aula` VALUES (1,'Spinning','09:30:00','10:30:00','Seg,Ter,Qua,Qui,Sex','S101',19),(2,'Yoga','18:05:00','19:05:00','Seg,Ter,Qua,Qui','Y102',5),(3,'Kung Fu','19:00:00','20:30:00','Ter,Qui','L303',8),(4,'Ballet','10:00:00','11:00:00','Seg,Qua','D304',30),(5,'Dança do Ventre','20:00:00','21:00:00','Ter,Qui','D304',20),(6,'Muay Thai','19:00:00','20:00:00','Seg,Qua','L303',7),(7,'Pilates','14:10:00','16:10:00','Seg,Ter,Qua,Qui,Sex','Y102',5),(8,'Spinning','16:30:00','17:30:00','Seg,Ter,Qua,Qui,Sex','S101',19),(9,'Coaching Quantico','18:30:00','19:00:00','Seg,Ter','Audi',17),(10,'Jiu Jitsu','20:00:00','21:00:00','Ter,Qui','L303',1),(11,'Coaching','18:30:00','19:00:00','Qua,Qui','Audi',28),(12,'Jiu Jitsu','20:00:00','21:00:00','Seg,Qua','L303',1),(13,'Futebol','15:00:00','16:30:00','Ter,Qui','Quad',9),(14,'Zumba','21:00:00','22:30:00','Seg,Ter,Qua,Qui,Sex','D304',3),(15,'Volei','15:00:00','16:30:00','Seg,Qua','Quad',27),(16,'MMA','21:00:00','23:00:00','Seg,Qua,Sex','L303',21),(17,'Natação','15:00:00','19:00:00','Seg,Ter,Qua,Qui,Sex','Padu',26),(18,'Karatê','20:30:00','21:30:00','Ter,Sex','L303',11),(19,'Natação Infantil','07:00:00','11:00:00','Seg,Ter,Qua,Qui,Sex','Pinf',NULL),(20,'Crossfit','18:30:00','20:30:00','Qua,Sex','C505',15);
/*!40000 ALTER TABLE `aula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avaliacao`
--

DROP TABLE IF EXISTS `avaliacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avaliacao` (
  `id_avaliacao` int(11) NOT NULL AUTO_INCREMENT,
  `anamnese` text NOT NULL,
  `ex_dobras_cutaneas` text NOT NULL,
  `ex_ergonometrico` text NOT NULL,
  `data_avaliacao` date NOT NULL,
  `aluno` int(11) NOT NULL,
  PRIMARY KEY (`id_avaliacao`),
  KEY `aluno` (`aluno`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avaliacao`
--

LOCK TABLES `avaliacao` WRITE;
/*!40000 ALTER TABLE `avaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `avaliacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `endereco`
--

DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `endereco` (
  `id_endereco` int(11) NOT NULL AUTO_INCREMENT,
  `rua` varchar(50) NOT NULL,
  `numero` varchar(8) NOT NULL,
  `complemento` varchar(30) DEFAULT NULL,
  `cidade` varchar(30) NOT NULL,
  `estado` char(2) NOT NULL,
  `cep` char(8) NOT NULL,
  PRIMARY KEY (`id_endereco`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco`
--

LOCK TABLES `endereco` WRITE;
/*!40000 ALTER TABLE `endereco` DISABLE KEYS */;
INSERT INTO `endereco` VALUES (1,'Rua Macário dos Réis','5002','Apt624','Itabuna','BA','90098573'),(2,'Rua Rio Verde','2138','Casa803','Brasília','DF','66899417'),(3,'Rua Manoel Ribas','124','','Cascavel','PR','22614695'),(4,'Av. Elias João Tajra','2263','Apt785','Teresina','PI','94393754'),(5,'Rua Barbosa Lima','9922','Casa667','Lavras','MG','67207185'),(6,'Rua Francisco Portugal','4868','Apt855','Aracaju','SE','60155051'),(7,'Rua Hamilton de Barros Soutinho','8799','','Maceió','AL','72881617'),(8,'Rua Cel. Diogo Gomes','6375','Apt557','Sobral','CE','89556258'),(9,'Rua Santos Dumont','9116','Apt344','Blumenau','SC','66519641'),(10,'Rua Salgado Filho','6496','Casa566','Porto Velho','RO','90968065'),(11,'Av. Brasil','655','Casa819','Grajaú','MA','16364795'),(12,'Rua Iguaçu','6915','Apt522','Porto Nacional','TO','48046684'),(13,'Rua Castro Alves','4445','','Parnamirim','RN','66055529'),(14,'Rua Manoel Teixeira de Souza','1861','Casa581','Boa Vista','RR','48859521'),(15,'Rua Três Corações','4665','Apt801','Itaquaquecetuba','SP','99920338'),(16,'Rua DRua Jorge Lobato','8454','','Ribeirão Preto','SP','74952412'),(17,'Rua Bacharel Armando de Carvalho Jordão','282','Casa106','Angra dos Reis','RJ','99046350'),(18,'Rua Mendes de Sá','8316','Apt508','Tiranossauro Rex City','AC','20614129'),(19,'Rua Eduardo Kaempf','1804','Apt880','Santa Cruz do Sul','RS','52569402'),(20,'Rua Virgílio Cardoso','1668','Casa210','São Gabriel da Cachoeira','AM','92210042'),(21,'Rua Afonso Pena','5711','','Joinville','SC','56239674'),(22,'Rua Maria Ramos','8273','Apt149','Olinda','PE','13384538'),(23,'Av. Dom Osório','5722','Casa581','Rondonópolis','MT','23933997'),(24,'Rua Aristides Lobo','1051','Apt517','Calypso City','PA','24531773'),(25,'Av. Conselheiro Július Arp','2920','','Nova Friburgo','RJ','59058572'),(26,'Rua Israel Pinheiro','2160','Casa163','Governador Valadares','MG','78708374'),(27,'Rua Ana Firmino da Costa','9173','Apt324','Campina Grande','PB','36414431'),(28,'Rua Nogueira','7982','Apt114','Ponta Porã','MS','53202497'),(29,'Rua Afonso Pena','6612','','Vila Velha','ES','94432942'),(30,'Av. Divino Pai Eterno','9041','Casa683','Anápolis','GO','46631317');
/*!40000 ALTER TABLE `endereco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ferias`
--

DROP TABLE IF EXISTS `ferias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ferias` (
  `aluno` int(11) NOT NULL,
  `data_inicio` date NOT NULL,
  `n_dias` tinyint(4) NOT NULL DEFAULT '0',
  `n_periodos` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`aluno`,`data_inicio`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ferias`
--

LOCK TABLES `ferias` WRITE;
/*!40000 ALTER TABLE `ferias` DISABLE KEYS */;
/*!40000 ALTER TABLE `ferias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instrutor`
--

DROP TABLE IF EXISTS `instrutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instrutor` (
  `id_instrutor` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `identidade` char(9) NOT NULL,
  `cpf` char(11) NOT NULL,
  `atividade` varchar(15) NOT NULL,
  PRIMARY KEY (`id_instrutor`),
  UNIQUE KEY `identidade` (`identidade`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instrutor`
--

LOCK TABLES `instrutor` WRITE;
/*!40000 ALTER TABLE `instrutor` DISABLE KEYS */;
INSERT INTO `instrutor` VALUES (1,'Royce da Familia Gracie','682487591','55881205079','Aulas em Grupo'),(2,'Arnold Monstro Schwarzenegger','933638723','10139790840','Musculação'),(3,'Hebe Maria Monteiro de Camargo Ravagnani','305089659','85510539278','Aulas em Grupo'),(4,'Dwayne The Rock Johnson','341703868','16066543845','Musculação'),(5,'Mohandas Karamchand Gandhi','182345646','40637853576','Aulas em Grupo'),(6,'Jean Claude Van Damme','727355131','95116498323','Musculação'),(7,'Anderson Spider da Silva','203423296','33254964344','Aulas em Grupo'),(8,'Charles David Chuck Liddell','184193647','54623495174','Aulas em Grupo'),(9,'Ronaldo Luís Nazário de Lima','127063383','34868621972','Aulas em Grupo'),(10,'Jason Expendable Statham','769617962','62461773199','Musculação'),(11,'Lyoto Carvalho Machida','618223903','25108399607','Aulas em Grupo'),(12,'Terry Alan Crews','643061949','78969336816','Musculação'),(13,'César Augusto Cielo Filho','930413224','95353115234','Aulas em Grupo'),(14,'Walter Bruce Willis','713633874','30572413922','Musculação'),(15,'Tyrese Darnell Gibson','485010729','60549914232','Aulas em Grupo'),(16,'Michael Sylvester Expandable Stallone','909740894','33004319772','Musculação'),(17,'Albert Fisico Quantico Einstein','689107862','70195151851','Aulas em Grupo'),(18,'Chuck Mito Norris','426020248','53690168730','Musculação'),(19,'Lance Edward Gunderson Armstrong','418899203','92545401747','Aulas em Grupo'),(20,'Gisele Caroline Bündchen Brady','897149645','56001949532','Aulas em Grupo'),(21,'Ronda Jean Rousey','903095768','77741899023','Aulas em Grupo'),(22,'Wesley Atirador Snipes','476414075','58100928728','Musculação'),(23,'Harrison Chevrolet Ford','420133607','80522737132','Musculação'),(24,'Leonardo Bonda da Stronda','417065219','77247722671','Musculação'),(25,'Hafthor Júlíus Bjornsson','481890066','12904215874','Musculação'),(26,'Michael Nada Rapido Fred Phelps','632073830','65525842408','Aulas em Grupo'),(27,'Gilberto Amauri Godoy Filho','146317070','73475054069','Aulas em Grupo'),(28,'Silvio Senor Abravanel Santos','816789612','73493104403','Aulas em Grupo'),(29,'Alterofilista da Silva Junior','247742036','60997760935','Musculação'),(30,'Aracy Mulher da Toptherm','562609016','57194078267','Aulas em Grupo');
/*!40000 ALTER TABLE `instrutor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamento` (
  `id_pagamento` int(11) NOT NULL AUTO_INCREMENT,
  `valor` float NOT NULL,
  `plano` varchar(6) NOT NULL,
  `data_pagamento` date NOT NULL,
  `proximo_pagamento` date NOT NULL,
  `aluno` int(11) NOT NULL,
  PRIMARY KEY (`id_pagamento`),
  KEY `aluno` (`aluno`)
) ENGINE=MyISAM AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
INSERT INTO `pagamento`  VALUES (1, 1350, 'Anual', '2017-06-13', '2018-06-13', 25),(2, 1350, 'Anual', '2018-01-30', '2019-01-30', 16),(3, 1350, 'Anual', '2018-03-24', '2019-03-24', 2),(4, 1350, 'Anual', '2018-05-18', '2019-05-18', 20),(5, 1350, 'Anual', '2018-06-13', '2019-06-13', 25),(6, 1350, 'Anual', '2018-07-23', '2019-07-23', 10),(7, 1350, 'Anual', '2018-08-15', '2019-08-15', 12),(8, 1350, 'Anual', '2018-09-01', '2019-09-01', 22),(9, 1350, 'Anual', '2018-10-12', '2019-10-12', 18),(10, 1350, 'Anual', '2018-12-08', '2019-12-08', 24),(11, 1400, 'Anual', '2019-01-09', '2020-01-09', 8),(12, 1400, 'Anual', '2019-01-30', '2020-01-30', 16),(13, 1400, 'Anual', '2019-02-19', '2020-02-19', 26),(14, 1400, 'Anual', '2019-03-24', '2020-03-04', 2),(15, 1400, 'Anual', '2019-04-29', '2020-04-29', 4),(16, 1400, 'Anual', '2019-05-02', '2020-05-02', 6),(17, 1400, 'Anual', '2019-05-25', '2020-05-25', 30),(18, 150, 'Mensal', '2019-06-19', '2019-07-19', 1),(19, 150, 'Mensal', '2019-06-21', '2019-07-21', 3),(20, 150, 'Mensal', '2019-06-29', '2019-07-29', 17),(21, 150, 'Mensal', '2019-07-01', '2019-08-01', 21),(22, 150, 'Mensal', '2019-07-05', '2019-08-05', 13),(23, 150, 'Mensal', '2019-07-09', '2019-08-09', 29),(24, 150, 'Mensal', '2019-07-13', '2019-08-13', 23),(25, 150, 'Mensal', '2019-07-14', '2019-08-14', 5),(26, 150, 'Mensal', '2019-07-16', '2019-08-16', 9),(27, 150, 'Mensal', '2019-07-19', '2019-08-19', 1),(28, 150, 'Mensal', '2019-07-02', '2019-08-02', 11),(29, 150, 'Mensal', '2019-07-21', '2019-08-21', 3),(30, 1400, 'Anual', '2019-07-21', '2020-07-21', 14),(31, 1400, 'Anual', '2019-07-23', '2020-07-23', 10),(32, 150, 'Mensal', '2019-07-23', '2019-08-23', 27),(33, 150, 'Mensal', '2019-07-27', '2019-08-27', 28),(34, 150, 'Mensal', '2019-07-28', '2019-08-28', 15),(35, 150, 'Mensal', '2019-07-29', '2019-08-29', 17),(36, 150, 'Mensal', '2019-07-31', '2019-08-31', 19),(37, 150, 'Mensal', '2019-07-04', '2019-08-04', 7),(38, 150, 'Mensal', '2019-08-01', '2019-09-01', 21),(39, 150, 'Mensal', '2019-08-02', '2019-09-02', 11),(40, 150, 'Mensal', '2019-08-05', '2019-09-05', 13),(41, 150, 'Mensal', '2019-08-09', '2019-09-09', 29),(42, 150, 'Mensal', '2019-08-13', '2019-09-13', 23),(43, 150, 'Mensal', '2019-08-14', '2019-09-14', 5),(44, 1400, 'Anual', '2019-08-15', '2020-08-15', 12),(45, 150, 'Mensal', '2019-08-16', '2019-09-16', 9),(46, 150, 'Mensal', '2019-08-19', '2019-09-19', 1),(47, 150, 'Mensal', '2019-08-21', '2019-09-21', 3),(48, 150, 'Mensal', '2019-08-23', '2019-09-23', 27),(49, 150, 'Mensal', '2019-08-27', '2019-09-27', 28),(50, 150, 'Mensal', '2019-08-28', '2019-09-28', 15),(51, 150, 'Mensal', '2019-08-29', '2019-09-29', 17),(52, 150, 'Mensal', '2019-08-31', '2019-09-30', 19),(53, 150, 'Mensal', '2019-08-04', '2019-09-04', 7),(54, 150, 'Mensal', '2019-09-01', '2019-10-01', 21),(55, 1400, 'Anual', '2019-09-01', '2020-09-01', 22),(56, 150, 'Mensal', '2019-09-05', '2019-10-05', 13),(57, 150, 'Mensal', '2019-09-09', '2019-10-09', 29),(58, 150, 'Mensal', '2019-09-13', '2019-10-13', 23),(59, 150, 'Mensal', '2019-09-14', '2019-10-14', 5),(60, 150, 'Mensal', '2019-09-16', '2019-10-16', 9),(61, 150, 'Mensal', '2019-09-19', '2019-10-19', 1),(62, 150, 'Mensal', '2019-09-02', '2019-10-02', 11),(63, 150, 'Mensal', '2019-09-21', '2019-10-21', 3),(64, 150, 'Mensal', '2019-09-23', '2019-10-23', 27),(65, 150, 'Mensal', '2019-09-27', '2019-10-27', 28),(66, 150, 'Mensal', '2019-09-28', '2019-10-28', 15),(67, 150, 'Mensal', '2019-09-29', '2019-10-29', 17),(68, 150, 'Mensal', '2019-09-30', '2019-10-30', 19),(69, 150, 'Mensal', '2019-09-04', '2019-10-04', 7),(70, 150, 'Mensal', '2019-10-01', '2019-11-01', 21),(71, 150, 'Mensal', '2019-10-05', '2019-11-05', 13),(72, 150, 'Mensal', '2019-10-09', '2019-11-09', 29),(73, 1400, 'Anual', '2019-10-12', '2020-10-12', 18),(74, 150, 'Mensal', '2019-10-13', '2019-11-13', 23),(75, 150, 'Mensal', '2019-10-14', '2019-11-14', 5),(76, 150, 'Mensal', '2019-10-16', '2019-11-16', 9),(77, 150, 'Mensal', '2019-10-19', '2019-11-19', 1),(78, 150, 'Mensal', '2019-10-02', '2019-11-02', 11),(79, 150, 'Mensal', '2019-10-21', '2019-11-21', 3),(80, 150, 'Mensal', '2019-10-23', '2019-11-23', 27),(81, 150, 'Mensal', '2019-10-27', '2019-11-27', 28),(82, 150, 'Mensal', '2019-10-28', '2019-11-28', 15),(83, 150, 'Mensal', '2019-10-29', '2019-11-29', 17),(84, 150, 'Mensal', '2019-10-30', '2019-11-30', 19),(85, 150, 'Mensal', '2019-10-04', '2019-11-04', 7),(86, 150, 'Mensal', '2019-11-01', '2019-12-01', 21),(87, 150, 'Mensal', '2019-11-05', '2019-12-05', 13),(88, 150, 'Mensal', '2019-11-09', '2019-12-09', 29),(89, 150, 'Mensal', '2019-11-13', '2019-12-13', 23),(90, 150, 'Mensal', '2019-11-14', '2019-12-14', 5),(91, 150, 'Mensal', '2019-11-16', '2019-12-16', 9),(92, 150, 'Mensal', '2019-11-19', '2019-12-19', 1),(93, 150, 'Mensal', '2019-11-02', '2019-12-02', 11),(94, 150, 'Mensal', '2019-11-21', '2019-12-21', 3),(95, 150, 'Mensal', '2019-11-23', '2019-12-23', 27),(96, 150, 'Mensal', '2019-11-27', '2019-12-27', 28),(97, 150, 'Mensal', '2019-11-28', '2019-12-28', 15),(98, 150, 'Mensal', '2019-11-29', '2019-12-29', 17),(99, 150, 'Mensal', '2019-11-30', '2019-12-30', 19),(100, 150, 'Mensal', '2019-11-04', '2019-12-04', 7),(101, 150, 'Mensal', '2019-12-01', '2020-01-01', 21),(102, 150, 'Mensal', '2019-12-05', '2020-01-05', 13),(103, 150, 'Mensal', '2019-12-09', '2020-01-09', 29),(104, 150, 'Mensal', '2019-12-13', '2020-01-13', 23),(105, 150, 'Mensal', '2019-12-14', '2020-01-14', 5),(106, 150, 'Mensal', '2019-12-16', '2020-01-16', 9),(107, 150, 'Mensal', '2019-12-19', '2020-01-19', 1),(108, 150, 'Mensal', '2019-12-02', '2020-01-02', 11),(109, 150, 'Mensal', '2019-12-21', '2020-01-21', 3),(110, 150, 'Mensal', '2019-12-23', '2020-01-23', 27),(111, 150, 'Mensal', '2019-12-27', '2020-01-27', 28),(112, 150, 'Mensal', '2019-12-28', '2020-01-28', 15),(113, 150, 'Mensal', '2019-12-29', '2020-01-29', 17),(114, 150, 'Mensal', '2019-12-30', '2020-01-30', 19),(115, 150, 'Mensal', '2019-12-04', '2020-01-04', 7),(116, 160, 'Mensal', '2020-01-01', '2020-02-01', 21),(117, 160, 'Mensal', '2020-01-05', '2020-02-05', 13),(118, 1500, 'Anual', '2020-01-09', '2021-01-09', 8),(119, 160, 'Mensal', '2020-01-09', '2020-02-09', 29),(120, 160, 'Mensal', '2020-01-13', '2020-02-13', 23),(121, 160, 'Mensal', '2020-01-14', '2020-02-14', 5),(122, 160, 'Mensal', '2020-01-16', '2020-02-16', 9),(123, 160, 'Mensal', '2020-01-19', '2020-02-19', 1),(124, 160, 'Mensal', '2020-01-02', '2020-02-02', 11),(125, 160, 'Mensal', '2020-01-21', '2020-02-21', 3),(126, 160, 'Mensal', '2020-01-23', '2020-02-23', 27),(127, 160, 'Mensal', '2020-01-27', '2020-02-27', 28),(128, 160, 'Mensal', '2020-01-28', '2020-02-28', 15),(129, 160, 'Mensal', '2020-01-29', '2020-02-29', 17),(130, 1500, 'Anual', '2020-01-30', '2021-01-30', 16),(131, 160, 'Mensal', '2020-01-30', '0000-00-00', 19),(132, 160, 'Mensal', '2020-01-04', '2020-02-04', 7),(133, 160, 'Mensal', '2020-02-01', '2020-03-01', 21),(134, 160, 'Mensal', '2020-02-05', '2020-03-05', 13),(135, 160, 'Mensal', '2020-02-09', '2020-03-09', 29),(136, 160, 'Mensal', '2020-02-13', '2020-03-13', 23),(137, 160, 'Mensal', '2020-02-14', '2020-03-14', 5),(138, 160, 'Mensal', '2020-02-16', '2020-03-16', 9),(139, 160, 'Mensal', '2020-02-19', '2020-03-19', 1),(140, 1500, 'Anual', '2020-02-19', '2021-02-19', 26),(141, 160, 'Mensal', '2020-02-02', '2020-03-02', 11),(142, 160, 'Mensal', '2020-02-21', '2020-03-21', 3),(143, 160, 'Mensal', '2020-02-23', '2020-03-23', 27),(144, 160, 'Mensal', '2020-02-27', '2020-03-27', 28),(145, 160, 'Mensal', '2020-02-28', '2020-03-28', 15),(146, 160, 'Mensal', '2020-02-29', '2020-03-29', 17),(147, 160, 'Mensal', '0000-00-00', '2020-03-30', 19),(148, 160, 'Mensal', '2020-02-04', '2020-03-04', 7),(149, 160, 'Mensal', '2020-03-04', '2020-04-04', 7);
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presenca`
--

DROP TABLE IF EXISTS `presenca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presenca` (
  `aluno` int(11) NOT NULL,
  `aula` int(11) NOT NULL,
  `data_aula` date NOT NULL,
  `horario_aula` time NOT NULL,
  PRIMARY KEY (`aluno`,`aula`,`data_aula`,`horario_aula`),
  KEY `aula` (`aula`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presenca`
--

LOCK TABLES `presenca` WRITE;
/*!40000 ALTER TABLE `presenca` DISABLE KEYS */;
/*!40000 ALTER TABLE `presenca` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-09-02 21:47:13
