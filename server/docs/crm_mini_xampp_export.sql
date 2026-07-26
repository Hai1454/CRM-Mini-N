-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: crm_mini_xampp
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `carehistory`
--

DROP TABLE IF EXISTS `carehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carehistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `staffId` int(11) DEFAULT NULL,
  `type` varchar(191) NOT NULL DEFAULT 'Call',
  `summary` varchar(191) NOT NULL,
  `result` varchar(191) DEFAULT NULL,
  `nextAction` varchar(191) DEFAULT NULL,
  `nextSchedule` datetime(3) DEFAULT NULL,
  `careDate` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `CareHistory_customerId_fkey` (`customerId`),
  KEY `CareHistory_staffId_fkey` (`staffId`),
  CONSTRAINT `CareHistory_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `CareHistory_staffId_fkey` FOREIGN KEY (`staffId`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carehistory`
--

LOCK TABLES `carehistory` WRITE;
/*!40000 ALTER TABLE `carehistory` DISABLE KEYS */;
INSERT INTO `carehistory` VALUES (4,5,5,'Call','Trao đổi yêu cầu quản lý thiết bị mạng.','Customer requested technical proposal.','Send technical proposal',NULL,'2026-07-19 14:26:20.631','2026-07-19 14:26:20.631','2026-07-19 14:26:20.631'),(5,4,5,'Meeting','Demo CRM Starter cho đội kinh doanh.','Customer is considering the starter package.','Confirm quotation',NULL,'2026-07-19 14:26:20.631','2026-07-19 14:26:20.631','2026-07-19 14:26:20.631'),(6,6,6,'Email','Gửi tài liệu tích hợp helpdesk.','Waiting for customer response.','Follow up next week',NULL,'2026-07-19 14:26:20.631','2026-07-19 14:26:20.631','2026-07-19 14:26:20.631');
/*!40000 ALTER TABLE `carehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `company` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `address` varchar(191) DEFAULT NULL,
  `customerType` varchar(191) NOT NULL DEFAULT 'Potential',
  `source` varchar(191) NOT NULL DEFAULT 'Website',
  `status` varchar(191) NOT NULL DEFAULT 'Lead',
  `note` varchar(191) DEFAULT NULL,
  `createdById` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Customer_email_key` (`email`),
  KEY `Customer_createdById_fkey` (`createdById`),
  CONSTRAINT `Customer_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (4,'Trần Thị Bình','FPT Telecom','binh.tran@example.com','0912345678','TP. Hồ Chí Minh','Purchased','Website','Completed','Cần demo hệ thống CRM nội bộ.',5,'2026-07-19 14:26:20.618','2026-07-19 14:27:54.652'),(5,'Nguyễn Văn An','Viettel Solutions','an.nguyen@example.com','0901234567','Hà Nội','Purchased','Conference','Customer','Quan tâm giải pháp quản lý thiết bị mạng.',5,'2026-07-19 14:26:20.618','2026-07-19 14:26:20.618'),(6,'Lê Minh Khoa','VNPT Technology','khoa.le@example.com','0987654321','Đà Nẵng','Potential','Referral','Prospect','Đang so sánh giá và tính năng.',6,'2026-07-19 14:26:20.618','2026-07-19 14:26:20.618');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customermanager`
--

DROP TABLE IF EXISTS `customermanager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customermanager` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `customerId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `CustomerManager_userId_customerId_key` (`userId`,`customerId`),
  KEY `CustomerManager_customerId_fkey` (`customerId`),
  CONSTRAINT `CustomerManager_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `CustomerManager_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customermanager`
--

LOCK TABLES `customermanager` WRITE;
/*!40000 ALTER TABLE `customermanager` DISABLE KEYS */;
INSERT INTO `customermanager` VALUES (4,5,5,'2026-07-19 14:26:20.622'),(5,5,4,'2026-07-19 14:26:20.622'),(6,6,6,'2026-07-19 14:26:20.622'),(7,7,6,'2026-07-19 14:27:24.724'),(8,7,4,'2026-07-19 14:27:24.724');
/*!40000 ALTER TABLE `customermanager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal`
--

DROP TABLE IF EXISTS `deal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `value` int(11) NOT NULL,
  `stage` varchar(191) NOT NULL DEFAULT 'New',
  `expectedAt` datetime(3) DEFAULT NULL,
  `customerId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Deal_customerId_fkey` (`customerId`),
  CONSTRAINT `Deal_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal`
--

LOCK TABLES `deal` WRITE;
/*!40000 ALTER TABLE `deal` DISABLE KEYS */;
INSERT INTO `deal` VALUES (4,'Goi CRM phong kinh doanh',45000000,'Won',NULL,5,'2026-07-19 14:26:20.633','2026-07-19 14:26:20.633'),(5,'Tich hop ticket helpdesk',28000000,'Negotiation',NULL,4,'2026-07-19 14:26:20.633','2026-07-19 14:26:20.633'),(6,'Dao tao van hanh CRM',15000000,'Proposal',NULL,6,'2026-07-19 14:26:20.633','2026-07-19 14:26:20.633');
/*!40000 ALTER TABLE `deal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(191) NOT NULL,
  `customerId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `staffId` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `total` int(11) NOT NULL,
  `paymentStatus` varchar(191) NOT NULL DEFAULT 'Unpaid',
  `status` varchar(191) NOT NULL DEFAULT 'Draft',
  `note` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Order_code_key` (`code`),
  KEY `Order_customerId_fkey` (`customerId`),
  KEY `Order_productId_fkey` (`productId`),
  KEY `Order_staffId_fkey` (`staffId`),
  CONSTRAINT `Order_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Order_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `Order_staffId_fkey` FOREIGN KEY (`staffId`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (4,'ORD-1003',6,5,7,1,18000000,'Paid','Completed','Báo giá sơ bộ.','2026-07-19 14:26:20.627','2026-07-19 14:28:07.174'),(5,'ORD-1002',4,4,5,2,24000000,'Unpaid','Processing','Chờ xác nhận lịch demo.','2026-07-19 14:26:20.627','2026-07-19 14:26:20.627'),(6,'ORD-1001',5,6,5,1,28000000,'Paid','Completed','Triển khai cho phòng kỹ thuật.','2026-07-19 14:26:20.627','2026-07-19 14:26:20.627');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orderdetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unitPrice` int(11) NOT NULL,
  `totalPrice` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `OrderDetail_orderId_fkey` (`orderId`),
  KEY `OrderDetail_productId_fkey` (`productId`),
  CONSTRAINT `OrderDetail_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `OrderDetail_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetail`
--

LOCK TABLES `orderdetail` WRITE;
/*!40000 ALTER TABLE `orderdetail` DISABLE KEYS */;
INSERT INTO `orderdetail` VALUES (5,5,4,2,12000000,24000000,'2026-07-19 14:26:20.627','2026-07-19 14:26:20.627'),(6,6,6,1,28000000,28000000,'2026-07-19 14:26:20.627','2026-07-19 14:26:20.627'),(7,4,5,1,18000000,18000000,'2026-07-19 14:28:07.174','2026-07-19 14:28:07.174');
/*!40000 ALTER TABLE `orderdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `sku` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL,
  `price` int(11) NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'Active',
  `description` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Product_sku_key` (`sku`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (4,'CRM Starter Package','CRM-STARTER','Software',12000000,'Active','Basic CRM setup for a small sales team.','2026-07-19 14:26:20.623','2026-07-19 14:26:20.623'),(5,'Helpdesk Integration','HELPDESK','Service',18000000,'Active','Support ticket and care history integration.','2026-07-19 14:26:20.623','2026-07-19 14:26:20.623'),(6,'Network Device Management','NET-MGMT','Service',28000000,'Active','Device inventory and monitoring module.','2026-07-19 14:26:20.623','2026-07-19 14:26:20.623');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(191) NOT NULL,
  `priority` varchar(191) NOT NULL DEFAULT 'Medium',
  `status` varchar(191) NOT NULL DEFAULT 'Open',
  `description` varchar(191) DEFAULT NULL,
  `customerId` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Ticket_customerId_fkey` (`customerId`),
  CONSTRAINT `Ticket_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
INSERT INTO `ticket` VALUES (4,'Can cap lai tai khoan nhan vien','High','Open',NULL,5,'2026-07-19 14:26:20.634','2026-07-19 14:26:20.634'),(5,'Hoi ve tich hop email','Medium','In Progress',NULL,4,'2026-07-19 14:26:20.634','2026-07-19 14:26:20.634'),(6,'Yeu cau bao cao doanh thu','Low','Closed',NULL,6,'2026-07-19 14:26:20.634','2026-07-19 14:26:20.634');
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(191) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `role` varchar(191) NOT NULL DEFAULT 'STAFF',
  `phone` varchar(191) DEFAULT NULL,
  `title` varchar(191) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'ACTIVE',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`),
  UNIQUE KEY `User_username_key` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (4,'admin','System Administrator','admin@crm.local','$2a$10$odPvIqIjYf.FhipA9NJhmeUMuGzLvEq0xW7ik3AuxYk7ZWYmjeg1K','ADMIN','0900000000','CRM Admin','ACTIVE','2026-07-19 14:26:20.549','2026-07-19 14:26:20.549'),(5,'minhanh','Nguyễn Minh Anh','minhanh@crm.local','$2a$10$OxdeofP70O1RR4n1KcOBruAW/TdhCkIOFaS4myThZQgYEYZiVYL5C','STAFF','0911111111','Sales Executive','ACTIVE','2026-07-19 14:26:20.615','2026-07-19 14:26:20.615'),(6,'quocbao','Trần Quốc Bảo','quocbao@crm.local','$2a$10$OxdeofP70O1RR4n1KcOBruAW/TdhCkIOFaS4myThZQgYEYZiVYL5C','STAFF','0922222222','Customer Support','ACTIVE','2026-07-19 14:26:20.616','2026-07-19 14:26:20.616'),(7,'haivh','Vương Hoàng Hải','haivh@crm.local','$2a$10$cYHzyHBqZF45OpXkkAvVUOEkeiTAjrDzx2jajoUQtA//pXcD11odq','STAFF','03754845621','Sale','ACTIVE','2026-07-19 14:27:24.720','2026-07-19 14:27:24.720');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'crm_mini_xampp'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-20  0:13:34
