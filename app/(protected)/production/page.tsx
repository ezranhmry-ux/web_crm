'use client';
import { useEffect, useState, useMemo } from 'react';
import { useAuth } from '@/lib/auth-context';
import { apiGetOrders, apiGetOrdersForce } from '@/lib/api';
import { apiUpdateProgress } from '@/lib/api';
import { Order, Progress } from '@/lib/types';
import { STAGES, RISK_LABELS, STATUS_LABELS } from '@/lib/constants';
import { formatDate, getProgressPercent, getStageIndex } from '@/lib/utils';

const RISK_D: Record<string, string> = {
  SAFE: 'text-emerald-400 bg-emerald-500/10 border border-emerald-500/20',
  NORMAL: 'text-zinc-400 bg-zinc-800 border border-zinc-700',
  NEAR: 'text-amber-400 bg-amber-500/10 border border-amber-500/20',
  HIGH: 'text-red-400 bg-red-500/10 border border-red-500/20',
  OVERDUE: 'text-red-400 bg-red-500/15 border border-red-500/25',
};
const STATUS_D: Record<string, string> = {
  OPEN: 'text-blue-400 bg-blue-500/10 border border-blue-500/20',
  IN_PROGRESS: 'text-amber-400 bg-amber-500/10 border border-amber-500/20',
  DONE: 'text-emerald-400 bg-emerald-500/10 border border-emerald-500/20',
};

