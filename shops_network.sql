-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 21, 2018 at 09:36 AM
-- Server version: 5.6.41
-- PHP Version: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shops_network`
--
CREATE DATABASE IF NOT EXISTS `shops_network` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `shops_network`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_log`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_log` (IN `new_header` VARCHAR(50), IN `new_params` TEXT)  NO SQL
BEGIN
	INSERT INTO `logs` (`datetime`, `header`, `params`)
    VALUES (NOW(), `new_header`, `new_params`);
END$$

DROP PROCEDURE IF EXISTS `clear_contracts_products`$$
CREATE DEFINER=`root`@`%` PROCEDURE `clear_contracts_products` (IN `contract` INT UNSIGNED)  BEGIN
	DELETE FROM `contract_products` WHERE `contract_id` = contract;
        CALL `add_log`('clear_contracts_products', CONCAT('contract_id = ', contract));
END$$

DROP PROCEDURE IF EXISTS `clear_provider_products`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `clear_provider_products` (IN `provider` INT)  BEGIN
        DELETE FROM `provider_products` WHERE `provider_id` = provider;
        CALL `add_log`('clear_provider_products', CONCAT('provider_id = ', provider));
END$$

DROP PROCEDURE IF EXISTS `conclude_contract`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `conclude_contract` (IN `contract` INT, IN `product` INT)  BEGIN 
	INSERT INTO contract_products VALUES (contract, product);
    CALL `add_log`('conclude_contract', CONCAT('contract_id = ', contract, ', product_id = ', product));
END$$

DROP PROCEDURE IF EXISTS `create_contract`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_contract` (IN `provider` INT UNSIGNED, IN `author` INT UNSIGNED, IN `shop` INT UNSIGNED, IN `ca` DATE, IN `deadline` DATE)  BEGIN
INSERT INTO `contracts` (`provider_id`, `author_id`, `shop_id`, `created_at`, `deadline`) 
VALUES (
provider, 
author, 
shop, 
ca,
deadline
);
    CALL `add_log`('create_contract', 
                   CONCAT('provider_id = ', provider, 
                          ', author_id = ', author, 
                          ', shop_id = ', shop,
                          ', created_at = ', ca,
                          ', deadline = ', deadline));

END$$

DROP PROCEDURE IF EXISTS `create_product`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_product` (IN `name` VARCHAR(100) CHARSET utf8mb4, IN `cost` DECIMAL, IN `manufacture_date` DATE)  BEGIN
INSERT INTO `products` (`name`, `cost`, `manufacture_date`) VALUES (name, cost, manufacture_date);
CALL `add_log`('create_product', 
                   CONCAT('name = ', name, 
                          ', cost = ', cost, 
                          ', manufacture_date = ', manufacture_date));
END$$

DROP PROCEDURE IF EXISTS `create_provider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_provider` (IN `name` VARCHAR(100), IN `address` VARCHAR(255), IN `bank` VARCHAR(100), IN `phone` VARCHAR(20))  BEGIN
INSERT INTO providers (`name`, `legal_address`, `bank_account`, `contact_phone`) VALUES (name, address, bank, phone);
    CALL `add_log`('create_provider', 
                   CONCAT('name = ', name, 
                          ', legal_address = ', address, 
                          ', bank_account = ', bank,
                          ', phone = ', phone));

END$$

DROP PROCEDURE IF EXISTS `create_shop`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_shop` (IN `name` VARCHAR(100), IN `address` VARCHAR(255), IN `bank` VARCHAR(100), IN `phone` VARCHAR(20))  BEGIN
INSERT INTO shops (`name`, `address`, `bank_account`, `contact_phone`) VALUES (name, address, bank, phone);
    CALL `add_log`('create_shop', 
                   CONCAT('name = ', name, 
                          ', address = ', address, 
                          ', bank_account = ', bank,
                          ', contact_phone = ', phone));


END$$

DROP PROCEDURE IF EXISTS `create_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user` (IN `email` VARCHAR(100) CHARSET utf8, IN `pass` VARCHAR(100) CHARSET utf8mb4, IN `fname` VARCHAR(50) CHARSET utf8mb4, IN `lname` VARCHAR(50) CHARSET utf8mb4, IN `phone` VARCHAR(20) CHARSET utf8mb4, IN `role` INT UNSIGNED)  BEGIN
INSERT INTO `users` (`email`, `password`, `first_name`, `last_name`, `phone`, `role_id`) VALUES (email, pass, fname, lname, phone, role);
    CALL `add_log`('create_user', 
                   CONCAT('email = ', email, 
                          ', password = ', pass, 
                          ', first_name = ', fname,
                          ', last_name = ', lname,
                          ', phone = ', phone,
                          ', role_id = ', role));

