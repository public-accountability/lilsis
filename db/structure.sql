
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
DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `street1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `county` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `postal` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `longitude` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_user_id` bigint(20) DEFAULT NULL,
  `accuracy` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `state_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id_idx` (`category_id`),
  KEY `country_id_idx` (`country_id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `state_id_idx` (`state_id`),
  CONSTRAINT `address_ibfk_2` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rails_1bfe88c8a7` FOREIGN KEY (`category_id`) REFERENCES `address_category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `address_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address_category` (
  `id` int(11) NOT NULL,
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `address_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address_country` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `address_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address_state` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `abbreviation` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `country_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`name`),
  KEY `country_id_idx` (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=709 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `context` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_primary` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`entity_id`,`name`,`context`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `name_idx` (`name`),
  CONSTRAINT `alias_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `alias_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23801 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `api_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_request` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `resource` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `ip_address` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `api_key_idx` (`api_key`),
  KEY `created_at_idx` (`created_at`),
  CONSTRAINT `api_request_ibfk_1` FOREIGN KEY (`api_key`) REFERENCES `api_user` (`api_key`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `api_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_api_tokens_on_token` (`token`),
  UNIQUE KEY `index_api_tokens_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `api_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `name_first` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name_last` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `reason` longtext COLLATE utf8_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `request_limit` int(11) NOT NULL DEFAULT 10000,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_key_unique_idx` (`api_key`),
  UNIQUE KEY `email_unique_idx` (`email`),
  KEY `api_key_idx` (`api_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `authors` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` longtext COLLATE utf8_unicode_ci NOT NULL,
  `description` mediumtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `is_indexed` tinyint(1) NOT NULL DEFAULT 0,
  `reviewed_at` datetime DEFAULT NULL,
  `reviewed_by_user_id` bigint(20) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `found_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `source_id_idx` (`source_id`),
  CONSTRAINT `article_ibfk_1` FOREIGN KEY (`source_id`) REFERENCES `article_source` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `article_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_article_entities_on_entity_id_and_article_id` (`entity_id`,`article_id`),
  KEY `index_article_entities_on_is_featured` (`is_featured`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `article_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_entity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `original_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `reviewed_by_user_id` bigint(20) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `article_id_idx` (`article_id`),
  KEY `entity_id_idx` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `article_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `abbreviation` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `snippet` varchar(255) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_by_user_id` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `annual_profit` bigint(20) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  `assets` bigint(20) unsigned DEFAULT NULL,
  `marketcap` bigint(20) unsigned DEFAULT NULL,
  `net_income` bigint(20) DEFAULT NULL,
  `crd_number` int(11) DEFAULT NULL,
  `aum` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_business_on_crd_number` (`crd_number`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `business_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=600 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `business_industry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_industry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `business_id` bigint(20) NOT NULL,
  `industry_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_id_idx` (`business_id`),
  KEY `industry_id_idx` (`industry_id`),
  CONSTRAINT `business_industry_ibfk_1` FOREIGN KEY (`industry_id`) REFERENCES `industry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_industry_ibfk_2` FOREIGN KEY (`business_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `business_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_person` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sec_cik` bigint(20) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  `crd_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_business_person_on_crd_number` (`crd_number`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `business_person_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=828 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `candidate_district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `candidate_district` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `candidate_id` bigint(20) NOT NULL,
  `district_id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`candidate_id`,`district_id`),
  KEY `district_id_idx` (`district_id`),
  CONSTRAINT `candidate_district_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `political_district` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chat_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `room` bigint(20) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_user_id_idx` (`room`,`user_id`),
  KEY `room_updated_at_user_id_idx` (`room`,`updated_at`,`user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cmp_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cmp_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) DEFAULT NULL,
  `cmp_id` int(11) DEFAULT NULL,
  `entity_type` tinyint(3) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `strata` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_cmp_entities_on_cmp_id` (`cmp_id`),
  UNIQUE KEY `index_cmp_entities_on_entity_id` (`entity_id`),
  CONSTRAINT `fk_rails_216b4cd432` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=289 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cmp_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cmp_relationships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cmp_affiliation_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `cmp_org_id` int(11) NOT NULL,
  `cmp_person_id` int(11) NOT NULL,
  `relationship_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_cmp_relationships_on_cmp_affiliation_id` (`cmp_affiliation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `common_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_names` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_common_names_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `couple`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `couple` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) NOT NULL,
  `partner1_id` int(11) DEFAULT NULL,
  `partner2_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_couple_on_entity_id` (`entity_id`),
  KEY `index_couple_on_partner1_id` (`partner1_id`),
  KEY `index_couple_on_partner2_id` (`partner2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `custom_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_key` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_model` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `object_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `object_name_idx` (`object_model`,`object_id`,`name`),
  UNIQUE KEY `object_name_value_idx` (`object_model`,`object_id`,`name`,`value`(100)),
  KEY `object_idx` (`object_model`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `dashboard_bulletins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard_bulletins` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `markdown` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dashboard_bulletins_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `degree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `degree` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `abbreviation` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `delayed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) NOT NULL DEFAULT 0,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `handler` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `last_error` mediumtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB AUTO_INCREMENT=73464 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` text COLLATE utf8_unicode_ci NOT NULL,
  `url_hash` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `publication_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_type` int(11) NOT NULL DEFAULT 1,
  `excerpt` mediumtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_documents_on_url_hash` (`url_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=2465 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `donation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bundler_id` bigint(20) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bundler_id_idx` (`bundler_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `donation_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `donation_ibfk_2` FOREIGN KEY (`bundler_id`) REFERENCES `entity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1982 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `edited_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `edited_entities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_edited_entities_on_entity_id_and_version_id` (`entity_id`,`version_id`),
  UNIQUE KEY `index_edited_entities_on_entity_id_and_version_id_and_user_id` (`entity_id`,`version_id`,`user_id`),
  KEY `index_edited_entities_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3848 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `education` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `degree_id` bigint(20) DEFAULT NULL,
  `field` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_dropout` tinyint(1) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `degree_id_idx` (`degree_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `education_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `education_ibfk_2` FOREIGN KEY (`degree_id`) REFERENCES `degree` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `elected_representative`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elected_representative` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bioguide_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `govtrack_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crp_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pvs_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `watchdog_id` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  `fec_ids` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `crp_id_idx` (`crp_id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `elected_representative_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=420 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `address` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  CONSTRAINT `email_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `email_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `blurb` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `summary` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `primary_ext` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `start_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `end_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_user_id` int(11) DEFAULT NULL,
  `merged_id` int(11) DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT 1,
  `link_count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `blurb_idx` (`blurb`),
  KEY `created_at_idx` (`created_at`),
  KEY `index_entity_on_delta` (`delta`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `search_idx` (`name`,`blurb`,`website`),
  KEY `name_idx` (`name`),
  KEY `parent_id_idx` (`parent_id`),
  KEY `updated_at_idx` (`updated_at`),
  KEY `website_idx` (`website`),
  CONSTRAINT `entity_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `entity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `entity_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40580 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `entity_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `field_id` int(11) DEFAULT NULL,
  `value` varchar(255) NOT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_entity_fields_on_entity_id_and_field_id` (`entity_id`,`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `extension_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extension_definition` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `display_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `has_fields` tinyint(1) NOT NULL DEFAULT 0,
  `parent_id` bigint(20) DEFAULT NULL,
  `tier` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`),
  KEY `parent_id_idx` (`parent_id`),
  KEY `tier_idx` (`tier`),
  CONSTRAINT `extension_definition_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `extension_definition` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `extension_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extension_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `definition_id` bigint(20) NOT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `definition_id_idx` (`definition_id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  CONSTRAINT `extension_record_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `extension_record_ibfk_2` FOREIGN KEY (`definition_id`) REFERENCES `extension_definition` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `extension_record_ibfk_3` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25107 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `external_datasets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `external_datasets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `row_data` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `match_data` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `primary_ext` tinyint(4) DEFAULT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `dataset_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_external_datasets_on_type_and_dataset_key` (`type`,`dataset_key`),
  KEY `index_external_datasets_on_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1717 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `external_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `external_links` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `link_type` tinyint(3) unsigned NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `link_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_external_links_on_entity_id_and_link_type` (`entity_id`,`link_type`),
  KEY `index_external_links_on_entity_id` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `family` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_nonbiological` tinyint(1) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `family_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fedspending_filing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fedspending_filing` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) DEFAULT NULL,
  `amount` bigint(20) DEFAULT NULL,
  `goods` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `district_id` bigint(20) DEFAULT NULL,
  `fedspending_id` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `end_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `district_id_idx` (`district_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `fedspending_filing_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fedspending_filing_ibfk_2` FOREIGN KEY (`district_id`) REFERENCES `political_district` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'string',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_fields_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `generic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `government_body`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `government_body` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_federal` tinyint(1) DEFAULT NULL,
  `state_id` bigint(20) DEFAULT NULL,
  `city` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `state_id_idx` (`state_id`),
  CONSTRAINT `government_body_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `address_state` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `government_body_ibfk_2` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `help_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `markdown` mediumtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_help_pages_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hierarchy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) DEFAULT NULL,
  `filename` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `caption` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_free` tinyint(1) DEFAULT NULL,
  `url` varchar(400) COLLATE utf8_unicode_ci DEFAULT NULL,
  `width` bigint(20) DEFAULT NULL,
  `height` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_user_id` int(11) DEFAULT NULL,
  `has_square` tinyint(1) NOT NULL DEFAULT 0,
  `address_id` int(11) DEFAULT NULL,
  `raw_address` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `has_face` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_image_on_address_id` (`address_id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  CONSTRAINT `image_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `image_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `industries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `industries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `industry_id` varchar(255) NOT NULL,
  `sector_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_industries_on_industry_id` (`industry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `industry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `industry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `context` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `link` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity1_id` bigint(20) NOT NULL,
  `entity2_id` bigint(20) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  `relationship_id` bigint(20) NOT NULL,
  `is_reverse` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id_idx` (`category_id`),
  KEY `index_link_on_entity1_id_and_category_id_and_is_reverse` (`entity1_id`,`category_id`,`is_reverse`),
  KEY `index_link_on_entity1_id_and_category_id` (`entity1_id`,`category_id`),
  KEY `entity1_id_idx` (`entity1_id`),
  KEY `entity2_id_idx` (`entity2_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `link_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`),
  CONSTRAINT `link_ibfk_2` FOREIGN KEY (`entity2_id`) REFERENCES `entity` (`id`),
  CONSTRAINT `link_ibfk_3` FOREIGN KEY (`entity1_id`) REFERENCES `entity` (`id`),
  CONSTRAINT `link_ibfk_4` FOREIGN KEY (`category_id`) REFERENCES `relationship_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17921 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobby_filing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobby_filing` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `federal_filing_id` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `amount` bigint(20) DEFAULT NULL,
  `year` bigint(20) DEFAULT NULL,
  `period` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `report_type` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `end_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobby_filing_lobby_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobby_filing_lobby_issue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `issue_id` bigint(20) NOT NULL,
  `lobby_filing_id` bigint(20) NOT NULL,
  `specific_issue` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issue_id_idx` (`issue_id`),
  KEY `lobby_filing_id_idx` (`lobby_filing_id`),
  CONSTRAINT `lobby_filing_lobby_issue_ibfk_1` FOREIGN KEY (`lobby_filing_id`) REFERENCES `lobby_filing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lobby_filing_lobby_issue_ibfk_2` FOREIGN KEY (`issue_id`) REFERENCES `lobby_issue` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobby_filing_lobbyist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobby_filing_lobbyist` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lobbyist_id` bigint(20) NOT NULL,
  `lobby_filing_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lobby_filing_id_idx` (`lobby_filing_id`),
  KEY `lobbyist_id_idx` (`lobbyist_id`),
  CONSTRAINT `lobby_filing_lobbyist_ibfk_1` FOREIGN KEY (`lobbyist_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lobby_filing_lobbyist_ibfk_2` FOREIGN KEY (`lobby_filing_id`) REFERENCES `lobby_filing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobby_filing_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobby_filing_relationship` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) NOT NULL,
  `lobby_filing_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lobby_filing_id_idx` (`lobby_filing_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `lobby_filing_relationship_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`),
  CONSTRAINT `lobby_filing_relationship_ibfk_2` FOREIGN KEY (`lobby_filing_id`) REFERENCES `lobby_filing` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobby_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobby_issue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobbying`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobbying` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `lobbying_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `lobbyist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lobbyist` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lda_registrant_id` bigint(20) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `lobbyist_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ls_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_list` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_ranked` tinyint(1) NOT NULL DEFAULT 0,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `display_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `featured_list_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `custom_field_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT 1,
  `creator_user_id` int(11) DEFAULT NULL,
  `short_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `access` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `index_ls_list_on_delta` (`delta`),
  KEY `featured_list_id` (`featured_list_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `index_ls_list_on_name` (`name`),
  CONSTRAINT `ls_list_ibfk_1` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `ls_list_ibfk_2` FOREIGN KEY (`featured_list_id`) REFERENCES `ls_list` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2257 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ls_list_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_list_entity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `list_id` bigint(20) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `rank` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  `custom_field` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at_idx` (`created_at`),
  KEY `index_ls_list_entity_on_entity_id_and_list_id` (`entity_id`,`list_id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `list_id_idx` (`list_id`),
  CONSTRAINT `ls_list_entity_ibfk_1` FOREIGN KEY (`list_id`) REFERENCES `ls_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_list_entity_ibfk_2` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ls_list_entity_ibfk_3` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=880 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `map_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_annotations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `map_id` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `highlighted_entity_ids` varchar(255) DEFAULT NULL,
  `highlighted_rel_ids` varchar(255) DEFAULT NULL,
  `highlighted_text_ids` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_map_annotations_on_map_id` (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `membership` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dues` bigint(20) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  `elected_term` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `membership_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=542 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `modification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `object_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 1,
  `is_create` tinyint(1) NOT NULL DEFAULT 0,
  `is_delete` tinyint(1) NOT NULL DEFAULT 0,
  `is_merge` tinyint(1) NOT NULL DEFAULT 0,
  `merge_object_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_model` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `object_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `is_create_idx` (`is_create`),
  KEY `is_delete_idx` (`is_delete`),
  KEY `object_id_idx` (`object_id`),
  KEY `object_idx` (`object_model`,`object_id`),
  KEY `object_model_idx` (`object_model`),
  KEY `points_summary_idx` (`user_id`,`is_create`,`object_model`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `modification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `modification_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modification_field` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `modification_id` bigint(20) NOT NULL,
  `field_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `old_value` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `new_value` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `modification_id_idx` (`modification_id`),
  CONSTRAINT `modification_field_ibfk_1` FOREIGN KEY (`modification_id`) REFERENCES `modification` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `network_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_map` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `data` longtext COLLATE utf8_unicode_ci NOT NULL,
  `entity_ids` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rel_ids` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `zoom` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT 1,
  `index_data` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `graph_data` mediumtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `annotations_data` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `annotations_count` int(11) NOT NULL DEFAULT 0,
  `list_sources` tinyint(1) NOT NULL DEFAULT 0,
  `is_cloneable` tinyint(1) NOT NULL DEFAULT 1,
  `sf_user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_network_map_on_delta` (`delta`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1263 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ny_disclosures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ny_disclosures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filer_id` varchar(10) NOT NULL,
  `report_id` varchar(255) DEFAULT NULL,
  `transaction_code` varchar(1) NOT NULL,
  `e_year` varchar(4) NOT NULL,
  `transaction_id` bigint(20) NOT NULL,
  `schedule_transaction_date` date DEFAULT NULL,
  `original_date` date DEFAULT NULL,
  `contrib_code` varchar(4) DEFAULT NULL,
  `contrib_type_code` varchar(1) DEFAULT NULL,
  `corp_name` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `mid_init` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `zip` varchar(5) DEFAULT NULL,
  `check_number` varchar(255) DEFAULT NULL,
  `check_date` varchar(255) DEFAULT NULL,
  `amount1` float DEFAULT NULL,
  `amount2` float DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `other_recpt_code` varchar(255) DEFAULT NULL,
  `purpose_code1` varchar(255) DEFAULT NULL,
  `purpose_code2` varchar(255) DEFAULT NULL,
  `explanation` varchar(255) DEFAULT NULL,
  `transfer_type` varchar(1) DEFAULT NULL,
  `bank_loan_check_box` varchar(1) DEFAULT NULL,
  `crerec_uid` varchar(255) DEFAULT NULL,
  `crerec_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `index_ny_disclosures_on_contrib_code` (`contrib_code`),
  KEY `index_ny_disclosures_on_delta` (`delta`),
  KEY `index_ny_disclosures_on_e_year` (`e_year`),
  KEY `index_filer_report_trans_date_e_year` (`filer_id`,`report_id`,`transaction_id`,`schedule_transaction_date`,`e_year`),
  KEY `index_ny_disclosures_on_filer_id` (`filer_id`),
  KEY `index_ny_disclosures_on_original_date` (`original_date`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ny_filer_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ny_filer_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ny_filer_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `is_committee` tinyint(1) DEFAULT NULL,
  `cmte_entity_id` int(11) DEFAULT NULL,
  `e_year` varchar(4) DEFAULT NULL,
  `filer_id` varchar(255) DEFAULT NULL,
  `office` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ny_filer_entities_on_cmte_entity_id` (`cmte_entity_id`),
  KEY `index_ny_filer_entities_on_entity_id` (`entity_id`),
  KEY `index_ny_filer_entities_on_filer_id` (`filer_id`),
  KEY `index_ny_filer_entities_on_is_committee` (`is_committee`),
  KEY `index_ny_filer_entities_on_ny_filer_id` (`ny_filer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ny_filers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ny_filers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filer_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `filer_type` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `committee_type` varchar(255) DEFAULT NULL,
  `office` int(11) DEFAULT NULL,
  `district` int(11) DEFAULT NULL,
  `treas_first_name` varchar(255) DEFAULT NULL,
  `treas_last_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ny_filers_on_filer_id` (`filer_id`),
  KEY `index_ny_filers_on_filer_type` (`filer_type`)
) ENGINE=InnoDB AUTO_INCREMENT=469 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ny_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ny_matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ny_disclosure_id` int(11) DEFAULT NULL,
  `donor_id` int(11) DEFAULT NULL,
  `recip_id` int(11) DEFAULT NULL,
  `relationship_id` int(11) DEFAULT NULL,
  `matched_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ny_matches_on_ny_disclosure_id` (`ny_disclosure_id`),
  KEY `index_ny_matches_on_donor_id` (`donor_id`),
  KEY `index_ny_matches_on_recip_id` (`recip_id`),
  KEY `index_ny_matches_on_relationship_id` (`relationship_id`)
) ENGINE=InnoDB AUTO_INCREMENT=410 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `object_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_model` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`object_model`,`object_id`,`tag_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `object_idx` (`object_model`,`object_id`),
  KEY `tag_id_idx` (`tag_id`),
  CONSTRAINT `object_tag_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `object_tag_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `name_nick` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `employees` bigint(20) DEFAULT NULL,
  `revenue` bigint(20) DEFAULT NULL,
  `fedspending_id` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lda_registrant_id` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `org_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9806 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_candidates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cycle` varchar(255) NOT NULL,
  `feccandid` varchar(255) NOT NULL,
  `crp_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `party` varchar(1) DEFAULT NULL,
  `distid_runfor` varchar(255) DEFAULT NULL,
  `distid_current` varchar(255) DEFAULT NULL,
  `currcand` tinyint(1) DEFAULT NULL,
  `cyclecand` tinyint(1) DEFAULT NULL,
  `crpico` varchar(1) DEFAULT NULL,
  `recipcode` varchar(2) DEFAULT NULL,
  `nopacs` varchar(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_os_candidates_on_crp_id` (`crp_id`),
  KEY `index_os_candidates_on_cycle_and_crp_id` (`cycle`,`crp_id`),
  KEY `index_os_candidates_on_feccandid` (`feccandid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_id` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `category_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `industry_id` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `industry_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `sector_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_id_idx` (`category_id`),
  UNIQUE KEY `unique_name_idx` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_committees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_committees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cycle` varchar(4) NOT NULL,
  `cmte_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `affiliate` varchar(255) DEFAULT NULL,
  `ultorg` varchar(255) DEFAULT NULL,
  `recipid` varchar(255) DEFAULT NULL,
  `recipcode` varchar(2) DEFAULT NULL,
  `feccandid` varchar(255) DEFAULT NULL,
  `party` varchar(1) DEFAULT NULL,
  `primcode` varchar(5) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `sensitive` tinyint(1) DEFAULT NULL,
  `foreign` tinyint(1) DEFAULT NULL,
  `active_in_cycle` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_os_committees_on_cmte_id_and_cycle` (`cmte_id`,`cycle`),
  KEY `index_os_committees_on_cmte_id` (`cmte_id`),
  KEY `index_os_committees_on_recipid` (`recipid`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_donations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_donations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cycle` varchar(4) NOT NULL,
  `fectransid` varchar(19) NOT NULL,
  `contribid` varchar(12) DEFAULT NULL,
  `contrib` varchar(255) DEFAULT NULL,
  `recipid` varchar(9) DEFAULT NULL,
  `orgname` varchar(255) DEFAULT NULL,
  `ultorg` varchar(255) DEFAULT NULL,
  `realcode` varchar(5) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `zip` varchar(5) DEFAULT NULL,
  `recipcode` varchar(2) DEFAULT NULL,
  `transactiontype` varchar(3) DEFAULT NULL,
  `cmteid` varchar(9) DEFAULT NULL,
  `otherid` varchar(9) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `microfilm` varchar(30) DEFAULT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  `employer` varchar(255) DEFAULT NULL,
  `source` varchar(5) DEFAULT NULL,
  `fec_cycle_id` varchar(24) NOT NULL,
  `name_last` varchar(255) DEFAULT NULL,
  `name_first` varchar(255) DEFAULT NULL,
  `name_middle` varchar(255) DEFAULT NULL,
  `name_suffix` varchar(255) DEFAULT NULL,
  `name_prefix` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_os_donations_on_fec_cycle_id` (`fec_cycle_id`),
  KEY `index_os_donations_on_amount` (`amount`),
  KEY `index_os_donations_on_contribid` (`contribid`),
  KEY `index_os_donations_on_cycle` (`cycle`),
  KEY `index_os_donations_on_date` (`date`),
  KEY `index_os_donations_on_fectransid_and_cycle` (`fectransid`,`cycle`),
  KEY `index_os_donations_on_fectransid` (`fectransid`),
  KEY `index_os_donations_on_microfilm` (`microfilm`),
  KEY `index_os_donations_on_name_last_and_name_first` (`name_last`,`name_first`),
  KEY `index_os_donations_on_realcode_and_amount` (`realcode`,`amount`),
  KEY `index_os_donations_on_realcode` (`realcode`),
  KEY `index_os_donations_on_recipid_and_amount` (`recipid`,`amount`),
  KEY `index_os_donations_on_recipid` (`recipid`),
  KEY `index_os_donations_on_state` (`state`),
  KEY `index_os_donations_on_zip` (`zip`)
) ENGINE=InnoDB AUTO_INCREMENT=1152 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_entity_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_entity_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `category_id` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `source` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`entity_id`,`category_id`),
  KEY `category_id_idx` (`category_id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `os_entity_category_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_entity_donor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_entity_donor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `donor_id` varchar(12) CHARACTER SET utf8 DEFAULT NULL,
  `match_code` bigint(20) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `reviewed_by_user_id` bigint(20) DEFAULT NULL,
  `is_processed` tinyint(1) NOT NULL DEFAULT 0,
  `is_synced` tinyint(1) NOT NULL DEFAULT 1,
  `reviewed_at` datetime DEFAULT NULL,
  `locked_by_user_id` bigint(20) DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entity_donor_idx` (`entity_id`,`donor_id`),
  KEY `is_synced_idx` (`is_synced`),
  KEY `locked_at_idx` (`locked_at`),
  KEY `reviewed_at_idx` (`reviewed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_entity_preprocess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_entity_preprocess` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `cycle` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `processed_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entity_cycle_idx` (`entity_id`,`cycle`),
  KEY `entity_id_idx` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_entity_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_entity_transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) NOT NULL,
  `cycle` varchar(4) NOT NULL,
  `transaction_id` varchar(30) NOT NULL,
  `match_code` bigint(20) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_processed` tinyint(1) NOT NULL DEFAULT 0,
  `is_synced` tinyint(1) NOT NULL DEFAULT 1,
  `reviewed_by_user_id` bigint(20) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `locked_by_user_id` bigint(20) DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entity_cycle_transaction_idx` (`entity_id`,`cycle`,`transaction_id`),
  KEY `is_synced_idx` (`is_synced`),
  KEY `locked_at_idx` (`locked_at`),
  KEY `reviewed_at_idx` (`reviewed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `os_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `os_donation_id` int(11) NOT NULL,
  `donation_id` int(11) DEFAULT NULL,
  `donor_id` int(11) NOT NULL,
  `recip_id` int(11) DEFAULT NULL,
  `relationship_id` int(11) DEFAULT NULL,
  `matched_by` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `cmte_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_os_matches_on_cmte_id` (`cmte_id`),
  KEY `index_os_matches_on_donor_id` (`donor_id`),
  KEY `index_os_matches_on_os_donation_id` (`os_donation_id`),
  KEY `index_os_matches_on_recip_id` (`recip_id`),
  KEY `index_os_matches_on_relationship_id` (`relationship_id`)
) ENGINE=InnoDB AUTO_INCREMENT=939 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ownership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ownership` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `percent_stake` bigint(20) DEFAULT NULL,
  `shares` bigint(20) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `ownership_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `markdown` mediumtext DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pages_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name_last` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name_first` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name_middle` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_prefix` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_suffix` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_nick` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthplace` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender_id` bigint(20) DEFAULT NULL,
  `party_id` bigint(20) DEFAULT NULL,
  `is_independent` tinyint(1) DEFAULT NULL,
  `net_worth` bigint(20) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  `name_maiden` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nationality` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `gender_id_idx` (`gender_id`),
  KEY `name_idx` (`name_last`,`name_first`,`name_middle`),
  KEY `party_id_idx` (`party_id`),
  CONSTRAINT `person_ibfk_1` FOREIGN KEY (`party_id`) REFERENCES `entity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `person_ibfk_3` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11949 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_id` bigint(20) NOT NULL,
  `number` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `last_user_id_idx` (`last_user_id`),
  CONSTRAINT `phone_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `phone_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `political_candidate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `political_candidate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_federal` tinyint(1) DEFAULT NULL,
  `is_state` tinyint(1) DEFAULT NULL,
  `is_local` tinyint(1) DEFAULT NULL,
  `pres_fec_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `senate_fec_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `house_fec_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crp_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `crp_id_idx` (`crp_id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `house_fec_id_idx` (`house_fec_id`),
  KEY `pres_fec_id_idx` (`pres_fec_id`),
  KEY `senate_fec_id_idx` (`senate_fec_id`),
  CONSTRAINT `political_candidate_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `political_district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `political_district` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state_id` bigint(20) DEFAULT NULL,
  `federal_district` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_district` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `local_district` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `state_id_idx` (`state_id`),
  CONSTRAINT `political_district_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `address_state` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `political_fundraising`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `political_fundraising` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fec_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_id` bigint(20) DEFAULT NULL,
  `state_id` bigint(20) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `fec_id_idx` (`fec_id`),
  KEY `state_id_idx` (`state_id`),
  KEY `type_id_idx` (`type_id`),
  CONSTRAINT `political_fundraising_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `political_fundraising_type` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `political_fundraising_ibfk_2` FOREIGN KEY (`state_id`) REFERENCES `address_state` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `political_fundraising_ibfk_3` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `political_fundraising_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `political_fundraising_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `position` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_board` tinyint(1) DEFAULT NULL,
  `is_executive` tinyint(1) DEFAULT NULL,
  `is_employee` tinyint(1) DEFAULT NULL,
  `compensation` bigint(20) DEFAULT NULL,
  `boss_id` bigint(20) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boss_id_idx` (`boss_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `position_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `position_ibfk_2` FOREIGN KEY (`boss_id`) REFERENCES `entity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3167 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `professional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `professional` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `professional_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `public_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public_company` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ticker` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sec_cik` bigint(20) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `public_company_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reference` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fields` varchar(200) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `source` varchar(1000) NOT NULL,
  `source_detail` varchar(255) DEFAULT NULL,
  `publication_date` varchar(10) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_model` varchar(50) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  `ref_type` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `name_idx` (`name`),
  KEY `index_reference_on_object_model_and_object_id_and_ref_type` (`object_model`,`object_id`,`ref_type`),
  KEY `object_idx` (`object_model`,`object_id`,`updated_at`),
  KEY `source_idx` (`source`(191)),
  KEY `updated_at_idx` (`updated_at`),
  CONSTRAINT `reference_ibfk_1` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `reference_excerpt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reference_excerpt` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `reference_id` bigint(20) NOT NULL,
  `body` longtext COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `last_user_id_idx` (`last_user_id`),
  KEY `reference_id_idx` (`reference_id`),
  CONSTRAINT `reference_excerpt_ibfk_1` FOREIGN KEY (`reference_id`) REFERENCES `reference` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reference_excerpt_ibfk_2` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` bigint(20) NOT NULL,
  `referenceable_id` bigint(20) NOT NULL,
  `referenceable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_references_on_referenceable_id_and_referenceable_type` (`referenceable_id`,`referenceable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2569 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relationship` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity1_id` bigint(20) NOT NULL,
  `entity2_id` bigint(20) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  `description1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` bigint(20) DEFAULT NULL,
  `goods` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `filings` bigint(20) DEFAULT NULL,
  `notes` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `start_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `end_date` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_user_id` int(11) DEFAULT NULL,
  `amount2` bigint(20) DEFAULT NULL,
  `is_gte` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `category_id_idx` (`category_id`),
  KEY `entity1_category_idx` (`entity1_id`,`category_id`),
  KEY `entity_idx` (`entity1_id`,`entity2_id`),
  KEY `entity1_id_idx` (`entity1_id`),
  KEY `entity2_id_idx` (`entity2_id`),
  KEY `index_relationship_is_d_e2_cat_amount` (`is_deleted`,`entity2_id`,`category_id`,`amount`),
  KEY `last_user_id_idx` (`last_user_id`),
  CONSTRAINT `relationship_ibfk_1` FOREIGN KEY (`entity2_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relationship_ibfk_2` FOREIGN KEY (`entity1_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relationship_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `relationship_category` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `relationship_ibfk_4` FOREIGN KEY (`last_user_id`) REFERENCES `sf_guard_user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5964 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `relationship_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relationship_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `display_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `default_description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity1_requirements` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity2_requirements` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `has_fields` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `representative`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `representative` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bioguide_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `representative_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `representative_district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `representative_district` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `representative_id` bigint(20) NOT NULL,
  `district_id` bigint(20) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`representative_id`,`district_id`),
  KEY `district_id_idx` (`district_id`),
  KEY `representative_id_idx` (`representative_id`),
  CONSTRAINT `representative_district_ibfk_3` FOREIGN KEY (`representative_id`) REFERENCES `elected_representative` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `representative_district_ibfk_4` FOREIGN KEY (`district_id`) REFERENCES `political_district` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `endowment` bigint(20) DEFAULT NULL,
  `students` bigint(20) DEFAULT NULL,
  `faculty` bigint(20) DEFAULT NULL,
  `tuition` bigint(20) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT NULL,
  `entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id_idx` (`entity_id`),
  CONSTRAINT `school_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5556 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sf_guard_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sf_guard_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` mediumtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sf_guard_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sf_guard_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `algorithm` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'sha1',
  `salt` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_super_admin` tinyint(1) DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `is_active_idx_idx` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=20233 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sf_guard_user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sf_guard_user_permission` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `permission_id` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `sf_guard_user_permission_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sf_guard_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sf_guard_user_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `sf_guard_permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sf_guard_user_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sf_guard_user_profile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name_first` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name_last` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `reason` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `analyst_reason` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `invitation_code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enable_announcements` tinyint(1) NOT NULL DEFAULT 1,
  `enable_html_editor` tinyint(1) NOT NULL DEFAULT 1,
  `enable_recent_views` tinyint(1) NOT NULL DEFAULT 1,
  `enable_favorites` tinyint(1) NOT NULL DEFAULT 1,
  `enable_pointers` tinyint(1) NOT NULL DEFAULT 1,
  `public_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `bio` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_confirmed` tinyint(1) NOT NULL DEFAULT 0,
  `confirmation_code` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ranking_opt_out` tinyint(1) NOT NULL DEFAULT 0,
  `watching_opt_out` tinyint(1) NOT NULL DEFAULT 0,
  `enable_notes_list` tinyint(1) NOT NULL DEFAULT 1,
  `enable_notes_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `score` bigint(20) DEFAULT NULL,
  `show_full_name` tinyint(1) NOT NULL DEFAULT 0,
  `unread_notes` int(11) DEFAULT 0,
  `home_network_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email_idx` (`email`),
  UNIQUE KEY `unique_public_name_idx` (`public_name`),
  UNIQUE KEY `unique_user_idx` (`user_id`),
  KEY `user_id_public_name_idx` (`user_id`,`public_name`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `social_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sphinx_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sphinx_index` (
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `triple_namespace` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `triple_predicate` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `triple_value` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueness_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL,
  `tagable_class` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `tagable_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `last_user_id` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_tagable_class` (`tagable_class`),
  KEY `index_taggings_on_tagable_id` (`tagable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4473 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `restricted` tinyint(1) DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `toolkit_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `toolkit_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `markdown` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_toolkit_pages_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contact1_id` bigint(20) DEFAULT NULL,
  `contact2_id` bigint(20) DEFAULT NULL,
  `district_id` bigint(20) DEFAULT NULL,
  `is_lobbying` tinyint(1) DEFAULT NULL,
  `relationship_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contact1_id_idx` (`contact1_id`),
  KEY `contact2_id_idx` (`contact2_id`),
  KEY `relationship_id_idx` (`relationship_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`relationship_id`) REFERENCES `relationship` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`contact2_id`) REFERENCES `entity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`contact1_id`) REFERENCES `entity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `unmatched_ny_filers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unmatched_ny_filers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ny_filer_id` bigint(20) NOT NULL,
  `disclosure_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_unmatched_ny_filers_on_ny_filer_id` (`ny_filer_id`),
  KEY `index_unmatched_ny_filers_on_disclosure_count` (`disclosure_count`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) NOT NULL,
  `access_rules` mediumtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_permissions_on_user_id_and_resource_type` (`user_id`,`resource_type`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name_first` varchar(255) DEFAULT NULL,
  `name_last` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `reason` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_profiles_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_87a6352e58` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3088 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `source_id` int(11) DEFAULT NULL,
  `dest_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `reviewer_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `justification` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_requests_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_de8c07e72e` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=655 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT 0,
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `default_network_id` int(11) DEFAULT NULL,
  `sf_guard_user_id` int(11) NOT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `newsletter` tinyint(1) DEFAULT NULL,
  `is_restricted` tinyint(1) DEFAULT 0,
  `map_the_power` tinyint(1) DEFAULT NULL,
  `about_me` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `role` tinyint(4) NOT NULL DEFAULT 0,
  `abilities` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_sf_guard_user_id` (`sf_guard_user_id`),
  UNIQUE KEY `index_users_on_username` (`username`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=21309 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) NOT NULL,
  `item_id` int(11) NOT NULL,
  `event` varchar(255) NOT NULL,
  `whodunnit` varchar(255) DEFAULT NULL,
  `object` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `object_changes` longtext DEFAULT NULL,
  `entity1_id` int(11) DEFAULT NULL,
  `entity2_id` int(11) DEFAULT NULL,
  `association_data` longtext DEFAULT NULL,
  `other_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_versions_on_created_at` (`created_at`),
  KEY `index_versions_on_entity1_id` (`entity1_id`),
  KEY `index_versions_on_entity2_id` (`entity2_id`),
  KEY `index_versions_on_item_type_and_item_id` (`item_type`,`item_id`),
  KEY `index_versions_on_whodunnit` (`whodunnit`)
) ENGINE=InnoDB AUTO_INCREMENT=8136 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 DROP FUNCTION IF EXISTS `network_map_link` */;
ALTER DATABASE `littlesis_test` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`littlesis`@`%` FUNCTION `network_map_link`(id BIGINT, title VARCHAR(100)) RETURNS text CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
  DECLARE param varchar(250);
  SET param = LCASE(REPLACE(REPLACE(TRIM(title), ' ', '-'), '/', '_'));
  RETURN CONCAT('<a target="_blank" href="/maps/',
  	 	CAST(id as CHAR), '-', param,
		'">', TRIM(title), '</a>');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `littlesis_test` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 DROP FUNCTION IF EXISTS `recent_entity_edits` */;
ALTER DATABASE `littlesis_test` CHARACTER SET utf8 COLLATE utf8_general_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`littlesis`@`%` FUNCTION `recent_entity_edits`(history_limit INTEGER, user_id VARCHAR(255)) RETURNS longtext CHARSET utf8mb4 COLLATE utf8mb4_bin
    READS SQL DATA
    DETERMINISTIC
BEGIN

  
  DECLARE json JSON;

  
  DECLARE _version_id BIGINT;
  DECLARE _item_type VARCHAR(255);
  DECLARE _item_id INTEGER;
  DECLARE _entity1_id INTEGER;
  DECLARE _entity2_id INTEGER;
  DECLARE _user_id INTEGER;
  DECLARE _created_at DATETIME;

  DECLARE done BOOL DEFAULT FALSE; 

  
  DECLARE versions_cursor CURSOR FOR
  	  		  SELECT id, item_type, item_id, entity1_id, entity2_id, CAST(whodunnit AS INTEGER), created_at
  			  FROM versions
  			  WHERE entity1_id IS NOT NULL AND
			  (CASE WHEN user_id is NOT NULL THEN whodunnit = user_id ELSE TRUE END)
  			  ORDER BY id desc
  			  limit history_limit;

  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  
  SET json = JSON_ARRAY();

  OPEN versions_cursor;

  read_loop: LOOP
     FETCH versions_cursor INTO _version_id, _item_type, _item_id, _entity1_id, _entity2_id, _user_id, _created_at;

     IF done THEN
      LEAVE read_loop;
     END IF;

     
     SET json = JSON_ARRAY_APPEND(json, '$', JSON_OBJECT("entity_id", CAST(_entity1_id AS INT),
     				                         "version_id", CAST(_version_id AS INT),
     				     	                 "item_type", _item_type,
     					                 "item_id", CAST(_item_id AS INT),
     					                 "user_id", CAST(_user_id as INT),
     					                 "created_at", _created_at));

     
     
     

     IF _entity2_id IS NOT NULL THEN

       SET json = JSON_ARRAY_APPEND(json, '$', JSON_OBJECT("entity_id", CAST(_entity2_id AS INT),
     				                           "version_id", CAST(_version_id AS INT),
     				     	                   "item_type", _item_type,
     					                   "item_id", CAST(_item_id AS INT),
     					                   "user_id", CAST(_user_id AS INT),
     					                   "created_at", _created_at));
     END IF;


  END LOOP;
  CLOSE versions_cursor;

  RETURN json;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `littlesis_test` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20180117165745'),
('20180117190400'),
('20180122192339'),
('20180123184642'),
('20180123192048'),
('20180124213412'),
('20180129193750'),
('20180312221213'),
('20180327200500'),
('20180328171242'),
('20180402151948'),
('20180404144759'),
('20180405165850'),
('20180405192653'),
('20180405204432'),
('20180409211819'),
('20180418185245'),
('20180424164740'),
('20180424165127'),
('20180424181848'),
('20180424203632'),
('20180425160916'),
('20180517154454'),
('20180522142905'),
('20180605184748'),
('20180813162356'),
('20180904145133'),
('20181008145444'),
('20181113153716'),
('20181120214543'),
('20181120220123'),
('20181121181644'),
('20181128230617'),
('20181204170212'),
('20181210213242'),
('20181212164901'),
('20181212195611'),
('20181218193802'),
('20181218211422'),
('20190102183459'),
('20190107194942'),
('20190122191600'),
('20190122195730'),
('20190123155951'),
('20190123164450'),
('20190123170130'),
('20190225182449'),
('20190305165817'),
('20190307135257'),
('20190403154559'),
('20190417191412'),
('20190423154920'),
('20190423181842'),
('20190423191048'),
('20190514141806'),
('20190514181827'),
('20190521205445'),
('20190529164312');