export default function ProductionPage() {
  const { user } = useAuth();
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<'ALL' | 'ACTIVE' | 'OVERDUE' | 'NEAR'>('ALL');
  const [dateFilter, setDateFilter] = useState('');
  const [expanded, setExpanded] = useState<number | null>(null);
  const [updating, setUpdating] = useState<string | null>(null);
  const [tglKirim, setTglKirim] = useState('');
  const [showTglKirim, setShowTglKirim] = useState<number | null>(null);

  useEffect(() => { fetchOrders(false); }, []);

  async function fetchOrders(force = false) {
    try {
      const res = force ? await apiGetOrdersForce() : await apiGetOrders();
      if (res.success && res.data) { setOrders(res.data); setError(''); }
      else setError(res.error || 'Gagal memuat data');
    } catch { setError('Gagal terhubung ke server'); }
    setLoading(false); setRefreshing(false);
  }

  const canEdit = user?.role === 'produksi' || user?.role === 'admin';

  const parseDateMs = (s: string) => {
    if (!s) return Infinity;
    const p = s.split('/');
    if (p.length === 3) return new Date(+p[2], +p[1] - 1, +p[0]).getTime();
    const d = new Date(s); return isNaN(d.getTime()) ? Infinity : d.getTime();
  };

  const sortedDates = useMemo(() => {
    const keys = new Set(orders.filter(o => o.status !== 'DONE').map(o => o.tglSelesai || o.dlCust || '').filter(Boolean));
    return Array.from(keys).sort((a, b) => parseDateMs(a) - parseDateMs(b));
  }, [orders]);

  const filtered = useMemo(() => {
    return orders
      .filter(o => o.status !== 'DONE' || filter === 'ALL')
      .filter(o => {
        if (filter === 'ACTIVE') return o.status === 'IN_PROGRESS' || o.status === 'OPEN';
        if (filter === 'OVERDUE') return o.riskLevel === 'OVERDUE';
        if (filter === 'NEAR') return o.riskLevel === 'NEAR' || o.riskLevel === 'HIGH';
        return true;
      })
      .filter(o => !search || o.customer.toLowerCase().includes(search.toLowerCase()) || o.noWorkOrder?.toLowerCase().includes(search.toLowerCase()))
      .filter(o => !dateFilter || (o.tglSelesai || o.dlCust || '') === dateFilter)
      .sort((a, b) => {
        const riskOrder = { OVERDUE: 0, HIGH: 1, NEAR: 2, NORMAL: 3, SAFE: 4 };
        return (riskOrder[a.riskLevel || 'NORMAL'] ?? 3) - (riskOrder[b.riskLevel || 'NORMAL'] ?? 3);
      });
  }, [orders, search, filter, dateFilter]);

  async function handleCheck(order: Order, stageKey: string, checked: boolean) {
    if (!canEdit) return;
    const stageIdx = STAGES.findIndex(s => s.key === stageKey);
    const lastIdx = getStageIndex(order.progress);
    if (checked && stageIdx > lastIdx + 1) { alert(`Harus menyelesaikan ${STAGES[lastIdx + 1]?.label} terlebih dahulu!`); return; }
    if (stageKey === 'PENGIRIMAN' && checked) { setShowTglKirim(order.rowIndex); return; }
    const key = `${order.rowIndex}-${stageKey}`;
    setUpdating(key);
    try {
      const res = await apiUpdateProgress({ rowIndex: order.rowIndex, stage: stageKey, checked });
      if (res.success) {
        setOrders(prev => prev.map(o => {
          if (o.rowIndex !== order.rowIndex) return o;
          const np = { ...o.progress, [stageKey]: checked };
          return { ...o, progress: np, status: np.PENGIRIMAN ? 'DONE' : Object.values(np).some(v => v) ? 'IN_PROGRESS' : 'OPEN' };
        }));
      }
    } catch { }
    setUpdating(null);
  }

  async function confirmPengiriman(order: Order) {
    setUpdating(`${order.rowIndex}-PENGIRIMAN`);
    try {
      const res = await apiUpdateProgress({ rowIndex: order.rowIndex, stage: 'PENGIRIMAN', checked: true, tglKirim: tglKirim || undefined });
      if (res.success) {
        setOrders(prev => prev.map(o => o.rowIndex !== order.rowIndex ? o : { ...o, progress: { ...o.progress, PENGIRIMAN: true }, status: 'DONE', tglKirim }));
      }
    } catch { }
    setUpdating(null); setShowTglKirim(null); setTglKirim('');
  }

  if (loading) return <BoardSkeleton />;
  if (error) return (
    <div className="flex flex-col items-center py-20">
      <p className="text-zinc-500 mb-4">{error}</p>
      <button onClick={() => fetchOrders(true)} className="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm">Coba Lagi</button>
    </div>
  );

  return (
    <div className="space-y-4 max-w-5xl mx-auto">
      {/* Controls */}
      <div className="flex flex-wrap gap-2 items-center">
        <div className="relative flex-1 min-w-48">
          <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
          </svg>
          <input type="text" placeholder="Cari customer atau WO..." value={search} onChange={e => setSearch(e.target.value)}
            className="w-full pl-9 pr-4 py-2 rounded-lg border border-zinc-800 bg-zinc-900 text-sm text-zinc-200 placeholder-zinc-600 focus:outline-none focus:border-zinc-600" />
        </div>

        {(['ALL', 'ACTIVE', 'OVERDUE', 'NEAR'] as const).map(f => (
          <button key={f} onClick={() => setFilter(f)}
            className={`px-3 py-2 rounded-lg text-[13px] font-medium transition-colors
              ${filter === f ? 'bg-zinc-100 text-zinc-900' : 'text-zinc-500 hover:text-zinc-200 hover:bg-zinc-800'}`}>
            {f === 'ALL' ? 'Semua' : f === 'ACTIVE' ? 'Aktif' : f === 'OVERDUE' ? 'Overdue' : 'Near DL'}
          </button>
        ))}

        <button onClick={() => { setRefreshing(true); fetchOrders(true); }} disabled={refreshing}
          className="text-zinc-500 hover:text-zinc-200 p-2 rounded-lg hover:bg-zinc-800 transition-colors">
          <svg className={`w-4 h-4 ${refreshing ? 'animate-spin' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
          </svg>
        </button>
      </div>

      {/* Date tabs */}
      {sortedDates.length > 0 && (
        <div className="flex gap-1 overflow-x-auto pb-0.5">
          <button onClick={() => setDateFilter('')}
            className={`shrink-0 px-3 py-1 rounded-md text-xs font-medium transition-colors
              ${!dateFilter ? 'bg-zinc-100 text-zinc-900' : 'text-zinc-500 hover:text-zinc-300 hover:bg-zinc-800'}`}>
            Semua
          </button>
          {sortedDates.map(dk => {
            const count = orders.filter(o => o.status !== 'DONE' && (o.tglSelesai || o.dlCust || '') === dk).length;
            return (
              <button key={dk} onClick={() => setDateFilter(dk)}
                className={`shrink-0 px-3 py-1 rounded-md text-xs font-medium transition-colors
                  ${dateFilter === dk ? 'bg-zinc-100 text-zinc-900' : 'text-zinc-500 hover:text-zinc-300 hover:bg-zinc-800'}`}>
                {formatDate(dk)} <span className="text-zinc-600 ml-0.5">{count}</span>
              </button>
            );
          })}
        </div>
      )}

      {/* Count */}
      <p className="text-xs text-zinc-600">{filtered.length} order ditampilkan</p>

      {/* Cards */}
      <div className="space-y-2">
        {filtered.map(order => (
          <OrderCard key={order.rowIndex} order={order} expanded={expanded === order.rowIndex}
            onToggle={() => setExpanded(prev => prev === order.rowIndex ? null : order.rowIndex)}
            onCheck={(stage, checked) => handleCheck(order, stage, checked)}
            updating={updating} canEdit={canEdit}
            onPengirimanClick={() => setShowTglKirim(order.rowIndex)} />
        ))}

        {filtered.length === 0 && (
          <div className="text-center py-16 rounded-xl border border-zinc-800 bg-zinc-900">
            <p className="text-zinc-600 text-sm">Tidak ada order yang sesuai filter</p>
          </div>
        )}
      </div>

      {/* Tgl Kirim modal */}
      {showTglKirim !== null && (() => {
        const order = orders.find(o => o.rowIndex === showTglKirim);
        if (!order) return null;
        return (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 grid place-items-center p-4">
            <div className="bg-zinc-900 border border-zinc-800 rounded-xl w-full max-w-sm p-5">
              <h3 className="font-semibold text-zinc-100 mb-1">Konfirmasi Pengiriman</h3>
              <p className="text-sm text-zinc-500 mb-4">Order: <strong className="text-zinc-300">{order.customer}</strong></p>
              <label className="block text-xs text-zinc-500 mb-1.5">Tanggal Kirim (opsional)</label>
              <input type="date" value={tglKirim} onChange={e => setTglKirim(e.target.value)}
                className="w-full rounded-lg border border-zinc-800 bg-zinc-800/50 px-3 py-2 text-sm text-zinc-200 focus:outline-none focus:border-zinc-600 mb-4" />
              <div className="flex gap-2">
                <button onClick={() => { setShowTglKirim(null); setTglKirim(''); }}
                  className="flex-1 py-2 rounded-lg text-sm text-zinc-400 hover:text-zinc-200 bg-zinc-800 hover:bg-zinc-700 transition-colors">Batal</button>
                <button onClick={() => confirmPengiriman(order)}
                  className="flex-1 py-2 rounded-lg text-sm text-white bg-emerald-600 hover:bg-emerald-500 transition-colors font-medium">Konfirmasi</button>
              </div>
            </div>
          </div>
        );
      })()}
    </div>
  );
}

function OrderCard({ order, expanded, onToggle, onCheck, updating, canEdit, onPengirimanClick }: {
  order: Order; expanded: boolean; onToggle: () => void;
  onCheck: (stage: string, checked: boolean) => void;
  updating: string | null; canEdit: boolean; onPengirimanClick: () => void;
}) {
  const pct = getProgressPercent(order.progress);
  const lastIdx = getStageIndex(order.progress);
  const isHigh = order.riskLevel === 'HIGH' || order.riskLevel === 'OVERDUE';

  return (
    <div className={`rounded-xl border overflow-hidden transition-colors ${isHigh ? 'border-red-500/20 bg-red-500/[0.02]' : 'border-zinc-800 bg-zinc-900'}`}>
      <div className="p-4 cursor-pointer hover:bg-zinc-800/30 transition-colors" onClick={onToggle}>
        <div className="flex items-start gap-4">
          {/* Progress ring */}
          <div className="shrink-0 relative w-11 h-11">
            <svg className="w-11 h-11 -rotate-90" viewBox="0 0 44 44">
              <circle cx="22" cy="22" r="18" fill="none" stroke="#27272a" strokeWidth="3"/>
              <circle cx="22" cy="22" r="18" fill="none" stroke={pct === 100 ? '#22c55e' : '#6366f1'} strokeWidth="3"
                strokeDasharray={`${2 * Math.PI * 18}`}
                strokeDashoffset={`${2 * Math.PI * 18 * (1 - pct / 100)}`}
                strokeLinecap="round" className="transition-all duration-500"
              />
            </svg>
            <span className="absolute inset-0 flex items-center justify-center text-[11px] font-bold text-zinc-300">{pct}%</span>
          </div>

          <div className="flex-1 min-w-0">
            <div className="flex items-start justify-between gap-2 mb-1.5">
              <div>
                <h3 className="font-semibold text-zinc-100 text-[14px]">{order.customer}</h3>
                <p className="text-xs text-zinc-600">{order.noWorkOrder || `#${order.no}`} · {order.qty} pcs · {order.paket1} {order.paket2}</p>
              </div>
              <div className="flex items-center gap-1.5 shrink-0">
                <span className={`text-[11px] px-2 py-0.5 rounded-md font-medium ${RISK_D[order.riskLevel || 'NORMAL']}`}>
                  {RISK_LABELS[order.riskLevel || 'NORMAL']}
                </span>
                <span className={`text-[11px] px-2 py-0.5 rounded-md font-medium ${STATUS_D[order.status]}`}>
                  {STATUS_LABELS[order.status]}
                </span>
              </div>
            </div>

            {/* Stage pills */}
            <div className="flex flex-wrap gap-1 mb-2">
              {STAGES.map((s, i) => {
                const done = order.progress[s.key as keyof Progress];
                const current = !done && i === lastIdx + 1;
                return (
                  <span key={s.key}
                    className={`text-[11px] px-2 py-0.5 rounded-md font-medium transition-colors
                      ${done ? 'bg-indigo-600 text-white' : current ? 'bg-amber-500/15 text-amber-400 border border-amber-500/20' : 'text-zinc-600 bg-zinc-800'}`}>
                    {s.label}
                  </span>
                );
              })}
            </div>

            <div className="flex items-center gap-3 text-xs text-zinc-500">
              {order.bahan && <span>{order.bahan}</span>}
              <span>DL: {formatDate(order.tglSelesai || order.dlCust)}</span>
              {order.daysLeft != null && (
                <span className={`font-semibold ${order.daysLeft < 0 ? 'text-red-400' : order.daysLeft <= 3 ? 'text-amber-400' : 'text-zinc-500'}`}>
                  {order.daysLeft < 0 ? `${Math.abs(order.daysLeft)}h lewat` : `${order.daysLeft} hari lagi`}
                </span>
              )}
            </div>
          </div>

          <svg className={`w-4 h-4 text-zinc-600 shrink-0 transition-transform mt-1 ${expanded ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7"/>
          </svg>
        </div>
      </div>

      {/* Expanded */}
      {expanded && (
        <div className="border-t border-zinc-800 p-4">
          <p className="text-xs text-zinc-600 uppercase tracking-wide mb-3 font-medium">
            Checklist Tahapan
            {!canEdit && <span className="ml-2 normal-case font-normal">(read-only)</span>}
            {canEdit && order.status === 'DONE' && <span className="ml-2 text-emerald-500 normal-case">Selesai</span>}
          </p>
          <div className="space-y-1.5">
            {STAGES.map((s, i) => {
              const checked = order.progress[s.key as keyof Progress];
              const key = `${order.rowIndex}-${s.key}`;
              const isUpdating = updating === key;
              const prevDone = i === 0 || order.progress[STAGES[i - 1].key as keyof Progress];
              const canCheck = canEdit && !isUpdating && order.status !== 'DONE' && (checked || prevDone);

              return (
                <div key={s.key}
                  className={`flex items-center gap-3 p-3 rounded-lg border transition-colors
                    ${checked ? 'bg-indigo-500/5 border-indigo-500/15' : prevDone && canEdit ? 'bg-zinc-800/50 border-zinc-800 hover:border-zinc-700' : 'bg-zinc-900 border-zinc-800/50 opacity-40'}`}>
                  {isUpdating ? (
                    <svg className="animate-spin w-[18px] h-[18px] text-indigo-400 shrink-0" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
                    </svg>
                  ) : (
                    <input type="checkbox" className="stage-check" checked={checked} disabled={!canCheck}
                      onChange={e => { if (s.key === 'PENGIRIMAN' && e.target.checked) { onPengirimanClick(); return; } onCheck(s.key, e.target.checked); }} />
                  )}
                  <span className={`text-sm ${checked ? 'text-indigo-400 font-medium' : 'text-zinc-400'}`}>{i + 1}. {s.label}</span>
                  {i === lastIdx && !checked && <span className="text-[10px] bg-amber-500/10 text-amber-400 px-1.5 py-0.5 rounded font-medium border border-amber-500/20 ml-auto">Next</span>}
                  {checked && <svg className="w-4 h-4 text-indigo-500 shrink-0 ml-auto" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"/></svg>}
                </div>
              );
            })}
          </div>

          {order.status === 'DONE' && order.tglKirim && (
            <div className="mt-3 p-3 rounded-lg bg-emerald-500/5 border border-emerald-500/15 text-sm text-emerald-400">
              Dikirim pada: <strong>{formatDate(order.tglKirim)}</strong>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function BoardSkeleton() {
  return (
    <div className="space-y-2 max-w-5xl mx-auto">
      {[1, 2, 3].map(i => (
        <div key={i} className="rounded-xl border border-zinc-800 bg-zinc-900 h-24 animate-pulse" style={{ opacity: 1 - i * 0.15 }} />
      ))}
    </div>
  );
}
