-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3309
-- Generation Time: Jun 15, 2022 at 05:12 AM
-- Server version: 5.7.31
-- PHP Version: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql_rekayasa`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `Detail_transaksi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Detail_transaksi` (`noresi` VARCHAR(100))  BEGIN
  select kurir.ekspedisi as kurir,user.alamat,payment_method.payment as metode_pembayaran,barang.harga, header_transaksi.diskon, header_transaksi.asuransi_kirim, header_transaksi.proteksi, SUM(barang.harga+kurir.harga+header_transaksi.asuransi_kirim+header_transaksi.proteksi-header_transaksi.diskon) as TOTAL_BELANJA from header_transaksi, payment_method , user , kurir , barang WHERE header_transaksi.No_resi=noresi;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

DROP TABLE IF EXISTS `barang`;
CREATE TABLE IF NOT EXISTS `barang` (
  `id_barang` int(11) NOT NULL AUTO_INCREMENT,
  `id_kategori` int(11) NOT NULL,
  `nama_barang` varchar(30) NOT NULL,
  `harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL,
  PRIMARY KEY (`id_barang`),
  KEY `id_kategori` (`id_kategori`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `id_kategori`, `nama_barang`, `harga`, `stok`) VALUES
(2, 2, 'TPLINK TLWR840N', 370000, 3);

-- --------------------------------------------------------

--
-- Table structure for table `header_transaksi`
--

DROP TABLE IF EXISTS `header_transaksi`;
CREATE TABLE IF NOT EXISTS `header_transaksi` (
  `id_transaksi` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `No_resi` varchar(35) DEFAULT NULL,
  `id_kurir` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `jumlah_beli` int(11) DEFAULT NULL,
  `id_payment` int(11) NOT NULL,
  `diskon` int(11) NOT NULL,
  `asuransi_kirim` int(11) NOT NULL,
  `proteksi` int(11) NOT NULL,
  PRIMARY KEY (`id_transaksi`),
  UNIQUE KEY `No_resi` (`No_resi`),
  KEY `fk_userr` (`id_user`),
  KEY `fk_kurirr` (`id_kurir`),
  KEY `fk_barangg` (`id_barang`),
  KEY `fk_payy` (`id_payment`),
  KEY `nama_idx_tr_penj1` (`id_kurir`,`id_user`,`id_payment`,`id_transaksi`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `header_transaksi`
--

INSERT INTO `header_transaksi` (`id_transaksi`, `id_user`, `No_resi`, `id_kurir`, `id_barang`, `jumlah_beli`, `id_payment`, `diskon`, `asuransi_kirim`, `proteksi`) VALUES
(8, 2, '1000320545138', 2, 2, 2, 2, 10000, 1900, 14334);

--
-- Triggers `header_transaksi`
--
DROP TRIGGER IF EXISTS `stok_barang_kurang_After_beli`;
DELIMITER $$
CREATE TRIGGER `stok_barang_kurang_After_beli` AFTER INSERT ON `header_transaksi` FOR EACH ROW UPDATE barang SET barang.stok = barang.stok - new.jumlah_beli WHERE barang.id_barang = new.id_barang
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kategori_barang`
--

DROP TABLE IF EXISTS `kategori_barang`;
CREATE TABLE IF NOT EXISTS `kategori_barang` (
  `id_kategori` int(11) NOT NULL AUTO_INCREMENT,
  `kategori` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_kategori`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kategori_barang`
--

INSERT INTO `kategori_barang` (`id_kategori`, `kategori`) VALUES
(2, 'PERANGKAT KERAS');

-- --------------------------------------------------------

--
-- Table structure for table `kurir`
--

DROP TABLE IF EXISTS `kurir`;
CREATE TABLE IF NOT EXISTS `kurir` (
  `id_kurir` int(11) NOT NULL AUTO_INCREMENT,
  `ekspedisi` varchar(30) NOT NULL,
  `jenis_ekspedisi` varchar(30) NOT NULL,
  `harga` int(11) NOT NULL,
  `status` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id_kurir`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kurir`
--

INSERT INTO `kurir` (`id_kurir`, `ekspedisi`, `jenis_ekspedisi`, `harga`, `status`) VALUES
(2, 'JNT', 'EXPRESS', 10000, '1');

-- --------------------------------------------------------

--
-- Table structure for table `payment_method`
--

DROP TABLE IF EXISTS `payment_method`;
CREATE TABLE IF NOT EXISTS `payment_method` (
  `id_payment` int(11) NOT NULL AUTO_INCREMENT,
  `payment` varchar(30) NOT NULL,
  PRIMARY KEY (`id_payment`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payment_method`
--

INSERT INTO `payment_method` (`id_payment`, `payment`) VALUES
(2, 'BNI VIRTUAL ACCOUNT');

-- --------------------------------------------------------

--
-- Stand-in structure for view `pemakai_jasa`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `pemakai_jasa`;
CREATE TABLE IF NOT EXISTS `pemakai_jasa` (
`nama` varchar(30)
,`alamat` text
,`ekspedisi` varchar(30)
,`jenis_ekspedisi` varchar(30)
);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(30) NOT NULL,
  `jenis_kelamin` set('P','L') NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(30) DEFAULT NULL,
  `alamat` text NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama`, `jenis_kelamin`, `email`, `password`, `alamat`) VALUES
(2, 'BAGUS ANDRE WIJAYA', 'L', 'wijayabagusandre@gmail.com', 'andreskak25', 'Jl Galursari Raya 19,Dki Jakarta Dki Jakarta, Jakarta, 13120');

-- --------------------------------------------------------

--
-- Structure for view `pemakai_jasa`
--
DROP TABLE IF EXISTS `pemakai_jasa`;

DROP VIEW IF EXISTS `pemakai_jasa`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pemakai_jasa`  AS  select `user`.`nama` AS `nama`,`user`.`alamat` AS `alamat`,`kurir`.`ekspedisi` AS `ekspedisi`,`kurir`.`jenis_ekspedisi` AS `jenis_ekspedisi` from (`user` join `kurir` on((`user`.`id_user` = `kurir`.`id_kurir`))) ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_barang` (`id_kategori`);

--
-- Constraints for table `header_transaksi`
--
ALTER TABLE `header_transaksi`
  ADD CONSTRAINT `fk_barangg` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`),
  ADD CONSTRAINT `fk_kurirr` FOREIGN KEY (`id_kurir`) REFERENCES `kurir` (`id_kurir`),
  ADD CONSTRAINT `fk_payy` FOREIGN KEY (`id_payment`) REFERENCES `payment_method` (`id_payment`),
  ADD CONSTRAINT `fk_userr` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