END$$

DROP PROCEDURE IF EXISTS `drop_contract`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `drop_contract` (IN `identity` INT UNSIGNED)  BEGIN
	DELETE FROM contracts WHERE `id` = identity;
    CALL `add_log`('drop_contract', 
                   CONCAT('id = ', identity));
END$$

DROP PROCEDURE IF EXISTS `drop_product`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `drop_product` (IN `identity` INT UNSIGNED)  BEGIN
	DELETE FROM products WHERE `id` = identity;
    CALL `add_log`('drop_product', 
                   CONCAT('id = ', identity));
END$$

DROP PROCEDURE IF EXISTS `drop_provider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `drop_provider` (IN `identity` INT UNSIGNED)  BEGIN
	DELETE FROM providers WHERE `id` = identity;
    CALL `add_log`('drop_provider', 
                   CONCAT('id = ', identity));
END$$

DROP PROCEDURE IF EXISTS `drop_shop`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `drop_shop` (IN `identity` INT UNSIGNED)  BEGIN
	DELETE FROM shops WHERE `id` = identity;
    CALL `add_log`('drop_shop', 
                   CONCAT('id = ', identity));
END$$

DROP PROCEDURE IF EXISTS `drop_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `drop_user` (IN `identity` INT)  BEGIN
	DELETE FROM `users` WHERE `id` = identity;
    CALL `add_log`('drop_user', 
                   CONCAT('id = ', identity));
END$$

DROP PROCEDURE IF EXISTS `edit_contract`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_contract` (IN `provider` INT, IN `author` INT, IN `shop` INT, IN `ca` DATE, IN `deadline` DATE, IN `identity` INT UNSIGNED)  BEGIN 
UPDATE contracts SET
`provider_id` = provider, 
`author_id` = author, 
`shop_id` = shop, 
`created_at` = ca,
`deadline` = deadline
WHERE `id` = identity;

		CALL `add_log`('edit_contract', 
                   CONCAT('id = ', identity,
                          ', provider_id = ', provider, 
                          ', author_id = ', author, 
                          ', shop_id = ', shop,
                          ', created_at = ', ca,
                          ', deadline = ', deadline));
END$$

DROP PROCEDURE IF EXISTS `edit_product`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_product` (IN `name` VARCHAR(100) CHARSET utf8mb4, IN `cost` DECIMAL, IN `manufacture_date` DATE, IN `identity` INT UNSIGNED)  BEGIN 
UPDATE `products` SET `name` = name, `cost` = cost, `manufacture_date` = manufacture_date WHERE `id` = identity;

CALL `add_log`('edit_product', 
                   CONCAT('id = ', identity,
                       	  ', name = ', name, 
                          ', cost = ', cost, 
                          ', manufacture_date = ', manufacture_date));
END$$

DROP PROCEDURE IF EXISTS `edit_provider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_provider` (IN `name` VARCHAR(100), IN `address` VARCHAR(255), IN `bank` VARCHAR(100), IN `phone` VARCHAR(20), IN `identity` INT UNSIGNED)  BEGIN 
UPDATE providers SET `name` = name, `legal_address` = address, `bank_account` = bank, `contact_phone` = phone WHERE `id` = identity;

CALL `add_log`('edit_provider', 
                   CONCAT('id = ', identity,
                       	  ', name = ', name, 
                          ', legal_address = ', address, 
                          ', bank_account = ', bank,
                          ', contact_phone = ', phone));
END$$

