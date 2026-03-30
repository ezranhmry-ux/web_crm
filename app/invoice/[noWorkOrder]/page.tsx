'use client';

import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useEffect, useMemo, useState } from 'react';
import { apiGetTracking } from '@/lib/api';
import { STAGES } from '@/lib/constants';
import { Order } from '@/lib/types';
import { formatDate } from '@/lib/utils';

export default function InvoicePage() {
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
          setError(res.error || 'Invoice tidak ditemukan');
        }
      } catch {
        if (mounted) setError('Gagal memuat invoice');
      } finally {
        if (mounted) setLoading(false);
      }
    })();

    return () => {
      mounted = false;
    };
  }, [noWorkOrder]);

  const progressItems = useMemo(() => {
    if (!order) return [];
    return STAGES.map((stage) => ({
      label: stage.label,
      checked: order.progress[stage.key as keyof typeof order.progress],
    }));
  }, [order]);

  if (loading) {
    return (
      <div className="min-h-screen bg-[#f2efe8] px-4 py-8">
        <div className="mx-auto max-w-6xl border border-slate-300 bg-white p-8 shadow-sm">
          Memuat invoice...
        </div>
      </div>
    );
  }

  if (error || !order) {
    return (
      <div className="min-h-screen bg-[#f2efe8] px-4 py-8">
        <div className="mx-auto max-w-3xl border border-slate-300 bg-white p-8 text-center shadow-sm">
          <h1 className="text-3xl font-black uppercase tracking-tight text-slate-900">Order Invoice</h1>
          <p className="mt-4 text-sm text-red-600">{error || 'Data invoice tidak ditemukan'}</p>
          <Link href="/" className="mt-6 inline-flex border border-slate-900 px-5 py-2 text-sm font-bold uppercase text-slate-900">
            Kembali
          </Link>
        </div>
      </div>
    );
  }

  const unitPrice = order.qty > 0 ? Math.round(order.sallaryProduct / order.qty) : order.sallaryProduct;
  const grandTotal = order.sallaryProduct + order.sallaryShipping;

  return (
    <div className="min-h-screen bg-[#f2efe8] px-4 py-8 text-slate-900">
      <div className="mx-auto max-w-6xl border border-slate-400 bg-white p-6 shadow-sm md:p-10">
        <div className="flex flex-wrap items-start justify-between gap-4 border-b-2 border-slate-900 pb-6">
          <div>
            <p className="text-5xl font-black uppercase leading-none tracking-tight">AYRES</p>
            <p className="mt-1 text-2xl font-black uppercase leading-none tracking-tight">Order Invoice</p>
          </div>

          <div className="grid gap-x-8 gap-y-2 text-sm sm:grid-cols-2">
            <Meta label="Order #" value={String(order.no)} />
            <Meta label="Shipping" value="Manual Confirmation" />
            <Meta label="Date" value={formatDate(order.dpProduksi)} />
            <Meta label="Invoice" value={order.noWorkOrder} />
            <Meta label="Submit" value="Customer Service" />
            <Meta label="Deadline" value={formatDate(order.dlCust)} />
          </div>
        </div>

        <div className="mt-6 flex flex-wrap items-start justify-between gap-6">
          <div className="text-sm">
            <p className="font-bold uppercase">Ship To:</p>
            <p className="mt-2">{order.customer}</p>
            <p>{order.customerPhone || '-'}</p>
            <p>Tracking produksi berbasis No. WO</p>
          </div>

          <Link
            href={`/tracking/${encodeURIComponent(order.noWorkOrder)}`}
            className="border border-slate-900 px-4 py-2 text-xs font-bold uppercase tracking-wide text-slate-900"
          >
            Tracking
          </Link>
        </div>

        <div className="mt-8 border-y-2 border-slate-900 py-3">
          <div className="grid grid-cols-[90px_minmax(0,1fr)_140px_140px] gap-4 text-sm font-black uppercase">
            <div>Qty</div>
            <div>Description</div>
            <div className="text-right">Unit Price</div>
            <div className="text-right">Amount</div>
          </div>
        </div>

        <div className="border-b border-slate-300 px-0 py-5">
          <div className="grid grid-cols-[90px_minmax(0,1fr)_140px_140px] gap-4 text-sm">
            <div className="font-semibold">{order.qty}</div>
            <div>
              <p className="font-semibold">{buildDescription(order)}</p>
              <p className="mt-3 text-slate-600">{order.keterangan || '-'}</p>
              <p className="mt-1 text-slate-600">Bahan: {order.bahan || '-'}</p>
            </div>
            <div className="text-right">{formatCurrency(unitPrice)}</div>
            <div className="text-right font-semibold">{formatCurrency(order.sallaryProduct)}</div>
          </div>

          <div className="mt-6 border-t border-slate-200 pt-5">
            <div className="flex flex-wrap gap-3">
              {progressItems.map((item) => (
                <div key={item.label} className="min-w-24 text-center">
                  <div className={`inline-flex min-h-10 min-w-10 items-center justify-center border px-3 py-2 text-xs font-bold uppercase ${item.checked ? 'border-slate-900 bg-slate-900 text-white' : 'border-slate-400 bg-white text-slate-700'}`}>
                    {item.label}
                  </div>
                  <p className="mt-1 text-xs font-semibold">{item.checked ? '1/1' : '0/1'}</p>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="mt-8 grid gap-6 md:grid-cols-[1fr_280px]">
          <div className="min-h-32 border border-slate-300 p-4 text-sm text-slate-600">
            <p className="font-bold uppercase text-slate-900">Catatan</p>
            <p className="mt-2">DP Produksi: {formatDate(order.dpProduksi)}</p>
            <p>Tgl Selesai: {formatDate(order.tglSelesai)}</p>
            <p>Status Kirim: {order.tglKirim ? formatDate(order.tglKirim) : 'Belum dikirim'}</p>
          </div>

          <div className="space-y-3 border-t-2 border-slate-900 pt-4 text-sm">
            <TotalRow label="Total" value={formatCurrency(order.sallaryProduct)} />
            <TotalRow label="Shipping" value={formatCurrency(order.sallaryShipping)} />
            <div className="flex items-center justify-between border-t-2 border-slate-900 pt-3 text-lg font-black uppercase">
              <span>Grand Total</span>
              <span>{formatCurrency(grandTotal)}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function Meta({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-start gap-2 whitespace-nowrap">
      <span className="font-black uppercase">{label}</span>
      <span>:</span>
      <span className="font-semibold">{value}</span>
    </div>
  );
}

function TotalRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between font-semibold uppercase">
      <span>{label}</span>
      <span>{value}</span>
    </div>
  );
}

function buildDescription(order: Order) {
  return `${order.paket1} ${order.paket2} - ${order.customer}`;
}

function formatCurrency(value: number) {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    maximumFractionDigits: 0,
  }).format(value || 0);
}
