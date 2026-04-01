-- ============================================
-- AYRES CRM - Database Schema
-- MySQL / MariaDB (XAMPP Compatible)
-- Import via phpMyAdmin atau CLI
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `ayres_crm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `ayres_crm`;

-- ============================================
-- 1. ROLES & USERS
-- ============================================

CREATE TABLE `roles` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(100) NOT NULL,
  `deskripsi` VARCHAR(255) DEFAULT NULL,
  `is_super_admin` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `role_menu_access` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` INT UNSIGNED NOT NULL,
  `menu_name` VARCHAR(50) NOT NULL COMMENT 'Dashboard, Orders, Work Orders, Produksi, Laporan, Stok, Settings, Master Data',
  PRIMARY KEY (`id`),
  KEY `fk_rma_role` (`role_id`),
  CONSTRAINT `fk_rma_role` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role_id` INT UNSIGNED NOT NULL,
  `status` ENUM('aktif','non-aktif') NOT NULL DEFAULT 'aktif',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `fk_users_role` (`role_id`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================
-- 2. MASTER DATA
-- ============================================

CREATE TABLE `customers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(200) NOT NULL,
  `no_hp` VARCHAR(20) DEFAULT NULL,
  `alamat_lengkap` TEXT DEFAULT NULL,
  `desa_kelurahan` VARCHAR(100) DEFAULT NULL,
  `kecamatan` VARCHAR(100) DEFAULT NULL,
  `kabupaten_kota` VARCHAR(100) DEFAULT NULL,
  `provinsi` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `paket` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(100) NOT NULL,
  `deskripsi` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `tipe_barang` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(100) NOT NULL,
  `deskripsi` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `barang` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(200) NOT NULL,
  `tipe_barang_id` INT UNSIGNED NOT NULL,
  `satuan` ENUM('PCS','KILOGRAM','METER','ROLL','LUSIN') NOT NULL DEFAULT 'PCS',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_barang_tipe` (`tipe_barang_id`),
  CONSTRAINT `fk_barang_tipe` FOREIGN KEY (`tipe_barang_id`) REFERENCES `tipe_barang`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `ukuran` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(50) NOT NULL,
  `deskripsi` VARCHAR(100) DEFAULT NULL COMMENT 'Dimensi, misal 76 X 58',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `pecah_pola` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(100) NOT NULL,
  `inisial` VARCHAR(20) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `jabatan` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(100) NOT NULL,
  `deskripsi` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `karyawan` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(200) NOT NULL,
  `jabatan_id` INT UNSIGNED DEFAULT NULL,
  `telepon` VARCHAR(20) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_karyawan_jabatan` (`jabatan_id`),
  CONSTRAINT `fk_karyawan_jabatan` FOREIGN KEY (`jabatan_id`) REFERENCES `jabatan`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE `promo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(150) NOT NULL,
  `periode_mulai` DATE NOT NULL,
  `periode_selesai` DATE NOT NULL,
  `deskripsi` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `leads` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(200) NOT NULL,
  `no_hp` VARCHAR(20) NOT NULL,
  `sumber` ENUM('Instagram','WhatsApp','Facebook','Referral','Website','Lainnya') DEFAULT NULL,
  `jenis_cs` ENUM('CS Eksternal','Reseller','Agen') DEFAULT NULL,
  `catatan` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- ============================================
-- 3. PRODUCTION STAGES (Master)
-- ============================================

CREATE TABLE `production_stages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `urutan` INT NOT NULL,
  `nama` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stage_urutan` (`urutan`)
) ENGINE=InnoDB;

-- ============================================
-- 4. ORDERS
-- ============================================

CREATE TABLE `orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `no_order` VARCHAR(20) NOT NULL COMMENT 'ORD001, ORD002, ...',
  `customer_id` INT UNSIGNED DEFAULT NULL,
  `customer_nama` VARCHAR(200) NOT NULL COMMENT 'Snapshot nama customer',
  `customer_phone` VARCHAR(20) DEFAULT NULL,
  `customer_alamat` TEXT DEFAULT NULL,
  `customer_desa` VARCHAR(100) DEFAULT NULL,
  `customer_kecamatan` VARCHAR(100) DEFAULT NULL,
  `customer_kabupaten` VARCHAR(100) DEFAULT NULL,
  `customer_provinsi` VARCHAR(100) DEFAULT NULL,
  `lead_id` INT UNSIGNED DEFAULT NULL,
  `nama_tim` VARCHAR(100) DEFAULT NULL,
  `tanggal_order` DATE NOT NULL,
  `estimasi_deadline` DATE DEFAULT NULL,
  `keterangan` TEXT DEFAULT NULL,
  `status` ENUM('PENDING','CONFIRMED','IN_PROGRESS','DONE','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `nominal_order` DECIMAL(15,2) NOT NULL DEFAULT 0,
  `dp_desain` DECIMAL(15,2) NOT NULL DEFAULT 0,
  `dp_produksi` DECIMAL(15,2) NOT NULL DEFAULT 0,
  `kekurangan` DECIMAL(15,2) NOT NULL DEFAULT 0,
  `tracking_link` VARCHAR(500) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_no_order` (`no_order`),
  KEY `fk_orders_customer` (`customer_id`),
  KEY `fk_orders_lead` (`lead_id`),
  KEY `idx_orders_status` (`status`),
  KEY `idx_orders_deadline` (`estimasi_deadline`),
  CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_orders_lead` FOREIGN KEY (`lead_id`) REFERENCES `leads`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE `order_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `paket_id` INT UNSIGNED DEFAULT NULL,
  `paket_nama` VARCHAR(100) NOT NULL,
  `bahan_kain` VARCHAR(100) DEFAULT NULL,
  `qty` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_oi_order` (`order_id`),
  KEY `fk_oi_paket` (`paket_id`),
  CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_oi_paket` FOREIGN KEY (`paket_id`) REFERENCES `paket`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE `order_promos` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `promo_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_order_promo` (`order_id`, `promo_id`),
  KEY `fk_op_promo` (`promo_id`),
  CONSTRAINT `fk_op_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_op_promo` FOREIGN KEY (`promo_id`) REFERENCES `promo`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- 5. WORK ORDERS
-- ============================================

CREATE TABLE `work_orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `no_wo` VARCHAR(20) NOT NULL COMMENT 'WO001, WO2603-001, ...',
  `order_id` INT UNSIGNED NOT NULL,
  `customer_nama` VARCHAR(200) NOT NULL,
  `paket` VARCHAR(100) NOT NULL,
  `bahan` VARCHAR(100) DEFAULT NULL,
  `jumlah` INT NOT NULL DEFAULT 0,
  `up_produksi` DATE DEFAULT NULL,
  `deadline` DATE NOT NULL,
  `keterangan` TEXT DEFAULT NULL,
  `current_stage_id` INT UNSIGNED DEFAULT NULL,
  `status` ENUM('PENDING','PROSES_PRODUKSI','SELESAI','TERLAMBAT') NOT NULL DEFAULT 'PENDING',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_no_wo` (`no_wo`),
  KEY `fk_wo_order` (`order_id`),
  KEY `fk_wo_stage` (`current_stage_id`),
  KEY `idx_wo_status` (`status`),
  KEY `idx_wo_deadline` (`deadline`),
  CONSTRAINT `fk_wo_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wo_stage` FOREIGN KEY (`current_stage_id`) REFERENCES `production_stages`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- WO Progress per stage
CREATE TABLE `wo_progress` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_order_id` INT UNSIGNED NOT NULL,
  `stage_id` INT UNSIGNED NOT NULL,
  `status` ENUM('BELUM','TERSEDIA','SEDANG','SELESAI') NOT NULL DEFAULT 'BELUM',
  `started_at` TIMESTAMP NULL DEFAULT NULL,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `karyawan_id` INT UNSIGNED DEFAULT NULL COMMENT 'Penanggung jawab',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wo_stage` (`work_order_id`, `stage_id`),
  KEY `fk_wp_stage` (`stage_id`),
  KEY `fk_wp_karyawan` (`karyawan_id`),
  CONSTRAINT `fk_wp_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wp_stage` FOREIGN KEY (`stage_id`) REFERENCES `production_stages`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wp_karyawan` FOREIGN KEY (`karyawan_id`) REFERENCES `karyawan`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- WO 1: Lembar Spesifikasi
CREATE TABLE `wo_spesifikasi` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_order_id` INT UNSIGNED NOT NULL,
  `nama_spesifikasi` VARCHAR(150) NOT NULL,
  `jumlah` INT NOT NULL DEFAULT 0,
  `deadline` DATE DEFAULT NULL,
  `dokumen_desain` VARCHAR(500) DEFAULT NULL COMMENT 'Path file gambar desain',
  `dokumen_pattern` VARCHAR(500) DEFAULT NULL COMMENT 'Path file gambar pattern',
  `tagline` VARCHAR(100) DEFAULT NULL,
  `authentic` VARCHAR(100) DEFAULT NULL,
  `info_ukuran` VARCHAR(100) DEFAULT NULL,
  `info_logo` VARCHAR(100) DEFAULT NULL,
  `info_packing` VARCHAR(100) DEFAULT NULL,
  `webbing` VARCHAR(100) DEFAULT NULL,
  `font_nomor` VARCHAR(100) DEFAULT NULL,
  `keterangan` TEXT DEFAULT NULL,
  `keterangan_jahit` TEXT DEFAULT NULL,
  `approval_admin` TEXT DEFAULT NULL,
  `export_icc` VARCHAR(100) DEFAULT NULL COMMENT 'misal: JPEG-RGB 3 PASS',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_spec_wo` (`work_order_id`),
  CONSTRAINT `fk_spec_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `wo_spesifikasi_bahan` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `spesifikasi_id` INT UNSIGNED NOT NULL,
  `bagian` VARCHAR(100) NOT NULL COMMENT 'BADAN DEPAN, LENGAN, dll',
  `bahan` VARCHAR(100) NOT NULL,
  `urutan` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_sb_spec` (`spesifikasi_id`),
  CONSTRAINT `fk_sb_spec` FOREIGN KEY (`spesifikasi_id`) REFERENCES `wo_spesifikasi`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- WO 2: Form Permintaan Gudang
CREATE TABLE `wo_permintaan_gudang` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_order_id` INT UNSIGNED NOT NULL,
  `kategori` ENUM('BAHAN_UTAMA','AKSESORIS','MATERIAL_TAMBAHAN') NOT NULL DEFAULT 'BAHAN_UTAMA',
  `urutan` INT NOT NULL DEFAULT 0,
  `bagian` VARCHAR(100) NOT NULL,
  `bahan` VARCHAR(100) NOT NULL,
  `warna` VARCHAR(50) DEFAULT NULL,
  `kuantitas` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_pg_wo` (`work_order_id`),
  CONSTRAINT `fk_pg_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- WO 3: Detail Order Items (Player list)
CREATE TABLE `wo_detail_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_order_id` INT UNSIGNED NOT NULL,
  `urutan` INT NOT NULL DEFAULT 0,
  `nama` VARCHAR(100) NOT NULL,
  `np` VARCHAR(20) DEFAULT NULL COMMENT 'Nomor Punggung',
  `ukuran` VARCHAR(20) NOT NULL,
  `keterangan` TEXT DEFAULT NULL,
  `bd` VARCHAR(50) DEFAULT NULL COMMENT 'Badan Depan',
  `bb` VARCHAR(50) DEFAULT NULL COMMENT 'Badan Belakang',
  `lengan` VARCHAR(50) DEFAULT NULL,
  `kerah` VARCHAR(50) DEFAULT NULL,
  `penjahit_id` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_di_wo` (`work_order_id`),
  KEY `fk_di_penjahit` (`penjahit_id`),
  CONSTRAINT `fk_di_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_di_penjahit` FOREIGN KEY (`penjahit_id`) REFERENCES `karyawan`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- WO 4: Form Pengiriman
CREATE TABLE `wo_pengiriman` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_order_id` INT UNSIGNED NOT NULL,
  `detail_item_id` INT UNSIGNED DEFAULT NULL,
  `urutan` INT NOT NULL DEFAULT 0,
  `nama` VARCHAR(100) NOT NULL,
  `np` VARCHAR(20) DEFAULT NULL,
  `ukuran` VARCHAR(20) NOT NULL,
  `keterangan` TEXT DEFAULT NULL,
  `bonus` VARCHAR(200) DEFAULT NULL,
  `checklist` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_pk_wo` (`work_order_id`),
  KEY `fk_pk_di` (`detail_item_id`),
  CONSTRAINT `fk_pk_wo` FOREIGN KEY (`work_order_id`) REFERENCES `work_orders`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pk_di` FOREIGN KEY (`detail_item_id`) REFERENCES `wo_detail_items`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- 6. STOK & ADJUSTMENT
-- ============================================

CREATE TABLE `stok` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `barang_id` INT UNSIGNED NOT NULL,
  `qty` INT NOT NULL DEFAULT 0,
  `harga_per_unit` DECIMAL(15,2) DEFAULT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stok_barang` (`barang_id`),
  CONSTRAINT `fk_stok_barang` FOREIGN KEY (`barang_id`) REFERENCES `barang`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `stok_adjustment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `barang_id` INT UNSIGNED NOT NULL,
  `tipe` ENUM('Penambahan','Pengurangan','Koreksi') NOT NULL,
  `qty_sebelum` INT NOT NULL DEFAULT 0,
  `qty_sesudah` INT NOT NULL DEFAULT 0,
  `selisih` INT NOT NULL DEFAULT 0,
  `keterangan` TEXT DEFAULT NULL,
  `user_id` INT UNSIGNED DEFAULT NULL COMMENT 'User yang melakukan adjustment',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_sa_barang` (`barang_id`),
  KEY `fk_sa_user` (`user_id`),
  KEY `idx_sa_created` (`created_at`),
  CONSTRAINT `fk_sa_barang` FOREIGN KEY (`barang_id`) REFERENCES `barang`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sa_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- 7. SETTINGS
-- ============================================

CREATE TABLE `settings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `key_name` VARCHAR(100) NOT NULL,
  `value` TEXT DEFAULT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_settings_key` (`key_name`)
) ENGINE=InnoDB;

