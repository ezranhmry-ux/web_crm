'use client';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth-context';
import { apiAddOrder } from '@/lib/api';
import { PAKET1_OPTIONS, PAKET2_OPTIONS } from '@/lib/constants';
import { fromInputDate, formatDate } from '@/lib/utils';

interface FormData {
  customer: string;
  customerPhone: string;
  sallaryProduct: string;
  sallaryShipping: string;
  qty: string;
  paket1: string;
  paket2: string;
  keterangan: string;
  bahan: string;
  dpProduksi: string;
  dlCust: string;
}

const EMPTY: FormData = {
  customer: '', customerPhone: '', sallaryProduct: '', sallaryShipping: '', qty: '', paket1: 'PRO', paket2: 'A',
  keterangan: '', bahan: '', dpProduksi: '', dlCust: '',
};

export default function NewOrderPage() {
  const { user } = useAuth();
  const router = useRouter();
  const [form, setForm] = useState<FormData>(EMPTY);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState<{
    noWO: string;
    tglSelesai: string;
    trackingLink: string;
    sallaryProduct: number;
    sallaryShipping: number;
  } | null>(null);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (user && user.role === 'produksi') {
      router.replace('/production');
    }
  }, [user]);

  function set(field: keyof FormData) {
    return (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
      setForm(prev => ({ ...prev, [field]: e.target.value }));
    };
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!form.customer.trim()) { setError('Customer wajib diisi'); return; }
    if (!form.customerPhone.trim()) { setError('Nomor WhatsApp customer wajib diisi'); return; }
    if (!form.sallaryProduct || Number(form.sallaryProduct) < 0) { setError('Sallary product wajib diisi'); return; }
    if (!form.sallaryShipping || Number(form.sallaryShipping) < 0) { setError('Sallary pengiriman wajib diisi'); return; }
    if (!form.qty || Number(form.qty) <= 0) { setError('Qty harus lebih dari 0'); return; }
    if (!form.dpProduksi) { setError('Tanggal DP Produksi wajib diisi'); return; }
    if (!form.dlCust) { setError('Deadline Customer wajib diisi'); return; }

    setError('');
    setSubmitting(true);
    try {
      const payload = {
        customer: form.customer.trim(),
        customerPhone: form.customerPhone.trim(),
        sallaryProduct: Number(form.sallaryProduct),
        sallaryShipping: Number(form.sallaryShipping),
        qty: Number(form.qty),
        paket1: form.paket1,
        paket2: form.paket2,
        keterangan: form.keterangan.trim(),
        bahan: form.bahan.trim(),
        dpProduksi: fromInputDate(form.dpProduksi),
        dlCust: fromInputDate(form.dlCust),
      };
      const res = await apiAddOrder(payload);
      if (res.success && res.data) {
        setSuccess({
          noWO: res.data.noWorkOrder,
          tglSelesai: res.data.tglSelesai,
          sallaryProduct: res.data.sallaryProduct,
          sallaryShipping: res.data.sallaryShipping,
          trackingLink: res.data.trackingLink,
        });
        setForm(EMPTY);
      } else {
        setError(res.error || 'Gagal menyimpan order');
      }
    } catch {
      setError('Gagal terhubung ke server');
    }
    setSubmitting(false);
  }

  async function copyTrackingLink() {
    if (!success?.trackingLink || typeof window === 'undefined') return;
    const absolute = new URL(success.trackingLink, window.location.origin).toString();
    await navigator.clipboard.writeText(absolute);
    setCopied(true);
    window.setTimeout(() => setCopied(false), 1600);
  }

  /* ── Success screen ── */
  if (success) {
    return (
      <div className="max-w-lg mx-auto">
        <div className="rounded-2xl border border-white/[0.06] bg-white/[0.02] p-8 text-center">
          <div className="w-14 h-14 rounded-full bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center mx-auto mb-5">
            <svg className="w-7 h-7 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7"/>
            </svg>
          </div>
          <h2 className="text-xl font-bold text-white/90 mb-1.5">Order Berhasil Disimpan!</h2>
          <p className="text-white/30 text-[13px] mb-6">Order telah ditambahkan ke sistem dan spreadsheet.</p>

          <div className="rounded-xl bg-white/[0.03] border border-white/[0.06] p-4 mb-6 text-left space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-[13px] text-white/30">No. Work Order</span>
              <span className="text-[13px] font-bold text-indigo-400 font-mono">{success.noWO}</span>
            </div>
            <div className="h-px bg-white/[0.04]" />
            <div className="flex justify-between items-center">
              <span className="text-[13px] text-white/30">Estimasi Selesai</span>
              <span className="text-[13px] font-bold text-white/70">{formatDate(success.tglSelesai)}</span>
            </div>
            <div className="h-px bg-white/[0.04]" />
            <div className="flex justify-between items-center">
              <span className="text-[13px] text-white/30">Sallary Product</span>
              <span className="text-[13px] font-bold text-white/70">{formatCurrency(success.sallaryProduct)}</span>
            </div>
            <div className="h-px bg-white/[0.04]" />
            <div className="flex justify-between items-center">
              <span className="text-[13px] text-white/30">Sallary Pengiriman</span>
              <span className="text-[13px] font-bold text-white/70">{formatCurrency(success.sallaryShipping)}</span>
            </div>
            <div className="h-px bg-white/[0.04]" />
            <div className="space-y-2">
              <span className="text-[13px] text-white/30 block">Link Tracking</span>
              <div className="rounded-lg bg-black/20 border border-white/[0.05] px-3 py-2 text-[11px] text-white/40 break-all font-mono">
                {typeof window !== 'undefined' ? new URL(success.trackingLink, window.location.origin).toString() : success.trackingLink}
              </div>
              <p className="text-[11px] text-amber-400/60">Link ini disiapkan untuk dikirim manual ke WhatsApp customer oleh admin.</p>
            </div>
          </div>

          <div className="flex gap-2.5 flex-wrap">
            <button onClick={copyTrackingLink}
              className="flex-1 min-w-[130px] bg-emerald-500/10 hover:bg-emerald-500/15 border border-emerald-500/20 text-emerald-400 py-2.5 rounded-xl text-[13px] font-medium transition-colors">
              {copied ? 'Link Tersalin' : 'Copy Link Tracking'}
            </button>
            <button onClick={() => setSuccess(null)}
              className="flex-1 min-w-[130px] bg-white/[0.04] hover:bg-white/[0.06] border border-white/[0.06] text-white/50 py-2.5 rounded-xl text-[13px] font-medium transition-colors">
              Input Order Lagi
            </button>
            <button onClick={() => router.push('/orders')}
              className="flex-1 min-w-[130px] bg-indigo-600 hover:bg-indigo-500 text-white py-2.5 rounded-xl text-[13px] font-medium transition-colors shadow-lg shadow-indigo-600/20">
              Lihat Semua Order
            </button>
          </div>
        </div>
      </div>
    );
  }

  /* ── Form ── */
  return (
    <div className="max-w-2xl mx-auto">
      <div className="rounded-2xl border border-white/[0.06] bg-white/[0.02] overflow-hidden">
        {/* Header */}
        <div className="px-7 py-5 border-b border-white/[0.04]">
          <h2 className="font-semibold text-white/90 flex items-center gap-2.5 text-[15px]">
            <div className="w-7 h-7 rounded-lg bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center">
              <svg className="w-3.5 h-3.5 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4"/>
              </svg>
            </div>
            Form Input Order Baru
          </h2>
          <p className="text-[13px] text-white/25 mt-1 ml-[38px]">Isi data order, sistem akan otomatis menghitung tanggal estimasi selesai</p>
        </div>

        <form onSubmit={handleSubmit} className="p-7 space-y-6">
          {/* Section: Customer Info */}
          <div>
            <SectionTitle>Informasi Customer</SectionTitle>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-3">
              <div>
                <Label>Customer <Req /></Label>
                <input type="text" value={form.customer} onChange={set('customer')}
                  placeholder="Nama customer" className={inputCls} required />
              </div>
              <div>
                <Label>No. WhatsApp <Req /></Label>
                <input type="tel" value={form.customerPhone} onChange={set('customerPhone')}
                  placeholder="0812xxxx" className={inputCls} required />
              </div>
            </div>
          </div>

          {/* Section: Pricing & Quantity */}
          <div>
            <SectionTitle>Harga & Kuantitas</SectionTitle>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-3">
              <div>
                <Label>Sallary Product <Req /></Label>
                <div className="relative">
                  <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[12px] text-white/20 font-medium">Rp</span>
                  <input type="number" value={form.sallaryProduct} onChange={set('sallaryProduct')}
                    placeholder="33000" min={0} className={`${inputCls} pl-9`} required />
                </div>
              </div>
              <div>
                <Label>Sallary Pengiriman <Req /></Label>
                <div className="relative">
                  <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[12px] text-white/20 font-medium">Rp</span>
                  <input type="number" value={form.sallaryShipping} onChange={set('sallaryShipping')}
                    placeholder="12000" min={0} className={`${inputCls} pl-9`} required />
                </div>
              </div>
              <div>
                <Label>Qty (pcs) <Req /></Label>
                <input type="number" value={form.qty} onChange={set('qty')}
                  placeholder="0" min={1} className={inputCls} required />
              </div>
            </div>
          </div>

          {/* Section: Product */}
          <div>
            <SectionTitle>Detail Produk</SectionTitle>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-3">
              <div>
                <Label>Paket 1 (Jenis Produk) <Req /></Label>
                <select value={form.paket1} onChange={set('paket1')} className={selectCls}>
                  {PAKET1_OPTIONS.map(o => <option key={o} value={o}>{o}</option>)}
                </select>
              </div>
              <div>
                <Label>Paket 2 (Grade) <Req /></Label>
                <select value={form.paket2} onChange={set('paket2')} className={selectCls}>
                  {PAKET2_OPTIONS.map(o => <option key={o} value={o}>{o}</option>)}
                </select>
              </div>
              <div>
                <Label>Bahan</Label>
                <input type="text" value={form.bahan} onChange={set('bahan')}
                  placeholder="Jenis bahan" className={inputCls} />
              </div>
              <div>
                <Label>Keterangan</Label>
                <input type="text" value={form.keterangan} onChange={set('keterangan')}
                  placeholder="Keterangan tambahan" className={inputCls} />
              </div>
            </div>
          </div>

          {/* Section: Dates */}
          <div>
            <SectionTitle>Jadwal</SectionTitle>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-3">
              <div>
                <Label>DP Produksi (Tanggal Mulai) <Req /></Label>
                <input type="date" value={form.dpProduksi} onChange={set('dpProduksi')}
                  className={inputCls} required />
              </div>
              <div>
                <Label>Deadline Customer <Req /></Label>
                <input type="date" value={form.dlCust} onChange={set('dlCust')}
                  className={inputCls} required />
              </div>
            </div>
          </div>

          {/* Info box */}
          <div className="flex items-start gap-3 p-4 rounded-xl bg-indigo-500/[0.06] border border-indigo-500/10">
            <div className="w-5 h-5 rounded-full bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center shrink-0 mt-0.5">
              <svg className="w-3 h-3 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
            <div className="text-[12px] text-indigo-300/60 leading-relaxed">
              <strong className="text-indigo-400/80">Auto Scheduling:</strong> Sistem akan otomatis mengalokasikan produksi berdasarkan kapasitas 200 pcs/hari dan menghitung Tanggal Estimasi Selesai (alokasi terakhir + 14 hari).
              <br />
              <strong className="text-indigo-400/80">Tracking:</strong> Setelah order disimpan, sistem menyiapkan link tracking yang nanti bisa dikirim manual ke WhatsApp customer oleh admin.
            </div>
          </div>

          {/* Error */}
          {error && (
            <div className="flex items-start gap-2.5 p-3.5 rounded-xl bg-red-500/[0.08] border border-red-500/15">
              <div className="w-4 h-4 rounded-full bg-red-500/15 flex items-center justify-center shrink-0 mt-0.5">
                <svg className="w-2.5 h-2.5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd"/>
                </svg>
              </div>
              <p className="text-[13px] text-red-400/80">{error}</p>
            </div>
          )}

          {/* Actions */}
          <div className="flex gap-3 pt-1">
            <button type="button" onClick={() => router.back()}
              className="flex-1 bg-white/[0.04] hover:bg-white/[0.06] border border-white/[0.06] text-white/40 hover:text-white/60 py-3 rounded-xl text-[13px] font-medium transition-all">
              Batal
            </button>
            <button type="submit" disabled={submitting}
              className="flex-[2] bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white py-3 rounded-xl text-[13px] font-semibold transition-all shadow-lg shadow-indigo-600/20 disabled:shadow-none">
              {submitting ? (
                <span className="flex items-center justify-center gap-2">
                  <svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
                  </svg>
                  Menyimpan...
                </span>
              ) : 'Simpan Order'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

const inputCls = 'w-full rounded-xl border border-white/[0.06] bg-white/[0.03] px-3.5 py-2.5 text-[13px] text-white/80 focus:outline-none focus:border-indigo-500/40 focus:bg-white/[0.05] focus:ring-1 focus:ring-indigo-500/20 transition-all placeholder-white/20';
const selectCls = 'w-full rounded-xl border border-white/[0.06] bg-white/[0.03] px-3.5 py-2.5 text-[13px] text-white/80 focus:outline-none focus:border-indigo-500/40 focus:bg-white/[0.05] focus:ring-1 focus:ring-indigo-500/20 transition-all appearance-none cursor-pointer';

function SectionTitle({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex items-center gap-2 mb-0.5">
      <div className="w-1 h-4 rounded-full bg-gradient-to-b from-indigo-500 to-violet-500" />
      <span className="text-[12px] font-semibold text-white/40 uppercase tracking-wider">{children}</span>
    </div>
  );
}

function Label({ children }: { children: React.ReactNode }) {
  return <label className="block text-[12px] font-medium text-white/35 mb-1.5">{children}</label>;
}
function Req() {
  return <span className="text-red-400/60 ml-0.5">*</span>;
}

function formatCurrency(value: number) {
  return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(value || 0);
}
