-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 06, 2026 at 09:24 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ayres_crm`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(200) NOT NULL,
  `tipe_barang_id` int(10) UNSIGNED NOT NULL,
  `satuan` enum('PCS','KILOGRAM','METER','ROLL','LUSIN') NOT NULL DEFAULT 'PCS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id`, `nama`, `tipe_barang_id`, `satuan`, `created_at`, `updated_at`) VALUES
(1, 'AUTHENTIC PRO (JOGLO)', 1, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(2, 'AUTHENTIC WOVEN', 1, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(3, 'TAFETA SAMPING (PRO)', 1, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(4, 'TALI KOLOR CELANA', 1, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(5, 'WASHTAG (LABEL SATIN)', 1, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(6, 'WEBBING', 1, 'METER', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(7, 'AIRWALK', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(8, 'BENZEMA', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(9, 'BRAZIL', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(10, 'BRICK', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(11, 'DROPNEEDLE', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(12, 'EMBOS STRAW', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(13, 'EMBOS TOPO', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(14, 'JAGUARD DINAMITE', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(15, 'JAGUARD ETNIK', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(16, 'JAGUARD SPIDER', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(17, 'JAGUARD TOPO', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(18, 'JAGUARD UNO', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(19, 'KAIN JALA AIRBIN', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(20, 'KAIN RIB SUBLIM', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(21, 'LACOSTE', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(22, 'MILANO', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(23, 'MU', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(24, 'PIQUE', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(25, 'PUMA', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(26, 'PUMA+', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(27, 'SEVILLA/MINI MINI', 2, 'KILOGRAM', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(28, 'KERAH JADI (RAJUT)', 3, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(29, 'KERAH KANCING', 3, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(30, 'KERAH KOMBINASI', 3, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22'),
(31, 'KERAH TALI', 3, 'PCS', '2026-04-01 07:09:22', '2026-04-01 07:09:22');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(200) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alamat_lengkap` text DEFAULT NULL,
  `desa_kelurahan` varchar(100) DEFAULT NULL,
  `kecamatan` varchar(100) DEFAULT NULL,
  `kabupaten_kota` varchar(100) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jabatan`
--

CREATE TABLE `jabatan` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jabatan`
--

INSERT INTO `jabatan` (`id`, `nama`, `deskripsi`, `created_at`, `updated_at`) VALUES
(1, 'AI ENGINEER', 'TIM IT INTERNAL1\n', '2026-04-02 06:15:04', '2026-04-02 06:15:10');

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(200) NOT NULL,
  `jabatan_id` int(10) UNSIGNED DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id`, `nama`, `jabatan_id`, `telepon`, `created_at`, `updated_at`) VALUES
(1, 'EZRA NAHUMURY', 1, '082338142821', '2026-04-02 06:16:20', '2026-04-02 06:18:25');

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

CREATE TABLE `leads` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(200) NOT NULL,
  `no_hp` varchar(20) NOT NULL,
  `sumber` enum('Instagram','WhatsApp','Facebook','Referral','Website','Lainnya') DEFAULT NULL,
  `jenis_cs` enum('CS Eksternal','Reseller','Agen') DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leads`
--

INSERT INTO `leads` (`id`, `nama`, `no_hp`, `sumber`, `jenis_cs`, `catatan`, `created_at`, `updated_at`) VALUES
(1, 'EZRA', '098345473', 'WhatsApp', 'CS Eksternal', '-', '2026-04-01 06:54:53', '2026-04-01 06:54:53');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `no_order` varchar(20) NOT NULL COMMENT 'ORD001, ORD002, ...',
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_nama` varchar(200) NOT NULL COMMENT 'Snapshot nama customer',
  `customer_phone` varchar(20) DEFAULT NULL,
  `customer_alamat` text DEFAULT NULL,
  `customer_desa` varchar(100) DEFAULT NULL,
  `customer_kecamatan` varchar(100) DEFAULT NULL,
  `customer_kabupaten` varchar(100) DEFAULT NULL,
  `customer_provinsi` varchar(100) DEFAULT NULL,
  `lead_id` int(10) UNSIGNED DEFAULT NULL,
  `nama_tim` varchar(100) DEFAULT NULL,
  `tanggal_order` date NOT NULL,
  `estimasi_deadline` date DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `status` enum('PENDING','CONFIRMED','IN_PROGRESS','DONE','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `nominal_order` decimal(15,2) NOT NULL DEFAULT 0.00,
  `dp_desain` decimal(15,2) NOT NULL DEFAULT 0.00,
  `dp_produksi` decimal(15,2) NOT NULL DEFAULT 0.00,
  `kekurangan` decimal(15,2) NOT NULL DEFAULT 0.00,
  `tracking_link` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `no_order`, `customer_id`, `customer_nama`, `customer_phone`, `customer_alamat`, `customer_desa`, `customer_kecamatan`, `customer_kabupaten`, `customer_provinsi`, `lead_id`, `nama_tim`, `tanggal_order`, `estimasi_deadline`, `keterangan`, `status`, `nominal_order`, `dp_desain`, `dp_produksi`, `kekurangan`, `tracking_link`, `created_at`, `updated_at`) VALUES
(1, 'ORD001', NULL, 'EZRA K NAHUMURY', '082338142821', 'TALAGA RAJA', 'KEL BATU GAJA', 'SIRIMAU', 'KOTA AMBON', 'MALUKU', 1, 'EZ CSv', '2026-04-01', '2026-04-09', 'FREE LOGO 3D 1', 'IN_PROGRESS', 150000.00, 20000.00, 50000.00, 80000.00, '/tracking/WO0401-001', '2026-04-01 07:25:15', '2026-04-01 09:16:36'),
(5, 'ORD002', NULL, 'ZEXO', '085335334466', 'JL. BUNTU', 'GALALA', 'SIRIMAU', 'KOTA AMBON', 'MALUKU', 1, 'XEOOO', '2026-04-02', '2026-04-12', 'S', 'IN_PROGRESS', 200000.00, 50000.00, 50000.00, 100000.00, '/tracking/WO0402-001', '2026-04-02 06:39:56', '2026-04-02 06:56:05');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `paket_id` int(10) UNSIGNED DEFAULT NULL,
  `paket_nama` varchar(100) NOT NULL,
  `bahan_kain` varchar(100) DEFAULT NULL,
  `qty` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `paket_id`, `paket_nama`, `bahan_kain`, `qty`) VALUES
(4, 1, NULL, 'STANDAR B', 'JAGUARD UNO', 0),
(5, 1, NULL, 'WARRIOR ATASAN (BELLTHIS)', 'KERAH KOMBINASI', 0),
(8, 5, NULL, 'CELANA PRINT', 'TAFETA SAMPING (PRO)', 0);

-- --------------------------------------------------------

--
-- Table structure for table `order_promos`
--

CREATE TABLE `order_promos` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `promo_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_promos`
--

INSERT INTO `order_promos` (`id`, `order_id`, `promo_id`) VALUES
(2, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `paket`
--

CREATE TABLE `paket` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `paket`
--

INSERT INTO `paket` (`id`, `nama`, `deskripsi`, `created_at`, `updated_at`) VALUES
(1, 'CELANA NON PRINT', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(2, 'CELANA PRINT', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(3, 'CLASSIC A', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(4, 'CLASSIC B', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(5, 'CLASSIC C', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(6, 'CLASSIC D', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(7, 'JAKET', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(8, 'KAOS', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(9, 'KAOS KAKI', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(10, 'PRO A', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(11, 'PRO B', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(12, 'PRO C', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(13, 'ROMPI', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(14, 'STANDAR A', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(15, 'STANDAR B', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(16, 'STANDAR BASIC', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(17, 'STANDAR C', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(18, 'WARRIOR ATASAN (BELLTHIS)', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30'),
(19, 'WARRIOR SETELAN (BELLGRANS)', NULL, '2026-04-01 06:59:30', '2026-04-01 06:59:30');

-- --------------------------------------------------------

--
-- Table structure for table `pecah_pola`
--

CREATE TABLE `pecah_pola` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `inisial` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pecah_pola`
--

INSERT INTO `pecah_pola` (`id`, `nama`, `inisial`, `created_at`, `updated_at`) VALUES
(1, 'BADAN BELAKANG', 'BB', '2026-04-02 06:13:15', '2026-04-02 06:13:15');

-- --------------------------------------------------------

--
-- Table structure for table `production_stages`
--

CREATE TABLE `production_stages` (
  `id` int(10) UNSIGNED NOT NULL,
  `urutan` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `production_stages`
--

INSERT INTO `production_stages` (`id`, `urutan`, `nama`, `created_at`) VALUES
(1, 1, 'Proofing', '2026-04-01 06:23:47'),
(2, 2, 'Printing Layout', '2026-04-01 06:23:47'),
(3, 3, 'Approval Layout', '2026-04-01 06:23:47'),
(4, 4, 'Printing Process', '2026-04-01 06:23:47'),
(5, 5, 'Sublim Press', '2026-04-01 06:23:47'),
(6, 6, 'QC Panel Process', '2026-04-01 06:23:47'),
(7, 7, 'Fabric Cutting', '2026-04-01 06:23:47'),
(8, 8, 'QC Cutting', '2026-04-01 06:23:47'),
(9, 9, 'Sewing', '2026-04-01 06:23:47'),
(10, 10, 'QC Jersey', '2026-04-01 06:23:47'),
(11, 11, 'Finishing', '2026-04-01 06:23:47'),
(12, 12, 'Shipment', '2026-04-01 06:23:47');

-- --------------------------------------------------------

--
-- Table structure for table `promo`
--

CREATE TABLE `promo` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(150) NOT NULL,
  `periode_mulai` date NOT NULL,
  `periode_selesai` date NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promo`
--

INSERT INTO `promo` (`id`, `nama`, `periode_mulai`, `periode_selesai`, `deskripsi`, `created_at`, `updated_at`) VALUES
(1, 'PROMO PASKAH', '2026-04-01', '2026-04-21', 'FREE DESIGN 3D', '2026-04-01 06:54:30', '2026-04-01 06:54:30');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `is_super_admin` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `nama`, `deskripsi`, `is_super_admin`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'Full access to all features a', 1, '2026-04-01 06:23:47', '2026-04-02 04:44:09'),
(2, 'ADMIN PROOFING', 'ONLY PROOFING', 0, '2026-04-02 04:58:46', '2026-04-02 04:58:46'),
(3, 'Admin Printing Layout', 'only printing layout', 0, '2026-04-02 06:48:03', '2026-04-02 06:48:03'),
(4, 'ADMIN Approval Layout', NULL, 0, '2026-04-06 01:48:43', '2026-04-06 01:48:43'),
(5, 'admin printing', NULL, 0, '2026-04-06 06:55:40', '2026-04-06 06:55:40');

-- --------------------------------------------------------

--
-- Table structure for table `role_menu_access`
--

CREATE TABLE `role_menu_access` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `menu_name` varchar(50) NOT NULL COMMENT 'Dashboard, Orders, Work Orders, Produksi, Laporan, Stok, Settings, Master Data'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_menu_access`
--

INSERT INTO `role_menu_access` (`id`, `role_id`, `menu_name`) VALUES
(9, 1, 'Dashboard'),
(10, 1, 'Orders'),
(11, 1, 'Work Orders'),
(12, 1, 'Produksi'),
(13, 1, 'Laporan'),
(14, 1, 'Stok'),
(15, 1, 'Settings'),
(16, 1, 'Master Data'),
(17, 2, 'Produksi'),
(18, 3, 'Produksi'),
(19, 4, 'Produksi'),
(20, 5, 'Produksi');

-- --------------------------------------------------------

--
-- Table structure for table `role_stage_access`
--

CREATE TABLE `role_stage_access` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `stage_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_stage_access`
--

INSERT INTO `role_stage_access` (`id`, `role_id`, `stage_id`) VALUES
(1, 2, 1),
(2, 3, 2),
(3, 4, 3),
(4, 5, 4);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `key_name` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `id` int(10) UNSIGNED NOT NULL,
  `barang_id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `harga_per_unit` decimal(15,2) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`id`, `barang_id`, `qty`, `harga_per_unit`, `updated_at`) VALUES
(1, 1, 7, NULL, '2026-04-02 03:51:21'),
(2, 4, 5, NULL, '2026-04-02 03:51:32'),
(3, 2, 25, NULL, '2026-04-06 01:56:10');

-- --------------------------------------------------------

--
-- Table structure for table `stok_adjustment`
--

CREATE TABLE `stok_adjustment` (
  `id` int(10) UNSIGNED NOT NULL,
  `barang_id` int(10) UNSIGNED NOT NULL,
  `tipe` enum('Penambahan','Pengurangan','Koreksi') NOT NULL,
  `qty_sebelum` int(11) NOT NULL DEFAULT 0,
  `qty_sesudah` int(11) NOT NULL DEFAULT 0,
  `selisih` int(11) NOT NULL DEFAULT 0,
  `keterangan` text DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'User yang melakukan adjustment',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stok_adjustment`
--

INSERT INTO `stok_adjustment` (`id`, `barang_id`, `tipe`, `qty_sebelum`, `qty_sesudah`, `selisih`, `keterangan`, `user_id`, `created_at`) VALUES
(1, 1, 'Penambahan', 0, 10, 10, '', NULL, '2026-04-02 03:50:33'),
(2, 1, 'Pengurangan', 10, 7, -3, '', NULL, '2026-04-02 03:51:21'),
(3, 4, 'Penambahan', 0, 5, 5, '', NULL, '2026-04-02 03:51:32'),
(4, 2, 'Penambahan', 0, 25, 25, '', NULL, '2026-04-06 01:56:10');

-- --------------------------------------------------------

--
-- Table structure for table `tipe_barang`
--

CREATE TABLE `tipe_barang` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipe_barang`
--

INSERT INTO `tipe_barang` (`id`, `nama`, `deskripsi`, `created_at`, `updated_at`) VALUES
(1, 'AKSESORIS', 'coba', '2026-04-01 07:06:21', '2026-04-02 06:09:22'),
(2, 'KAIN', NULL, '2026-04-01 07:06:21', '2026-04-01 07:06:21'),
(3, 'KERAH', 'TIPE KERAH', '2026-04-01 07:06:21', '2026-04-01 07:06:21');

-- --------------------------------------------------------

--
-- Table structure for table `ukuran`
--

CREATE TABLE `ukuran` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(50) NOT NULL,
  `deskripsi` varchar(100) DEFAULT NULL COMMENT 'Dimensi, misal 76 X 58',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ukuran`
--

INSERT INTO `ukuran` (`id`, `nama`, `deskripsi`, `created_at`, `updated_at`) VALUES
(2, 'L', '72 X 54\n', '2026-04-02 06:11:38', '2026-04-02 06:11:38'),
(3, 'M', '68 X 51', '2026-04-02 06:11:51', '2026-04-02 06:11:51');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `status` enum('aktif','non-aktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'admin@gmail.com', 'admin123', 1, 'aktif', '2026-04-01 06:23:47', '2026-04-01 06:23:47'),
(2, 'EZRA K NAHUMURY', 'ezra.kristanto@ti.ukdw.ac.id', 'ftiukdw2022', 2, 'aktif', '2026-04-02 05:04:02', '2026-04-02 05:04:02'),
(3, 'zetaco', 'zetaco@gmail.com', 'zetaco', 3, 'aktif', '2026-04-02 06:48:49', '2026-04-02 06:48:49'),
(4, 'VAL', 'val@gmail.com', 'admin123', 4, 'aktif', '2026-04-06 01:49:16', '2026-04-06 01:49:16'),
(5, 'EZRA', 'ezra@gmail.com', 'admin123', 5, 'aktif', '2026-04-06 06:56:08', '2026-04-06 06:56:08');

-- --------------------------------------------------------

--
-- Table structure for table `work_orders`
--

CREATE TABLE `work_orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `no_wo` varchar(20) NOT NULL COMMENT 'WO001, WO2603-001, ...',
  `order_id` int(10) UNSIGNED NOT NULL,
  `customer_nama` varchar(200) NOT NULL,
  `paket` varchar(100) NOT NULL,
  `bahan` varchar(100) DEFAULT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 0,
  `up_produksi` date DEFAULT NULL,
  `deadline` date NOT NULL,
  `keterangan` text DEFAULT NULL,
  `current_stage_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('PENDING','PROSES_PRODUKSI','SELESAI','TERLAMBAT') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `work_orders`
--

INSERT INTO `work_orders` (`id`, `no_wo`, `order_id`, `customer_nama`, `paket`, `bahan`, `jumlah`, `up_produksi`, `deadline`, `keterangan`, `current_stage_id`, `status`, `created_at`, `updated_at`) VALUES
(4, 'WO0401-001', 1, 'EZRA K NAHUMURY', 'STANDAR B, WARRIOR ATASAN (BELLTHIS)', 'JAGUARD UNO, KERAH KOMBINASI', 13, NULL, '2026-04-08', 'FREE LOGO 3D 1', 12, 'SELESAI', '2026-04-01 09:16:36', '2026-04-02 03:34:46'),
(5, 'WO0402-001', 5, 'ZEXO', 'CELANA PRINT', 'TAFETA SAMPING (PRO)', 10, NULL, '2026-04-12', 'S', 4, 'PROSES_PRODUKSI', '2026-04-02 06:40:07', '2026-04-06 06:54:31');

-- --------------------------------------------------------

--
-- Table structure for table `wo_detail_items`
--

CREATE TABLE `wo_detail_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `work_order_id` int(10) UNSIGNED NOT NULL,
  `urutan` int(11) NOT NULL DEFAULT 0,
  `nama` varchar(100) NOT NULL,
  `np` varchar(20) DEFAULT NULL COMMENT 'Nomor Punggung',
  `ukuran` varchar(20) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `bd` varchar(50) DEFAULT NULL COMMENT 'Badan Depan',
  `bb` varchar(50) DEFAULT NULL COMMENT 'Badan Belakang',
  `lengan` varchar(50) DEFAULT NULL,
  `kerah` varchar(50) DEFAULT NULL,
  `penjahit_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wo_detail_items`
--

INSERT INTO `wo_detail_items` (`id`, `work_order_id`, `urutan`, `nama`, `np`, `ukuran`, `keterangan`, `bd`, `bb`, `lengan`, `kerah`, `penjahit_id`) VALUES
(8, 4, 1, 'ez', 's', 's', 'ss', NULL, NULL, NULL, 'aa', NULL),
(9, 4, 2, 'aa', 'aaa', 'aaa', 'aaa', NULL, NULL, NULL, 'aaaa', NULL),
(10, 4, 3, 'vvvvv', 'vvv', 'f', 'vvvv', NULL, NULL, NULL, 'vvv', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wo_pengiriman`
--

CREATE TABLE `wo_pengiriman` (
  `id` int(10) UNSIGNED NOT NULL,
  `work_order_id` int(10) UNSIGNED NOT NULL,
  `detail_item_id` int(10) UNSIGNED DEFAULT NULL,
  `urutan` int(11) NOT NULL DEFAULT 0,
  `nama` varchar(100) NOT NULL,
  `np` varchar(20) DEFAULT NULL,
  `ukuran` varchar(20) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `bonus` varchar(200) DEFAULT NULL,
  `checklist` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wo_pengiriman`
--

INSERT INTO `wo_pengiriman` (`id`, `work_order_id`, `detail_item_id`, `urutan`, `nama`, `np`, `ukuran`, `keterangan`, `bonus`, `checklist`) VALUES
(1, 4, 8, 1, 'ez', 's', 's', 'ss', 'a', 0),
(2, 4, 9, 2, 'aa', 'aaa', 'aaa', 'aaa', '', 0),
(3, 4, 10, 3, 'vvvvv', 'vvv', 'f', 'vvvv', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `wo_permintaan_gudang`
--

CREATE TABLE `wo_permintaan_gudang` (
  `id` int(10) UNSIGNED NOT NULL,
  `work_order_id` int(10) UNSIGNED NOT NULL,
  `kategori` enum('BAHAN_UTAMA','AKSESORIS','MATERIAL_TAMBAHAN') NOT NULL DEFAULT 'BAHAN_UTAMA',
  `urutan` int(11) NOT NULL DEFAULT 0,
  `bagian` varchar(100) NOT NULL,
  `bahan` varchar(100) NOT NULL,
  `warna` varchar(50) DEFAULT NULL,
  `kuantitas` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wo_progress`
--

CREATE TABLE `wo_progress` (
  `id` int(10) UNSIGNED NOT NULL,
  `work_order_id` int(10) UNSIGNED NOT NULL,
  `stage_id` int(10) UNSIGNED NOT NULL,
  `status` enum('BELUM','TERSEDIA','SEDANG','SELESAI') NOT NULL DEFAULT 'BELUM',
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `karyawan_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Penanggung jawab'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wo_progress`
--

INSERT INTO `wo_progress` (`id`, `work_order_id`, `stage_id`, `status`, `started_at`, `completed_at`, `karyawan_id`) VALUES
(1, 4, 1, 'SELESAI', '2026-04-01 20:07:43', '2026-04-01 20:07:49', NULL),
(2, 4, 2, 'SELESAI', '2026-04-01 20:07:55', '2026-04-01 20:07:56', NULL),
(3, 4, 3, 'SELESAI', '2026-04-01 20:07:58', '2026-04-01 20:07:59', NULL),
(4, 4, 4, 'SELESAI', '2026-04-01 20:09:24', '2026-04-01 20:09:26', NULL),
(5, 4, 5, 'SELESAI', '2026-04-01 20:09:28', '2026-04-01 20:09:29', NULL),
(6, 4, 6, 'SELESAI', '2026-04-01 20:09:31', '2026-04-01 20:10:29', NULL),
(7, 4, 7, 'SELESAI', '2026-04-01 20:12:50', '2026-04-01 20:24:47', NULL),
(8, 4, 8, 'SELESAI', '2026-04-01 20:25:45', '2026-04-01 20:26:06', NULL),
(9, 4, 9, 'SELESAI', '2026-04-01 20:27:44', '2026-04-01 20:27:57', NULL),
(10, 4, 10, 'SELESAI', '2026-04-01 20:30:50', '2026-04-01 20:31:00', NULL),
(11, 4, 11, 'SELESAI', '2026-04-01 20:31:08', '2026-04-01 20:31:20', NULL),
(12, 4, 12, 'SELESAI', '2026-04-01 20:34:44', '2026-04-01 20:34:46', NULL),
(13, 5, 1, 'SELESAI', '2026-04-01 23:41:09', '2026-04-01 23:42:03', NULL),
(14, 5, 2, 'SELESAI', '2026-04-01 23:50:12', '2026-04-01 23:52:37', NULL),
(15, 5, 3, 'SELESAI', '2026-04-05 18:49:44', '2026-04-05 23:54:31', NULL),
(16, 5, 4, 'TERSEDIA', NULL, NULL, NULL),
(17, 5, 5, 'BELUM', NULL, NULL, NULL),
(18, 5, 6, 'BELUM', NULL, NULL, NULL),
(19, 5, 7, 'BELUM', NULL, NULL, NULL),
(20, 5, 8, 'BELUM', NULL, NULL, NULL),
(21, 5, 9, 'BELUM', NULL, NULL, NULL),
(22, 5, 10, 'BELUM', NULL, NULL, NULL),
(23, 5, 11, 'BELUM', NULL, NULL, NULL),
(24, 5, 12, 'BELUM', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wo_spesifikasi`
--

CREATE TABLE `wo_spesifikasi` (
  `id` int(10) UNSIGNED NOT NULL,
  `work_order_id` int(10) UNSIGNED NOT NULL,
  `nama_spesifikasi` varchar(150) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 0,
  `deadline` date DEFAULT NULL,
  `dokumen_desain` varchar(500) DEFAULT NULL COMMENT 'Path file gambar desain',
  `dokumen_pattern` varchar(500) DEFAULT NULL COMMENT 'Path file gambar pattern',
  `tagline` varchar(100) DEFAULT NULL,
  `authentic` varchar(100) DEFAULT NULL,
  `info_ukuran` varchar(100) DEFAULT NULL,
  `info_logo` varchar(100) DEFAULT NULL,
  `info_packing` varchar(100) DEFAULT NULL,
  `webbing` varchar(100) DEFAULT NULL,
  `font_nomor` varchar(100) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `keterangan_jahit` text DEFAULT NULL,
  `approval_admin` text DEFAULT NULL,
  `export_icc` varchar(100) DEFAULT NULL COMMENT 'misal: JPEG-RGB 3 PASS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wo_spesifikasi`
--

INSERT INTO `wo_spesifikasi` (`id`, `work_order_id`, `nama_spesifikasi`, `jumlah`, `deadline`, `dokumen_desain`, `dokumen_pattern`, `tagline`, `authentic`, `info_ukuran`, `info_logo`, `info_packing`, `webbing`, `font_nomor`, `keterangan`, `keterangan_jahit`, `approval_admin`, `export_icc`, `created_at`, `updated_at`) VALUES
(1, 4, 'PLAYER', 12, '0000-00-00', '/uploads/1775094238204-4y5t68.jpeg', '/uploads/1775094243778-9ugsld.jpeg', 'polos', 'Ayress rubber', 'custom', 'PRINT', 'Ayres', 'Ayres', 'ARIAL', '-', 'JAHIT RAPI', 'EZRAAAA', 'JPEG-RGB 3 PASS', '2026-04-02 01:44:49', '2026-04-02 02:29:28');

-- --------------------------------------------------------

--
-- Table structure for table `wo_spesifikasi_bahan`
--

CREATE TABLE `wo_spesifikasi_bahan` (
  `id` int(10) UNSIGNED NOT NULL,
  `spesifikasi_id` int(10) UNSIGNED NOT NULL,
  `bagian` varchar(100) NOT NULL COMMENT 'BADAN DEPAN, LENGAN, dll',
  `bahan` varchar(100) NOT NULL,
  `urutan` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wo_spesifikasi_bahan`
--

INSERT INTO `wo_spesifikasi_bahan` (`id`, `spesifikasi_id`, `bagian`, `bahan`, `urutan`) VALUES
(27, 1, 'lengan', 'a', 0),
(28, 1, 'BAGIAN DEPAN', 'EZ', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_barang_tipe` (`tipe_barang_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jabatan`
--
ALTER TABLE `jabatan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_karyawan_jabatan` (`jabatan_id`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_no_order` (`no_order`),
  ADD KEY `fk_orders_customer` (`customer_id`),
  ADD KEY `fk_orders_lead` (`lead_id`),
  ADD KEY `idx_orders_status` (`status`),
  ADD KEY `idx_orders_deadline` (`estimasi_deadline`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_oi_order` (`order_id`),
  ADD KEY `fk_oi_paket` (`paket_id`);

--
-- Indexes for table `order_promos`
--
ALTER TABLE `order_promos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_order_promo` (`order_id`,`promo_id`),
  ADD KEY `fk_op_promo` (`promo_id`);

--
-- Indexes for table `paket`
--
ALTER TABLE `paket`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pecah_pola`
--
ALTER TABLE `pecah_pola`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `production_stages`
--
ALTER TABLE `production_stages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_stage_urutan` (`urutan`);

--
-- Indexes for table `promo`
--
ALTER TABLE `promo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role_menu_access`
--
ALTER TABLE `role_menu_access`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rma_role` (`role_id`);

--
-- Indexes for table `role_stage_access`
--
ALTER TABLE `role_stage_access`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rsa_role` (`role_id`),
  ADD KEY `fk_rsa_stage` (`stage_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_settings_key` (`key_name`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_stok_barang` (`barang_id`);

--
-- Indexes for table `stok_adjustment`
--
ALTER TABLE `stok_adjustment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sa_barang` (`barang_id`),
  ADD KEY `fk_sa_user` (`user_id`),
  ADD KEY `idx_sa_created` (`created_at`);

--
-- Indexes for table `tipe_barang`
--
ALTER TABLE `tipe_barang`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ukuran`
--
ALTER TABLE `ukuran`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`),
  ADD KEY `fk_users_role` (`role_id`);

--
-- Indexes for table `work_orders`
--
ALTER TABLE `work_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_no_wo` (`no_wo`),
  ADD KEY `fk_wo_order` (`order_id`),
  ADD KEY `fk_wo_stage` (`current_stage_id`),
  ADD KEY `idx_wo_status` (`status`),
  ADD KEY `idx_wo_deadline` (`deadline`);

--
-- Indexes for table `wo_detail_items`
--
ALTER TABLE `wo_detail_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_di_wo` (`work_order_id`),
  ADD KEY `fk_di_penjahit` (`penjahit_id`);

--
-- Indexes for table `wo_pengiriman`
--
ALTER TABLE `wo_pengiriman`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pk_wo` (`work_order_id`),
  ADD KEY `fk_pk_di` (`detail_item_id`);

--
-- Indexes for table `wo_permintaan_gudang`
--
ALTER TABLE `wo_permintaan_gudang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pg_wo` (`work_order_id`);

--
-- Indexes for table `wo_progress`
--
ALTER TABLE `wo_progress`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_wo_stage` (`work_order_id`,`stage_id`),
  ADD KEY `fk_wp_stage` (`stage_id`),
  ADD KEY `fk_wp_karyawan` (`karyawan_id`);

--
-- Indexes for table `wo_spesifikasi`
--
ALTER TABLE `wo_spesifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_spec_wo` (`work_order_id`);

--
-- Indexes for table `wo_spesifikasi_bahan`
--
ALTER TABLE `wo_spesifikasi_bahan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sb_spec` (`spesifikasi_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `jabatan`
--
ALTER TABLE `jabatan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `order_promos`
--
ALTER TABLE `order_promos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `paket`
--
ALTER TABLE `paket`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `pecah_pola`
--
ALTER TABLE `pecah_pola`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `production_stages`
--
ALTER TABLE `production_stages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `promo`
--
ALTER TABLE `promo`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `role_menu_access`
--
ALTER TABLE `role_menu_access`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `role_stage_access`
--
ALTER TABLE `role_stage_access`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stok`
--
ALTER TABLE `stok`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `stok_adjustment`
--
ALTER TABLE `stok_adjustment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tipe_barang`
--
ALTER TABLE `tipe_barang`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ukuran`
--
ALTER TABLE `ukuran`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `work_orders`
--
ALTER TABLE `work_orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wo_detail_items`
--
ALTER TABLE `wo_detail_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `wo_pengiriman`
--
ALTER TABLE `wo_pengiriman`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `wo_permintaan_gudang`
--
ALTER TABLE `wo_permintaan_gudang`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wo_progress`
--
ALTER TABLE `wo_progress`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `wo_spesifikasi`
--
ALTER TABLE `wo_spesifikasi`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wo_spesifikasi_bahan`
--
ALTER TABLE `wo_spesifikasi_bahan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `fk_barang_tipe` FOREIGN KEY (`tipe_barang_id`) REFERENCES `tipe_barang` (`id`);

--
-- Constraints for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD CONSTRAINT `fk_karyawan_jabatan` FOREIGN KEY (`jabatan_id`) REFERENCES `jabatan` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_orders_lead` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_oi_paket` FOREIGN KEY (`paket_id`) REFERENCES `paket` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_promos`
--
ALTER TABLE `order_promos`
  ADD CONSTRAINT `fk_op_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_op_promo` FOREIGN KEY (`promo_id`) REFERENCES `promo` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_menu_access`
--
ALTER TABLE `role_menu_access`
  ADD CONSTRAINT `fk_rma_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `fk_stok_barang` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stok_adjustment`
--
ALTER TABLE `stok_adjustment`
  ADD CONSTRAINT `fk_sa_barang` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sa_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `work_orders`
--
ALTER TABLE `work_orders`
  ADD CONSTRAINT `fk_wo_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_wo_stage` FOREIGN KEY (`current_stage_id`) REFERENCES `production_stages` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `wo_detail_items`
--
ALTER TABLE `wo_detail_items`
  ADD CONSTRAINT `fk_di_penjahit` FOREIGN KEY (`penjahit_id`) REFERENCES `karyawan` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_di_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wo_pengiriman`
--
ALTER TABLE `wo_pengiriman`
  ADD CONSTRAINT `fk_pk_di` FOREIGN KEY (`detail_item_id`) REFERENCES `wo_detail_items` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pk_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wo_permintaan_gudang`
--
ALTER TABLE `wo_permintaan_gudang`
  ADD CONSTRAINT `fk_pg_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wo_progress`
--
ALTER TABLE `wo_progress`
  ADD CONSTRAINT `fk_wp_karyawan` FOREIGN KEY (`karyawan_id`) REFERENCES `karyawan` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_wp_stage` FOREIGN KEY (`stage_id`) REFERENCES `production_stages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_wp_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wo_spesifikasi`
--
ALTER TABLE `wo_spesifikasi`
  ADD CONSTRAINT `fk_spec_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wo_spesifikasi_bahan`
--
ALTER TABLE `wo_spesifikasi_bahan`
  ADD CONSTRAINT `fk_sb_spec` FOREIGN KEY (`spesifikasi_id`) REFERENCES `wo_spesifikasi` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