-- ============================================
-- 8. SEED DATA
-- ============================================

-- Roles
INSERT INTO `roles` (`id`, `nama`, `deskripsi`, `is_super_admin`) VALUES
(1, 'Super Admin', 'Full access to all features', 1),
(2, 'Admin', 'Administrator', 0),
(3, 'Customer Service', 'CS internal', 0),
(4, 'Produksi', 'Staff produksi', 0);

-- Menu access for Super Admin (all menus)
INSERT INTO `role_menu_access` (`role_id`, `menu_name`) VALUES
(1, 'Dashboard'), (1, 'Orders'), (1, 'Work Orders'), (1, 'Produksi'),
(1, 'Laporan'), (1, 'Stok'), (1, 'Settings'), (1, 'Master Data');

-- Default Super Admin user (password: admin123 — hash with bcrypt in production)
INSERT INTO `users` (`nama`, `email`, `password`, `role_id`, `status`) VALUES
('Super Admin', 'admin@gmail.com', '$2b$10$placeholder_hash_admin123', 1, 'aktif');

-- Production Stages
INSERT INTO `production_stages` (`urutan`, `nama`) VALUES
(1, 'Proofing'),
(2, 'Printing Layout'),
(3, 'Approval Layout'),
(4, 'Printing Process'),
(5, 'Sublim Press'),
(6, 'QC Panel Process'),
(7, 'Fabric Cutting'),
(8, 'QC Cutting'),
(9, 'Sewing'),
(10, 'QC Jersey'),
(11, 'Finishing'),
(12, 'Shipment');

