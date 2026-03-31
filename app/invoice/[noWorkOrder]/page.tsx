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

  async function handleExportPDF() {
    const { default: jsPDF } = await import('jspdf');
    const { default: autoTable } = await import('jspdf-autotable');
    const doc = new jsPDF({ unit: 'mm', format: 'a4' });
    const W = doc.internal.pageSize.getWidth();
    const m = 18;
    const cw = W - m * 2; // content width
    let y = m;

    // === HEADER BAR ===
    doc.setFillColor(15, 23, 42); // slate-900
    doc.rect(0, 0, W, 40, 'F');
    doc.setFont('helvetica', 'bold'); doc.setTextColor(255);
    doc.setFontSize(22);
    doc.text('AYRES', m, 18);
    doc.setFontSize(9); doc.setFont('helvetica', 'normal');
    doc.setTextColor(148, 163, 184); // slate-400
    doc.text('ORDER INVOICE', m, 25);

    // Right meta on header
    doc.setFontSize(7.5);
    const rightX = W - m;
    doc.setTextColor(148, 163, 184);
    doc.text('INVOICE', rightX, 12, { align: 'right' });
    doc.setTextColor(255); doc.setFont('helvetica', 'bold'); doc.setFontSize(10);
    doc.text(order.noWorkOrder, rightX, 18, { align: 'right' });
    doc.setFont('helvetica', 'normal'); doc.setTextColor(148, 163, 184); doc.setFontSize(7.5);
    doc.text(formatDate(order.dpProduksi), rightX, 24, { align: 'right' });

    y = 50;

    // === INFO GRID ===
    doc.setTextColor(100, 116, 139); // slate-500
    doc.setFontSize(7); doc.setFont('helvetica', 'normal');
    const col1 = m, col2 = m + 55, col3 = m + 110;

    // Row 1
    doc.text('CUSTOMER', col1, y);
    doc.text('NO. WHATSAPP', col2, y);
    doc.text('DEADLINE', col3, y);
    y += 4;
    doc.setTextColor(30, 41, 59); doc.setFont('helvetica', 'bold'); doc.setFontSize(9);
    doc.text(order.customer, col1, y);
    doc.setFont('helvetica', 'normal');
    doc.text(order.customerPhone || '-', col2, y);
    doc.text(formatDate(order.dlCust), col3, y);

    y += 10;
    doc.setTextColor(100, 116, 139); doc.setFontSize(7); doc.setFont('helvetica', 'normal');
    doc.text('ORDER #', col1, y);
    doc.text('PAKET', col2, y);
    doc.text('BAHAN', col3, y);
    y += 4;
    doc.setTextColor(30, 41, 59); doc.setFont('helvetica', 'bold'); doc.setFontSize(9);
    doc.text(String(order.no), col1, y);
    doc.setFont('helvetica', 'normal');
    doc.text(`${order.paket1} ${order.paket2}`, col2, y);
    doc.text(order.bahan || '-', col3, y);

    // === DIVIDER ===
    y += 10;
    doc.setDrawColor(226, 232, 240); doc.setLineWidth(0.3);
    doc.line(m, y, W - m, y);

    // === TABLE ===
    y += 4;
    autoTable(doc, {
      startY: y,
      margin: { left: m, right: m },
      head: [['DESKRIPSI', 'QTY', 'HARGA SATUAN', 'JUMLAH']],
      body: [[
        `${order.paket1} ${order.paket2} - ${order.customer}${order.keterangan ? '\n' + order.keterangan : ''}`,
        String(order.qty),
        formatCurrency(unitPrice),
        formatCurrency(order.sallaryProduct),
      ]],
      styles: { fontSize: 8, cellPadding: 4, lineColor: [226, 232, 240], lineWidth: 0.2, textColor: [30, 41, 59] },
      headStyles: { fillColor: [241, 245, 249], textColor: [100, 116, 139], fontStyle: 'bold', fontSize: 7, halign: 'left' },
      columnStyles: {
        0: { cellWidth: 'auto' },
        1: { cellWidth: 20, halign: 'center' },
        2: { cellWidth: 35, halign: 'right' },
        3: { cellWidth: 35, halign: 'right', fontStyle: 'bold' },
      },
      theme: 'grid',
    });

    y = (doc as ReturnType<typeof jsPDF> & { lastAutoTable: { finalY: number } }).lastAutoTable.finalY + 6;

    // === PROGRESS STAGES ===
    doc.setFontSize(7); doc.setTextColor(100, 116, 139); doc.setFont('helvetica', 'bold');
    doc.text('PROGRESS PRODUKSI', m, y);
    y += 5;

    const pillH = 6;
    const gap = 1.5;
    const pillW = (cw - gap * (STAGES.length - 1)) / STAGES.length;
    STAGES.forEach((stage, i) => {
      const x = m + i * (pillW + gap);
      const checked = order.progress[stage.key as keyof typeof order.progress];
      const r = 1.5; // radius

      if (checked) {
        doc.setFillColor(79, 70, 229); // indigo-600
        doc.roundedRect(x, y, pillW, pillH, r, r, 'F');
        doc.setTextColor(255);
      } else {
        doc.setDrawColor(203, 213, 225);
        doc.roundedRect(x, y, pillW, pillH, r, r, 'S');
        doc.setTextColor(148, 163, 184);
      }
      doc.setFont('helvetica', 'bold'); doc.setFontSize(5.5);
      doc.text(stage.label.toUpperCase(), x + pillW / 2, y + pillH / 2 + 1, { align: 'center' });
    });

    // === BOTTOM SECTION: Notes + Totals ===
    y += pillH + 14;
    doc.setDrawColor(226, 232, 240); doc.setLineWidth(0.3);
    doc.line(m, y, W - m, y);
    y += 8;

    // Notes (left)
    doc.setFillColor(248, 250, 252);
    doc.roundedRect(m, y, cw * 0.55, 30, 2, 2, 'F');
    doc.setFont('helvetica', 'bold'); doc.setFontSize(7); doc.setTextColor(30, 41, 59);
    doc.text('CATATAN', m + 4, y + 6);
    doc.setFont('helvetica', 'normal'); doc.setTextColor(100, 116, 139); doc.setFontSize(7.5);
    doc.text(`DP Produksi  :  ${formatDate(order.dpProduksi)}`, m + 4, y + 12);
    doc.text(`Tgl Selesai    :  ${formatDate(order.tglSelesai)}`, m + 4, y + 17);
    doc.text(`Status Kirim  :  ${order.tglKirim ? formatDate(order.tglKirim) : 'Belum dikirim'}`, m + 4, y + 22);

    // Totals (right)
    const tX = m + cw * 0.6;
    const tW = cw * 0.4;
    doc.setFontSize(8); doc.setTextColor(100, 116, 139); doc.setFont('helvetica', 'normal');
    doc.text('Subtotal', tX, y + 6);
    doc.text(formatCurrency(order.sallaryProduct), tX + tW, y + 6, { align: 'right' });
    doc.text('Shipping', tX, y + 12);
    doc.text(formatCurrency(order.sallaryShipping), tX + tW, y + 12, { align: 'right' });

    doc.setDrawColor(30, 41, 59); doc.setLineWidth(0.4);
    doc.line(tX, y + 16, tX + tW, y + 16);

    doc.setFont('helvetica', 'bold'); doc.setFontSize(11); doc.setTextColor(30, 41, 59);
    doc.text('GRAND TOTAL', tX, y + 24);
    doc.text(formatCurrency(grandTotal), tX + tW, y + 24, { align: 'right' });

    // === FOOTER ===
    const footerY = doc.internal.pageSize.getHeight() - 12;
    doc.setDrawColor(226, 232, 240); doc.setLineWidth(0.2);
    doc.line(m, footerY - 4, W - m, footerY - 4);
    doc.setFontSize(6.5); doc.setTextColor(148, 163, 184); doc.setFont('helvetica', 'normal');
    doc.text('AYRES Production System', m, footerY);
    doc.text(`Invoice ${order.noWorkOrder}`, W / 2, footerY, { align: 'center' });
    doc.text('Terima kasih atas kepercayaan Anda', W - m, footerY, { align: 'right' });

    doc.save(`invoice-${order.noWorkOrder}.pdf`);
  }

  return (
    <div className="min-h-screen bg-[#f2efe8] px-4 py-8 text-slate-900 print:bg-white print:p-0">
      {/* Export button — hidden on print */}
      <div className="mx-auto max-w-6xl mb-4 flex justify-end print:hidden">
        <button
          onClick={handleExportPDF}
          className="flex items-center gap-2 bg-slate-900 hover:bg-slate-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M6 9V2h12v7M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2m-1 4H7a1 1 0 01-1-1v-4a1 1 0 011-1h10a1 1 0 011 1v4a1 1 0 01-1 1z"/></svg>
          Export PDF
        </button>
      </div>

      <div id="invoice-content" className="mx-auto max-w-6xl border border-slate-400 bg-white p-6 shadow-sm md:p-10 print:border-0 print:shadow-none print:p-6">
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