DROP PROCEDURE IF EXISTS `edit_shop`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_shop` (IN `name` VARCHAR(100), IN `address` VARCHAR(255), IN `bank` VARCHAR(100), IN `phone` VARCHAR(20), IN `identity` INT UNSIGNED)  BEGIN 
UPDATE shops SET `name` = name, `address` = address, `bank_account` = bank, `contact_phone` = phone WHERE `id` = identity;

CALL `add_log`('edit_shop', 
                   CONCAT('id = ', identity,
                       	  ', name = ', name, 
                          ', address = ', address, 
                          ', bank_account = ', bank,
                          ', contact_phone = ', phone));
END$$

DROP PROCEDURE IF EXISTS `edit_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_user` (IN `email` VARCHAR(100) CHARSET utf8mb4, IN `pass` VARCHAR(255) CHARSET utf8mb4, IN `fname` VARCHAR(50) CHARSET utf8mb4, IN `lname` VARCHAR(50) CHARSET utf8mb4, IN `phone` VARCHAR(20) CHARSET utf8mb4, IN `role` TINYINT UNSIGNED, IN `identity` INT)  BEGIN 
UPDATE `users` SET `email` = email, `password` = pass, `first_name` = fname, `last_name` = lname, `phone` = phone, `role_id` = role WHERE `id` = identity;


CALL `add_log`('edit_user', 
                   CONCAT('id = ', identity,
                       	  ', email = ', email, 
                          ', password = ', pass, 
                          ', first_name = ', fname,
                          ', last_name = ', lname,
                          ', phone = ', phone,
                          ', role_id = ', role));
END$$

DROP PROCEDURE IF EXISTS `refresh_contracts_products`$$
CREATE DEFINER=`root`@`%` PROCEDURE `refresh_contracts_products` (IN `product` INT UNSIGNED, IN `contract` INT UNSIGNED)  BEGIN
   IF NOT EXISTS(SELECT (1) FROM `contract_products` WHERE `product_id` = product AND `contract_id` = contract) THEN 
      INSERT INTO `contract_products` (`product_id`, `contract_id`) VALUES(product, contract);
      CALL `add_log`('refresh_contracts_products', CONCAT('product_id = ', product, ', contract_id = ', contract));
   END IF;
END$$

DROP PROCEDURE IF EXISTS `refresh_providers_products`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `refresh_providers_products` (IN `product` INT UNSIGNED, IN `provider` INT UNSIGNED)  BEGIN
   IF NOT EXISTS(SELECT (1) FROM `provider_products` WHERE `product_id` = product AND `provider_id` = provider) THEN 
      INSERT INTO `provider_products` (`product_id`, `provider_id`) VALUES(product, provider);
      CALL `add_log`('refresh_providers_products', CONCAT('product_id = ', product, ', provider_id = ', provider));
   END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
CREATE TABLE IF NOT EXISTS `contracts` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор договора',
  `provider_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'идентификатор поставщика',
  `author_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'идентификатор заключителя',
  `shop_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'идентификатор продукта',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deadline` date NOT NULL COMMENT 'срок выполнения',
  PRIMARY KEY (`id`),
  KEY `contracts_provider_id_foreign` (`provider_id`),
  KEY `contracts_author_id_foreign` (`author_id`),
  KEY `contracts_shop_id_foreign` (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contracts`
--

INSERT INTO `contracts` (`id`, `provider_id`, `author_id`, `shop_id`, `created_at`, `updated_at`, `deadline`) VALUES
(2, 1, 1, 2, '2018-11-13 20:00:00', NULL, '2018-11-21'),
(3, 3, 5, 2, '2018-12-17 20:00:00', NULL, '2018-12-30'),
(4, 1, 5, 2, '2018-12-19 20:00:00', NULL, '2018-12-26');

-- --------------------------------------------------------

--
-- Table structure for table `contract_products`
--