-- Master Paket
INSERT INTO `paket` (`nama`) VALUES
('CELANA NON PRINT'),('CELANA PRINT'),('CLASSIC A'),('CLASSIC B'),
('CLASSIC C'),('CLASSIC D'),('JAKET'),('KAOS'),('KAOS KAKI'),
('PRO A'),('PRO B'),('STANDAR A'),('STANDAR B');

-- Master Tipe Barang
INSERT INTO `tipe_barang` (`nama`, `deskripsi`) VALUES
('AKSESORIS', NULL),
('KAIN', NULL),
('KERAH', 'TIPE KERAH');

-- Master Barang
INSERT INTO `barang` (`nama`, `tipe_barang_id`, `satuan`) VALUES
('AUTHENTIC PRO (JOGLO)', 1, 'PCS'),
('AUTHENTIC WOVEN', 1, 'PCS'),
('TAFETA SAMPING (PRO)', 1, 'PCS'),
('TALI KOLOR CELANA', 1, 'KILOGRAM'),
('WASHTAG (LABEL SATIN)', 1, 'PCS'),
('WEBBING', 1, 'METER'),
('AIRWALK', 2, 'KILOGRAM'),
('BENZEMA', 2, 'KILOGRAM');

-- Stok awal (qty 0 kecuali Airwalk)
INSERT INTO `stok` (`barang_id`, `qty`) VALUES
(1, 0),(2, 0),(3, 0),(4, 0),(5, 0),(6, 0),(7, 6),(8, 0);

