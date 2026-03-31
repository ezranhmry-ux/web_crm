'use client';

import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useEffect, useMemo, useState } from 'react';
import { apiGetTracking } from '@/lib/api';
import { STAGES, STATUS_LABELS, STATUS_STYLES } from '@/lib/constants';
import { Order } from '@/lib/types';
import { formatDate, getCurrentStage, getProgressPercent } from '@/lib/utils';

export default function TrackingPage() {
  const params = useParams<{ noWorkOrder: string }>();
  const rawNoWorkOrder = Array.isArray(params?.noWorkOrder) ? params.noWorkOrder[0] : params?.noWorkOrder;
  const noWorkOrder = decodeURIComponent(rawNoWorkOrder || '');

  const [order, setOrder] = useState<Order | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!noWorkOrder) {
      setError('No. Work Order tidak valid');
      setLoading(false);
      return;
    }

    let mounted = true;
    (async () => {
      try {
        const res = await apiGetTracking(noWorkOrder);
        if (!mounted) return;
        if (res.success && res.data) {
          setOrder(res.data);
          setError('');
        } else {
          setError(res.error || 'Tracking order tidak ditemukan');
        }
      } catch {
        if (mounted) setError('Gagal memuat data tracking');
      } finally {
        if (mounted) setLoading(false);
      }
    })();

    return () => {
      mounted = false;
    };
  }, [noWorkOrder]);

  const progressPercent = useMemo(() => (
    order ? getProgressPercent(order.progress) : 0
  ), [order]);

  if (loading) {
    return (
      <div className="min-h-screen min-h-[100dvh] bg-[#f5f1ea] px-3 sm:px-4 py-6 sm:py-8 text-slate-600">
        <div className="mx-auto max-w-6xl rounded-[20px] sm:rounded-[28px] border border-white/60 bg-white/70 p-6 sm:p-8 shadow-sm">
          Memuat detail order...
        </div>
      </div>
    );
  }

  if (error || !order) {
    return (
      <div className="min-h-screen min-h-[100dvh] bg-[#f5f1ea] px-3 sm:px-4 py-6 sm:py-8">
        <div className="mx-auto max-w-3xl rounded-[20px] sm:rounded-[28px] border border-white/60 bg-white/80 p-6 sm:p-8 shadow-sm text-center">
          <h1 className="text-2xl font-semibold text-slate-800">Tracking Order</h1>
          <p className="mt-3 text-sm text-red-600">{error || 'Data order tidak ditemukan'}</p>
          <Link
            href="/"
            className="mt-6 inline-flex rounded-full bg-slate-900 px-5 py-2.5 text-sm font-medium text-white"
          >
            Kembali
          </Link>
        </div>
      </div>
    );
  }

  const currentStage = getCurrentStage(order.progress);

  return (
    <div className="min-h-screen min-h-[100dvh] bg-[#f5f1ea] px-3 sm:px-4 py-6 sm:py-8 text-slate-700">
      <div className="mx-auto max-w-6xl">
        <div className="mb-5 sm:mb-6 flex flex-wrap items-center justify-between gap-3">
          <div className="min-w-0">
            <p className="text-xs sm:text-sm uppercase tracking-[0.18em] text-slate-400">Order Details</p>
            <h1 className="text-xl sm:text-3xl font-semibold text-slate-900 truncate">{order.customer}</h1>
          </div>
          <Link
            href={`/invoice/${encodeURIComponent(order.noWorkOrder)}`}
            className="rounded-full border border-slate-200 bg-white px-4 sm:px-5 py-2 sm:py-2.5 text-xs sm:text-sm font-medium text-slate-700 shadow-sm shrink-0"
          >
            Invoice
          </Link>
        </div>

        <div className="grid gap-5 lg:grid-cols-[1.55fr_1fr]">
          <div className="space-y-5">
            <section className="rounded-[20px] sm:rounded-[24px] border border-white/70 bg-white/85 p-4 sm:p-5 shadow-sm">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <p className="text-sm sm:text-base font-semibold text-slate-800">Status Produksi</p>
                  <p className="mt-0.5 sm:mt-1 text-xs sm:text-sm text-slate-500">Progress produksi order saat ini.</p>
                </div>
                <span className={`rounded-full px-3 py-1 text-xs font-semibold ${STATUS_STYLES[order.status] || STATUS_STYLES.OPEN}`}>
                  {STATUS_LABELS[order.status] || order.status}
                </span>
              </div>

              <div className="mt-5">
                <div className="mb-2 flex items-center justify-between text-sm">
                  <span className="text-slate-500">Total progress</span>
                  <span className="font-semibold text-slate-800">{progressPercent}%</span>
                </div>
                <div className="h-3 overflow-hidden rounded-full bg-slate-100">
                  <div
                    className="h-full rounded-full bg-gradient-to-r from-amber-400 via-orange-500 to-emerald-500"
                    style={{ width: `${progressPercent}%` }}
                  />
                </div>
              </div>

              <div className="mt-5 grid gap-3 sm:grid-cols-2">
                <StatCard label="Tahap Saat Ini" value={currentStage} />
                <StatCard label="Estimasi Selesai" value={formatDate(order.tglSelesai)} />
              </div>
            </section>

            <section className="rounded-[20px] sm:rounded-[24px] border border-white/70 bg-white/85 p-4 sm:p-5 shadow-sm">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <div>
                  <p className="text-sm sm:text-base font-semibold text-slate-800">Detail Pesanan</p>
                  <p className="mt-0.5 sm:mt-1 text-xs sm:text-sm text-slate-500">Ringkasan item dan kebutuhan produksi.</p>
                </div>
                <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-600">
                  {order.noWorkOrder}
                </span>
              </div>

              <div className="mt-4 rounded-[20px] border border-slate-100 bg-[#fcfbf8] p-4">
                <div className="flex flex-wrap items-start justify-between gap-3 border-b border-dashed border-slate-200 pb-4">
                  <div>
                    <p className="text-sm font-semibold text-slate-800">{order.paket1} {order.paket2}</p>
                    <p className="mt-1 text-sm text-slate-500">{order.customer}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-xs uppercase tracking-[0.15em] text-slate-400">Qty</p>
                    <p className="text-lg font-semibold text-slate-900">{order.qty} pcs</p>
                  </div>
                </div>

                <div className="grid gap-3 py-4 sm:grid-cols-2">
                  <InfoBlock label="Bahan" value={order.bahan || '-'} />
                  <InfoBlock label="Keterangan" value={order.keterangan || '-'} />
                  <InfoBlock label="DP Produksi" value={formatDate(order.dpProduksi)} />
                  <InfoBlock label="Deadline Customer" value={formatDate(order.dlCust)} />
                </div>

                <div className="border-t border-dashed border-slate-200 pt-4">
                  <p className="mb-3 text-xs font-semibold uppercase tracking-[0.14em] text-slate-400">Tahapan Produksi</p>
                  <div className="grid grid-cols-3 gap-2 sm:gap-3 sm:grid-cols-3 lg:grid-cols-5">
                    {STAGES.map((stage) => {
                      const checked = order.progress[stage.key as keyof typeof order.progress];
                      return (
                        <div key={stage.key} className="text-center">
                          <div className={`mx-auto flex h-10 w-10 sm:h-12 sm:w-12 items-center justify-center rounded-full border-2 text-[10px] sm:text-xs font-semibold ${checked ? 'border-emerald-500 bg-emerald-50 text-emerald-600' : 'border-slate-200 bg-white text-slate-400'}`}>
                            {checked ? '100%' : '0%'}
                          </div>
                          <p className={`mt-2 text-xs font-medium ${checked ? 'text-slate-800' : 'text-slate-400'}`}>
                            {stage.label}
                          </p>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </section>
          </div>

          <div className="space-y-5">
            <SideCard
              title="Informasi Order"
              rows={[
                ['Order ID', String(order.no)],
                ['Nomor WO', order.noWorkOrder],
                ['Tanggal Order', formatDate(order.dpProduksi)],
                ['Estimasi Selesai', formatDate(order.tglSelesai)],
              ]}
            />

            <SideCard
              title="Informasi Customer"
              rows={[
                ['Customer', order.customer],
                ['WhatsApp', order.customerPhone || '-'],
                ['Deadline', formatDate(order.dlCust)],
                ['Status', STATUS_LABELS[order.status] || order.status],
              ]}
            />

            <SideCard
              title="Ringkasan Produksi"
              rows={[
                ['Progress', `${progressPercent}%`],
                ['Tahap Saat Ini', currentStage],
                ['Qty Pesanan', `${order.qty} pcs`],
                ['Tgl Kirim', order.tglKirim ? formatDate(order.tglKirim) : '-'],
              ]}
              highlightRow="Progress"
            />

            <div className="rounded-[20px] sm:rounded-[24px] border border-white/70 bg-white/85 p-4 sm:p-5 shadow-sm">
              <div className="flex items-start gap-3">
                <div className="mt-0.5 flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-slate-500">
                  <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-4 4v-4z" />
                  </svg>
                </div>
                <div>
                  <p className="text-sm font-semibold text-slate-800">Butuh bantuan terkait order ini?</p>
                  <p className="mt-1 text-xs leading-6 text-slate-500">
                    Hubungi admin atau customer service yang menangani pesanan ini untuk konfirmasi lebih lanjut.
                  </p>
                  <a href="https://wa.me/6287818310416" target="_blank" rel="noreferrer"
                    className="mt-2 inline-flex items-center gap-1.5 text-xs font-medium text-emerald-600 hover:text-emerald-700 transition-colors">
                    <svg className="w-3.5 h-3.5" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
                    087818310416
                  </a>
                  <p className="mt-1.5 text-xs text-slate-400">No. referensi: {order.noWorkOrder}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function SideCard({
  title,
  rows,
  highlightRow,
}: {
  title: string;
  rows: [string, string][];
  highlightRow?: string;
}) {
  return (
    <section className="rounded-[20px] sm:rounded-[24px] border border-white/70 bg-white/85 p-4 sm:p-5 shadow-sm">
      <p className="text-base font-semibold text-slate-800">{title}</p>
      <div className="mt-4 space-y-3">
        {rows.map(([label, value]) => (
          <div key={label} className="flex items-start justify-between gap-3 border-b border-dashed border-slate-100 pb-3 last:border-b-0 last:pb-0">
            <span className="text-sm text-slate-500">{label}</span>
            <span className={`text-right text-sm ${highlightRow === label ? 'font-semibold text-slate-900' : 'text-slate-700'}`}>
              {value}
            </span>
          </div>
        ))}
      </div>
    </section>
  );
}

function StatCard({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-[20px] border border-slate-100 bg-[#fcfbf8] p-4">
      <p className="text-xs uppercase tracking-[0.14em] text-slate-400">{label}</p>
      <p className="mt-2 text-base font-semibold text-slate-900">{value}</p>
    </div>
  );
}

function InfoBlock({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <p className="text-xs uppercase tracking-[0.14em] text-slate-400">{label}</p>
      <p className="mt-1 text-sm text-slate-700">{value}</p>
    </div>
  );
}