DROP TABLE IF EXISTS `contract_products`;
CREATE TABLE IF NOT EXISTS `contract_products` (
  `contract_id` int(10) UNSIGNED NOT NULL COMMENT 'идентификатор договора',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT 'идентификатор продукта',
  UNIQUE KEY `contract_id` (`contract_id`,`product_id`),
  KEY `contract_products_contract_id_foreign` (`contract_id`),
  KEY `contract_products_product_id_foreign` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contract_products`
--

INSERT INTO `contract_products` (`contract_id`, `product_id`) VALUES
(2, 1),
(3, 4),
(4, 1),
(4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `datetime` datetime NOT NULL,
  `header` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `params` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`datetime`, `header`, `params`) VALUES
('2018-12-19 16:11:52', 'edit_contract', 'id = 1, provider_id = 1, author_id = 1, shop_id = 1, created_at = 2018-11-12, deadline = 2018-11-14'),
('2018-12-19 16:11:52', 'clear_contracts_products', 'contract_id = 1'),
('2018-12-19 16:11:52', 'refresh_contracts_products', 'product_id = 2, contract_id = 1'),
('2018-12-19 16:11:52', 'refresh_contracts_products', 'product_id = 1, contract_id = 1'),
('2018-12-19 16:12:27', 'drop_contract', 'id = 1'),
('2018-12-19 16:13:13', 'edit_contract', 'id = 2, provider_id = 1, author_id = 1, shop_id = 2, created_at = 2018-11-14, deadline = 2018-11-21'),
('2018-12-19 16:13:13', 'clear_contracts_products', 'contract_id = 2'),
('2018-12-19 16:13:13', 'refresh_contracts_products', 'product_id = 1, contract_id = 2'),
('2018-12-19 16:13:13', 'refresh_contracts_products', 'product_id = 3, contract_id = 2'),
('2018-12-19 16:13:13', 'refresh_contracts_products', 'product_id = 4, contract_id = 2'),
('2018-12-19 16:14:09', 'create_contract', 'provider_id = 3, author_id = 5, shop_id = 2, created_at = 2018-12-18, deadline = 2018-12-30'),
('2018-12-19 16:14:09', 'refresh_contracts_products', 'product_id = 1, contract_id = 3'),
('2018-12-19 16:14:09', 'refresh_contracts_products', 'product_id = 3, contract_id = 3'),
('2018-12-19 16:14:09', 'refresh_contracts_products', 'product_id = 4, contract_id = 3'),
('2018-12-19 16:16:52', 'edit_contract', 'id = 3, provider_id = 3, author_id = 5, shop_id = 2, created_at = 2018-12-18, deadline = 2018-12-30'),
('2018-12-19 16:16:52', 'clear_contracts_products', 'contract_id = 3'),
('2018-12-19 16:16:52', 'refresh_contracts_products', 'product_id = 4, contract_id = 3'),
('2018-12-19 17:46:29', 'edit_contract', 'id = 2, provider_id = 1, author_id = 1, shop_id = 2, created_at = 2018-11-14, deadline = 2018-11-21'),
('2018-12-19 17:46:29', 'clear_contracts_products', 'contract_id = 2'),
('2018-12-19 17:46:29', 'refresh_contracts_products', 'product_id = 1, contract_id = 2'),
('2018-12-19 17:46:29', 'refresh_contracts_products', 'product_id = 1, contract_id = 2'),
('2018-12-19 17:46:29', 'refresh_contracts_products', 'product_id = 1, contract_id = 2'),
('2018-12-20 21:53:59', 'edit_contract', 'id = 2, provider_id = 1, author_id = 1, shop_id = 2, created_at = 2018-11-14, deadline = 2018-11-21'),
('2018-12-20 21:53:59', 'clear_contracts_products', 'contract_id = 2'),
('2018-12-20 21:53:59', 'refresh_contracts_products', 'product_id = 1, contract_id = 2'),
('2018-12-20 21:56:54', 'create_contract', 'provider_id = 1, author_id = 5, shop_id = 2, created_at = 2018-12-20, deadline = 2018-12-26'),
('2018-12-20 21:57:33', 'edit_contract', 'id = 4, provider_id = 1, author_id = 5, shop_id = 2, created_at = 2018-12-20, deadline = 2018-12-26'),
('2018-12-20 21:57:33', 'clear_contracts_products', 'contract_id = 4'),
('2018-12-20 21:57:33', 'refresh_contracts_products', 'product_id = 1, contract_id = 4'),
('2018-12-20 21:58:43', 'edit_provider', 'id = 1, name = ООО Наебалово, legal_address = Пушкина, дом Колотушкина, bank_account = 123934243, contact_phone = 134845237'),
('2018-12-20 21:58:43', 'clear_provider_products', 'provider_id = 1'),
('2018-12-20 21:58:43', 'refresh_providers_products', 'product_id = 1, provider_id = 1'),
('2018-12-20 21:58:44', 'refresh_providers_products', 'product_id = 2, provider_id = 1'),
('2018-12-20 21:58:44', 'refresh_providers_products', 'product_id = 3, provider_id = 1'),
('2018-12-20 21:58:44', 'refresh_providers_products', 'product_id = 4, provider_id = 1'),
('2018-12-20 22:01:19', 'edit_contract', 'id = 4, provider_id = 1, author_id = 5, shop_id = 2, created_at = 2018-12-20, deadline = 2018-12-26'),
('2018-12-20 22:01:19', 'clear_contracts_products', 'contract_id = 4'),
('2018-12-20 22:01:20', 'refresh_contracts_products', 'product_id = 1, contract_id = 4'),
('2018-12-20 22:01:20', 'refresh_contracts_products', 'product_id = 2, contract_id = 4'),
('2018-12-20 22:01:20', 'refresh_contracts_products', 'product_id = 4, contract_id = 4'),
('2018-12-20 22:38:53', 'edit_contract', 'id = 4, provider_id = 1, author_id = 5, shop_id = 2, created_at = 2018-12-20, deadline = 2018-12-26'),
('2018-12-20 22:38:53', 'clear_contracts_products', 'contract_id = 4'),
('2018-12-20 22:38:53', 'refresh_contracts_products', 'product_id = 1, contract_id = 4'),
('2018-12-20 22:38:53', 'refresh_contracts_products', 'product_id = 2, contract_id = 4'),
('2018-12-20 22:38:53', 'refresh_contracts_products', 'product_id = 4, contract_id = 4'),
('2018-12-20 22:38:53', 'refresh_contracts_products', 'product_id = 4, contract_id = 4'),
('2018-12-20 22:40:42', 'edit_contract', 'id = 4, provider_id = 1, author_id = 5, shop_id = 2, created_at = 2018-12-20, deadline = 2018-12-26'),
('2018-12-20 22:40:42', 'clear_contracts_products', 'contract_id = 4'),
('2018-12-20 22:40:42', 'refresh_contracts_products', 'product_id = 1, contract_id = 4'),
('2018-12-20 22:40:42', 'refresh_contracts_products', 'product_id = 1, contract_id = 4'),
('2018-12-20 22:40:42', 'refresh_contracts_products', 'product_id = 4, contract_id = 4'),
('2018-12-20 22:40:42', 'refresh_contracts_products', 'product_id = 4, contract_id = 4'),
('2018-12-20 22:42:32', 'edit_contract', 'id = 4, provider_id = 1, author_id = 5, shop_id = 2, created_at = 2018-12-20, deadline = 2018-12-26'),
('2018-12-20 22:42:32', 'clear_contracts_products', 'contract_id = 4'),
('2018-12-20 22:42:32', 'refresh_contracts_products', 'product_id = 1, contract_id = 4'),
('2018-12-20 22:42:32', 'refresh_contracts_products', 'product_id = 4, contract_id = 4'),
('2018-12-20 22:46:53', 'edit_provider', 'id = 3, name = Новый магический бубальгам, legal_address = МаскваСити, bank_account = 1256857412569874, contact_phone = +78984564225'),
('2018-12-20 22:46:53', 'clear_provider_products', 'provider_id = 3'),
('2018-12-20 22:46:54', 'edit_provider', 'id = 3, name = Новый магический бубальгам, legal_address = МаскваСити, bank_account = 1256857412569874, contact_phone = +78984564225'),
('2018-12-20 22:46:54', 'clear_provider_products', 'provider_id = 3'),
('2018-12-20 22:48:22', 'edit_provider', 'id = 3, name = Новый магический бубальгам, legal_address = МаскваСити, bank_account = 1256857412569874, contact_phone = +78984564225'),
('2018-12-20 22:48:22', 'clear_provider_products', 'provider_id = 3'),
('2018-12-20 22:51:09', 'edit_provider', 'id = 3, name = Новый магический бубальгам, legal_address = МаскваСити, bank_account = 1256857412569874, contact_phone = +78984564225'),
('2018-12-20 22:51:09', 'clear_provider_products', 'provider_id = 3'),
('2018-12-20 22:51:09', 'refresh_providers_products', 'product_id = 2, provider_id = 3'),
('2018-12-20 22:51:25', 'edit_provider', 'id = 3, name = Новый магический бубальгам, legal_address = МаскваСити, bank_account = 1256857412569874, contact_phone = +78984564225'),
('2018-12-20 22:51:25', 'clear_provider_products', 'provider_id = 3'),
('2018-12-20 22:51:25', 'refresh_providers_products', 'product_id = 2, provider_id = 3'),
('2018-12-21 02:44:15', 'create_provider', 'name = wergfh, legal_address = 2q3w4ert6yu, bank_account = q3w4e5r6tyu, phone = 3w4erty'),
('2018-12-21 02:44:22', 'drop_provider', 'id = 4'),
('2018-12-21 04:03:40', 'create_provider', 'name = ООО Наебалов, legal_address = йцукенгшщ, bank_account = 12345678, phone = 123465789'),
('2018-12-21 04:19:41', 'create_shop', 'name = ХуйняХуйня, address = цукенгшщззщшг, bank_account = 123654789, contact_phone = 513215621'),
('2018-12-21 04:20:13', 'create_provider', 'name = Что-то и Кто-то, legal_address = гцуеншлгжщпрасдл, bank_account = 123654789, phone = 4654652168764'),
('2018-12-21 04:24:04', 'drop_provider', 'id = 6'),
('2018-12-21 04:25:09', 'create_shop', 'name = werdtfyghujkijh, address = wertyuiop[;lknb, bank_account = 123684789, contact_phone = 84568456'),
('2018-12-21 04:38:34', 'create_provider', 'name = Хуеплётов тим, legal_address = цуквеапролб, bank_account = 123654789, phone = 435678'),
('2018-12-21 04:38:34', 'refresh_providers_products', 'product_id = 4, provider_id = 7'),
('2018-12-21 04:42:17', 'create_shop', 'name = Yjdsq [eq, address = esrtdfygjukhijok, bank_account = 78678645, contact_phone = 575345345'),
('2018-12-21 04:50:32', 'edit_provider', 'id = 7, name = Хуеплётов тим, legal_address = цуквеапролб, bank_account = 123654789, contact_phone = 435678'),
('2018-12-21 04:50:32', 'clear_provider_products', 'provider_id = 7'),
('2018-12-21 04:50:32', 'refresh_providers_products', 'product_id = 4, provider_id = 7'),
('2018-12-21 04:51:09', 'create_provider', 'name = ООО Наебало, legal_address = йцукенгшщз, bank_account = 213456789, phone = 76543'),
('2018-12-21 04:56:18', 'edit_shop', 'id = 2, name = Нормальное название, address = Йцукенг уекнрол, bank_account = 87458956987456, contact_phone = +98745698569854'),
('2018-12-21 04:56:38', 'create_shop', 'name = Не очень, address = ыкунвещошлзд, bank_account = 3748327568904323, contact_phone = 487943589'),
('2018-12-21 04:57:28', 'create_user', 'email = theproteks.gamer@gmail.com, password = $2y$10$sDRFwtOTJWkOHwHDlpWLT.3TcEXviSNoUZXkZQpb677bP9MqobP4G, first_name = Евгений, last_name = Смирнов, phone = +79020498442, role_id = 1'),
('2018-12-21 04:58:15', 'edit_user', 'id = 6, email = theproteks.gamer@gmail.com, password = $2y$10$TNoW03m/jiGpBTh4bDIcK.7Y9U1HJk/SiIPiZuiqKuW9pE2vLfqC2, first_name = Хуй, last_name = С Горы, phone = +79020498442, role_id = 1'),
('2018-12-21 04:58:24', 'drop_user', 'id = 6');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(69, '2014_10_12_000000_create_users_table', 1),
(70, '2018_11_08_183015_create_roles_table', 1),
(71, '2018_11_08_183050_create_products_table', 1),
(72, '2018_11_08_183104_create_contracts_table', 1),
(73, '2018_11_08_183132_create_shops_table', 1),
(74, '2018_11_08_183145_create_providers_table', 1),
(75, '2018_11_08_183219_create_provider_products_table', 1),
(76, '2018_11_08_183246_create_contract_products_table', 1),
(77, '2018_11_08_185809_create_products_contracts_fk', 1),
(78, '2018_11_08_185828_create_products_providers_fk', 1),
(79, '2018_11_08_185848_create_contracts_fk', 1),
(80, '2018_11_08_185912_create_user_fk', 1),
(81, '2018_11_13_160007_fill_roles_table', 1),
(83, '2018_11_21_104827_create_superuser', 2);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор продукта',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'наименование продукта',
  `cost` decimal(8,2) NOT NULL COMMENT 'цена',
  `manufacture_date` date NOT NULL COMMENT 'дата производства',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `cost`, `manufacture_date`) VALUES
(1, 'Помидор', '120.00', '2018-11-20'),
(2, 'Лук', '11.00', '2018-11-17'),
(3, 'Арбуз', '1000.00', '2018-11-14'),
(4, 'Йцукен', '1488.00', '2018-12-14');

-- --------------------------------------------------------

--
-- Table structure for table `providers`
--

DROP TABLE IF EXISTS `providers`;
CREATE TABLE IF NOT EXISTS `providers` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор поставщика',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'наименование поставщика',
  `legal_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'юридический адрес',
  `bank_account` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'банковский счёт',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'контактный номер телефона',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bank_account` (`bank_account`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `providers`
--

INSERT INTO `providers` (`id`, `name`, `legal_address`, `bank_account`, `contact_phone`) VALUES
(1, 'ООО Наебалово', 'Пушкина, дом Колотушкина', '123934243', '134845237'),
(3, 'Новый магический бубальгам', 'МаскваСити', '1256857412569874', '+78984564225'),
(5, 'ООО Наебалов', 'йцукенгшщ', '12345678', '123465789'),
(7, 'Хуеплётов тим', 'цуквеапролб', '123654789', '435678'),
(8, 'ООО Наебало', 'йцукенгшщз', '213456789', '76543');

-- --------------------------------------------------------

--
-- Table structure for table `provider_products`
--

DROP TABLE IF EXISTS `provider_products`;
CREATE TABLE IF NOT EXISTS `provider_products` (
  `product_id` int(10) UNSIGNED NOT NULL COMMENT 'идентификатор продукта',
  `provider_id` int(10) UNSIGNED NOT NULL COMMENT 'идентификатор поставщика',
  UNIQUE KEY `product_id` (`product_id`,`provider_id`),
  KEY `provider_products_product_id_foreign` (`product_id`),
  KEY `provider_products_provider_id_foreign` (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `provider_products`
--

INSERT INTO `provider_products` (`product_id`, `provider_id`) VALUES
(1, 1),
(2, 1),
(2, 3),
(3, 1),
(4, 1),
(4, 7);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор роли',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'наименование роли',
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'псевдоним роли',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`) VALUES
(1, 'Администратор', 'admin'),
(2, 'Менеджер', 'manager');

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