-- Master Ukuran
INSERT INTO `ukuran` (`nama`, `deskripsi`) VALUES
('2XL', '76 X 58'),('2XL BARET', '72 X 54'),('2XL WANITA SLIMFIT', '68 X 54'),
('3XL', '78 X 60'),('3XL BARET', '74 X 56'),('3XL WANITA SLIMFIT', '69 X 56'),
('4XL', '80 X 62'),('4XL WANITA SLIMFIT', '70 X 58'),('5XL', '82 X 64'),
('S', '64 X 48'),('M', '67 X 50'),('L', '70 X 52'),('XL', '73 X 55');

-- Master Pecah Pola
INSERT INTO `pecah_pola` (`nama`, `inisial`) VALUES
('BADAN BELAKANG', 'BB'),('BADAN DEPAN', 'BD'),('CELANA', 'CELANA'),
('KEMBEN', 'KEMBEN'),('KERAH', 'KERAH'),('KOMBINASI', 'KOMBINASI');

-- Master Jabatan
INSERT INTO `jabatan` (`nama`, `deskripsi`) VALUES
('Admin', 'Administrator sistem'),
('Finishing', 'Staff bagian finishing'),
('Operator Jahit', 'Operator mesin jahit'),
('QC', 'Quality Control');

-- Master Karyawan
INSERT INTO `karyawan` (`nama`, `jabatan_id`, `telepon`) VALUES
('Ezra Kristanto Nahumury', 3, '55');

