# AYRES CRM — Sistem Manajemen Produksi

Sistem manajemen produksi dan CRM berbasis web untuk bisnis manufaktur apparel/jersey. Mengelola alur kerja dari leads, order, work order, produksi 12 tahap, stok bahan, hingga pengiriman — dengan role-based access control dan real-time tracking.

---

## Tech Stack

| Layer | Teknologi |
|-------|-----------|
| Framework | Next.js 16 (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS 4 |
| Database | MySQL (mysql2) |
| Auth | HMAC-SHA256 session cookie |
| PDF Export | jsPDF + jspdf-autotable |
| Canvas | html2canvas |

---

## Fitur Utama

### Dashboard (`/dashboard`)
- Ringkasan total pendapatan, jumlah order, pending, WO aktif, WO terlambat
- Daftar order terbaru & order berisiko tinggi
- Quick link ke pembuatan order dan master data

### Orders (`/orders`)
- CRUD order lengkap dengan multi-item support
- Filter berdasarkan status (PENDING, CONFIRMED, IN_PROGRESS, DONE, CANCELLED)
- Risk level badge (SAFE, NORMAL, NEAR, HIGH, OVERDUE)
- Tab bulan & pagination
- Detail order dengan progress bar 12 tahap
- Export PDF laporan mingguan & bulanan

### Work Orders (`/work-orders`)
- Generate WO otomatis dari order (format: `WO[YY][MM]-[NNN]`)
- Spesifikasi detail: desain, pola, bahan per bagian badan, ukuran
- Permintaan gudang (bahan utama, aksesoris, material tambahan)
- Detail item per pemain dengan assignment jahit
- Checklist pengiriman dengan item bonus

### Produksi (`/produksi`)
- Kanban board 12 tahap produksi:
  1. Proofing
  2. Printing Layout
  3. Approval Layout
  4. Printing Process
  5. Sublim Press
  6. QC Panel Process
  7. Fabric Cutting
  8. QC Cutting
  9. Sewing
  10. QC Jersey
  11. Finishing
  12. Shipment
- Status per WO: BELUM → TERSEDIA → SEDANG → SELESAI
- Assignment karyawan per tahap
- Akses tahap berdasarkan role

### Stok & Inventaris (`/stok`)
- Monitoring stok aktual per barang
- Adjustment stok (Penambahan, Pengurangan, Koreksi) dengan audit trail
- Satuan: PCS, KILOGRAM, METER, ROLL, LUSIN

### Master Data (`/master`)
- 10 entitas: Customer, Paket, Barang, Tipe Barang, Ukuran, Pecah Pola, Jabatan, Karyawan, Promo, Leads
- Full CRUD dengan pencarian
- Leads tracking dari sumber: Instagram, WhatsApp, Facebook, Referral, Website
- Jenis CS: Organic, Meta Ads, TikTok Ads, Corporate

### Laporan (`/laporan`)
- **Laporan Produksi** — Progress per tahap dengan date range picker
- **Laporan Penggunaan Bahan** — Konsumsi material per periode

### Setting (`/setting`)
- Manajemen user & role
- Menu access control per role
- Stage access untuk role produksi
- Integrasi WhatsApp (placeholder)

### Tracking Publik (`/tracking`)
- Halaman publik untuk customer cek progress pesanan
- Akses via nomor work order tanpa login

---

## Fitur per Role

| Fitur | Admin | CS | Produksi |
|-------|:-----:|:--:|:--------:|
| Dashboard | ✅ | ❌ | ❌ |
| Lihat order | ✅ | ✅ | ✅ |
| Input order baru | ✅ | ✅ | ❌ |
| Edit order | ✅ | ✅ | ❌ |
| Kelola work order | ✅ | ✅ | ❌ |
| Update progress produksi | ❌ | ❌ | ✅ |
| Stok & inventaris | ✅ | ❌ | ❌ |
| Master data | ✅ | ❌ | ❌ |
| Laporan & export PDF | ✅ | ❌ | ❌ |
| Setting & manajemen user | ✅ | ❌ | ❌ |

---

## Database

MySQL dengan 24 tabel:

| Grup | Tabel |
|------|-------|
| Auth | `users`, `roles`, `role_menu_access`, `role_stage_access` |
| Master | `customers`, `paket`, `barang`, `tipe_barang`, `ukuran`, `pecah_pola`, `jabatan`, `karyawan`, `promo`, `leads` |
| Order | `orders`, `order_items`, `order_promos` |
| Work Order | `work_orders`, `wo_progress`, `wo_spesifikasi`, `wo_spesifikasi_bahan`, `wo_permintaan_gudang`, `wo_detail_items`, `wo_pengiriman` |
| Produksi | `production_stages` |
| Inventaris | `stok`, `stok_adjustment` |
| Config | `settings` |

Schema lengkap tersedia di `database/ayres_crm.sql`.

---

## Setup & Instalasi

### 1. Clone & Install

```bash
git clone <repo-url>
cd web_crm
npm install
```

### 2. Database

Import schema ke MySQL:

```bash
mysql -u root -p ayres_crm < database/ayres_crm.sql
```

### 3. Environment Variable

Buat file `.env.local` di root project:

```env
SESSION_SECRET=your-secret-key
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=ayres_crm
```

### 4. Jalankan

```bash
npm run dev
```

Buka [http://localhost:3000](http://localhost:3000)

---

## Struktur Proyek

```
web_crm/
├── app/
│   ├── page.tsx                          # Login page
│   ├── layout.tsx                        # Root layout
│   ├── globals.css                       # Global styles
│   ├── tracking/                         # Public tracking page
│   ├── (protected)/
│   │   ├── layout.tsx                    # Sidebar & navigasi
│   │   ├── dashboard/page.tsx            # Dashboard admin
│   │   ├── orders/
│   │   │   ├── page.tsx                  # Daftar order
│   │   │   ├── [id]/page.tsx             # Detail order
│   │   │   └── create-order-drawer.tsx   # Form input order
│   │   ├── work-orders/
│   │   │   ├── page.tsx                  # Daftar work order
│   │   │   └── [id]/page.tsx             # Detail & editor WO
│   │   ├── produksi/page.tsx             # Kanban produksi
│   │   ├── stok/page.tsx                 # Inventaris & adjustment
│   │   ├── master/page.tsx               # Master data (10 entitas)
│   │   ├── laporan/
│   │   │   ├── produksi/page.tsx         # Laporan produksi
│   │   │   ├── penggunaan-bahan/page.tsx # Laporan bahan
│   │   │   └── date-range-picker.tsx     # Komponen date picker
│   │   └── setting/page.tsx              # User & role management
│   └── api/
│       ├── auth/                         # Login, logout, session
│       ├── db/[table]/route.ts           # Generic CRUD API
│       ├── roles/route.ts                # Role management API
│       ├── tracking/route.ts             # Public tracking API
│       ├── upload/route.ts               # File upload API
│       └── wo/update-status/route.ts     # WO progress update
├── lib/
│   ├── api.ts                            # API client & data mapping
│   ├── api-db.ts                         # Generic DB CRUD
│   ├── auth-context.tsx                  # Auth state (React Context)
│   ├── cache.ts                          # SessionStorage cache
│   ├── constants.ts                      # Stage names & labels
│   ├── db.ts                             # MySQL connection
│   ├── session.ts                        # HMAC session utils
│   ├── toast.tsx                         # Toast notifications
│   ├── types.ts                          # TypeScript interfaces
│   └── utils.ts                          # Helper functions
├── database/
│   └── ayres_crm.sql                     # MySQL schema
├── public/
│   ├── logo/                             # Brand assets
│   └── uploads/                          # User uploads
├── middleware.ts                          # Session verification
├── package.json
├── tsconfig.json
├── next.config.ts
└── LICENSE
```

---

## Logika Bisnis

### No Work Order
Format: `WO[YY][MM]-[NNN]` — Contoh: `WO2603-001` = order ke-1, Maret 2026

### Status Order

| Status | Kondisi |
|--------|---------|
| `PENDING` | Order baru, belum dikonfirmasi |
| `CONFIRMED` | Dikonfirmasi, siap dibuatkan WO |
| `IN_PROGRESS` | Sedang dalam produksi |
| `DONE` | Selesai & dikirim |
| `CANCELLED` | Dibatalkan |

### Risk Level

| Level | Kondisi |
|-------|---------|
| `SAFE` | Status DONE |
| `NORMAL` | Sisa hari > 7 |
| `NEAR` | Sisa hari 4–7 |
| `HIGH` | Sisa hari ≤ 3 |
| `OVERDUE` | Lewat deadline, belum DONE |

### Alur Progress Produksi
Setiap WO melewati 12 tahap secara berurutan. Status per tahap:
`BELUM` → `TERSEDIA` → `SEDANG` → `SELESAI`

---

## License

Proyek ini dilisensikan di bawah [MIT License](LICENSE).