DROP TABLE IF EXISTS `shops`;
CREATE TABLE IF NOT EXISTS `shops` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор магазина',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'наименование магазина',
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'адрес',
  `bank_account` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'банковский счёт',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'контактный номер телефона',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bank_account` (`bank_account`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `name`, `address`, `bank_account`, `contact_phone`) VALUES
(2, 'Нормальное название', 'Йцукенг уекнрол', '87458956987456', '+98745698569854'),
(3, 'ХуйняХуйня', 'цукенгшщззщшг', '123654789', '513215621'),
(4, 'werdtfyghujkijh', 'wertyuiop[;lknb', '123684789', '84568456'),
(5, 'Yjdsq [eq', 'esrtdfygjukhijok', '78678645', '575345345'),
(6, 'Не очень', 'ыкунвещошлзд', '3748327568904323', '487943589');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор пользователя',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'электронная почта',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'пароль',
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'имя',
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'фамилия',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'номер телефона',
  `role_id` int(10) UNSIGNED NOT NULL COMMENT 'идентификатор роли',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_role_id_foreign` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `first_name`, `last_name`, `phone`, `role_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'user@mail.ru', '$2y$10$QDHfqhiJoaVQLpVOvSkKJueObP7EEtks4SEKZyAzT9GV/Wd8N4BkK', 'Дмитрий', 'Сапега', '+79123456565', 1, 'qZdjJ5C4tB2tPymjigdmTN0LGiv2Gv01GffFfupdo6WdmoXk4cPdFYhLegxC', NULL, NULL),
(5, 'admin@info.world', '$2y$10$dCNR/tqpnlrcA2wB8u6akuhkm3ABzYgvhdvuck4nC7NB/pIjThNFO', 'Админ', 'Главный', '+79876543321', 1, '22gco76a3wOSBIXiJdIHOP2Q50StPv4cB73VUyJpIdYFiV2bZpzZ6G3FdiW0', NULL, NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contracts`
--
ALTER TABLE `contracts`
  ADD CONSTRAINT `contracts_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `contracts_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `contracts_shop_id_foreign` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `contract_products`
--
ALTER TABLE `contract_products`
  ADD CONSTRAINT `contract_products_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `contract_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_products`
--
ALTER TABLE `provider_products`
  ADD CONSTRAINT `provider_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `provider_products_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