-- Master Promo
INSERT INTO `promo` (`nama`, `periode_mulai`, `periode_selesai`, `deskripsi`) VALUES
('PROMO MARET', '2026-03-02', '2026-04-30', 'STANDAR : FREE LOGO 3D CLASSIC : FREE LOGO 3D & 1 BOLA/JERSEY PRO : FREE LOGO 3D, 1 BOLA, 1 JERSEY WARRIOR : FREE LOGO 3D, BOLA, JERSEY TIM, SUBSIDI ONGKIR 80RB, CASHBACK 5% NEXT ORDER'),
('CASHBACK', '2026-02-28', '2026-05-31', 'CASHBACK YANG BISA DI KLAIM SAAT ORDERAN SELESAI'),
('PROMO FEBRUARI', '2026-02-28', '2026-04-30', 'STANDAR : FREE LOGO 3D FLOCK CLASSIC : FREE LOGO 3D FLOCK & BOLA / JERSEY TIM PRO : FREE LOGO 3D FLOCK, BOLA, JERSEY TIM WARRIOR : FREE LOGO 3D, FLOCK, BOLA, JERSEY TIM, SUBSIDI ONGKIR 80RB, CASHBACK 5% NEXT ORDER'),
('Promo Oktober', '2025-10-16', '2026-02-28', NULL);

-- Master Leads
INSERT INTO `leads` (`nama`, `no_hp`, `sumber`, `jenis_cs`, `catatan`) VALUES
('Andi Setiawan', '081234567890', 'Instagram', 'CS Eksternal', 'Handle area Surabaya'),
('Dewi Lestari', '082198765432', 'WhatsApp', 'Reseller', 'Fokus paket Classic'),
('Rizky Fadillah', '085312345678', 'Referral', 'CS Eksternal', NULL);

-- Stok Adjustment history
INSERT INTO `stok_adjustment` (`barang_id`, `tipe`, `qty_sebelum`, `qty_sesudah`, `selisih`, `keterangan`, `created_at`) VALUES
(7, 'Penambahan', 0, 6, 6, 'stok awal', '2026-03-02 00:00:00');

-- Default Settings (WhatsApp)
INSERT INTO `settings` (`key_name`, `value`) VALUES
('wa_enabled', 'false'),
('wa_api_token', ''),
('wa_nomor_pengirim', ''),
('wa_template_order_baru', 'Halo {nama},\n\nOrder Anda telah diterima!\n\nDetail Order:\n• No. Order: {noOrder}\n• Paket: {paket}\n• Qty: {qty} pcs\n• Status: Sedang Diproses');

SET FOREIGN_KEY_CHECKS = 1;
