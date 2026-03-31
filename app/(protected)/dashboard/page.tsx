'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth-context';
import { apiGetDashboard, apiGetOrders, apiGetDashboardForce, apiGetOrdersForce } from '@/lib/api';
import { DashboardStats, Order } from '@/lib/types';
import { STAGES, RISK_LABELS, STATUS_LABELS } from '@/lib/constants';
import { formatDate } from '@/lib/utils';

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

export default function DashboardPage() {
  const { user } = useAuth();
  const router = useRouter();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [selectedMonth, setSelectedMonth] = useState('');
  const [orderPage, setOrderPage] = useState(1);
  const ORDER_PAGE_SIZE = 8;

  useEffect(() => {
    if (user && user.role !== 'admin') {
      router.replace(user.role === 'cs' ? '/orders' : '/production');
      return;
    }
    fetchData();
  }, [user]);

  async function fetchData(force = false) {
    try {
      const [statsRes, ordersRes] = await Promise.all([
        force ? apiGetDashboardForce() : apiGetDashboard(),
        force ? apiGetOrdersForce() : apiGetOrders(),
      ]);
      if (statsRes.success && statsRes.data) setStats(statsRes.data);
      if (ordersRes.success && ordersRes.data) setOrders(ordersRes.data);
      if (!statsRes.success) setError(statsRes.error || 'Gagal memuat data');
      else setError('');
    } catch { setError('Gagal terhubung. Cek konfigurasi APPS_SCRIPT_URL.'); }
    setLoading(false);
  }

  const warningOrders = orders.filter(o => o.riskLevel === 'HIGH' || o.riskLevel === 'OVERDUE' || o.riskLevel === 'NEAR');

  const parseDate = (s: string): Date | null => {
    if (!s || s === '—') return null;
    const parts = s.split('/');
    if (parts.length === 3) { const d = new Date(+parts[2], +parts[1] - 1, +parts[0]); return isNaN(d.getTime()) ? null : d; }
    const d = new Date(s); return isNaN(d.getTime()) ? null : d;
  };
  const dateMs = (s: string) => parseDate(s)?.getTime() ?? Infinity;
  const monthKey = (s: string) => { const d = parseDate(s); return d ? `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}` : '9999-99'; };
  const monthLabel = (key: string) => { const [y, m] = key.split('-'); const B = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des']; return `${B[+m - 1]} ${y}`; };

  const monthsMap = new Map<string, Map<string, Order[]>>();
  for (const o of orders) {
    const dk = o.tglSelesai || o.dlCust || '—';
    const mk = monthKey(dk);
    if (!monthsMap.has(mk)) monthsMap.set(mk, new Map());
    const dm = monthsMap.get(mk)!;
    if (!dm.has(dk)) dm.set(dk, []);
    dm.get(dk)!.push(o);
  }
  const sortedMonths = Array.from(monthsMap.keys()).sort();
  const activeMonth = selectedMonth && monthsMap.has(selectedMonth) ? selectedMonth : (sortedMonths[0] ?? '');
  const activeDateMap = monthsMap.get(activeMonth) ?? new Map<string, Order[]>();
  const activeDates = Array.from(activeDateMap.entries()).sort(([a], [b]) => dateMs(a) - dateMs(b));
  const activeMonthOrderCount = Array.from(activeDateMap.values()).reduce((s, arr) => s + arr.length, 0);
  const totalPages = activeMonthOrderCount > ORDER_PAGE_SIZE ? Math.ceil(activeDates.length / ORDER_PAGE_SIZE) : 1;
  const pagedDates = activeMonthOrderCount > ORDER_PAGE_SIZE
    ? activeDates.slice((orderPage - 1) * ORDER_PAGE_SIZE, orderPage * ORDER_PAGE_SIZE)
    : activeDates;

  if (loading) return <LoadingState />;
  if (error) return <ErrorState message={error} onRetry={fetchData} />;

  return (
    <div className="space-y-5 max-w-7xl mx-auto">
      {/* Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <StatCard label="Total Order Aktif" value={stats ? stats.totalOrders - stats.doneOrders : 0} sub={`${stats?.doneOrders ?? 0} selesai`} color="indigo" />
        <StatCard label="Near Deadline" value={stats?.nearDeadlineCount ?? 0} sub="3 hari lagi" color="amber" />
        <StatCard label="Overdue" value={stats?.overdueCount ?? 0} sub="Lewat deadline" color="red" />
        <StatCard label="Kapasitas Hari Ini" value={stats?.dailyCapacityUsed ?? 0} sub="total hari ini" color="emerald" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        {/* Pipeline */}
        <div className="lg:col-span-2 rounded-xl border border-zinc-800 bg-zinc-900 p-5">
          <h2 className="text-sm font-semibold text-zinc-200 mb-4">Progress Pipeline Produksi</h2>
          <div className="space-y-2.5">
            {STAGES.map(stage => {
              const count = stats?.stageCounts?.[stage.key] ?? 0;
              const maxCount = Math.max(1, ...Object.values(stats?.stageCounts ?? {}));
              const pct = Math.round((count / maxCount) * 100);
              return (
                <div key={stage.key} className="flex items-center gap-3">
                  <span className="text-xs text-zinc-500 w-28 shrink-0">{stage.label}</span>
                  <div className="flex-1 h-1.5 bg-zinc-800 rounded-full overflow-hidden">
                    <div className="h-full bg-indigo-500 rounded-full transition-all duration-500" style={{ width: `${pct}%` }} />
                  </div>
                  <span className="text-xs font-medium text-zinc-400 w-6 text-right tabular-nums">{count}</span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Warning */}
        <div className="rounded-xl border border-zinc-800 bg-zinc-900 p-5">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-zinc-200">Warning Center</h2>
            {warningOrders.length > 0 && (
              <span className="text-[11px] bg-red-500/10 text-red-400 px-2 py-0.5 rounded-md font-medium border border-red-500/20">{warningOrders.length}</span>
            )}
          </div>

          {warningOrders.length === 0 ? (
            <div className="text-center py-8">
              <div className="w-8 h-8 rounded-full bg-emerald-500/10 border border-emerald-500/20 grid place-items-center mx-auto mb-2">
                <svg className="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7"/></svg>
              </div>
              <p className="text-sm text-zinc-500">Semua order aman</p>
            </div>
          ) : (
            <div className="space-y-1.5 overflow-y-auto max-h-72">
              {warningOrders.map(order => (
                <div key={order.rowIndex} className="p-3 rounded-lg border border-zinc-800 hover:bg-zinc-800/50 transition-colors">
                  <div className="flex items-start justify-between gap-2">
                    <div className="min-w-0">
                      <p className="text-sm font-medium text-zinc-200 truncate">{order.customer}</p>
                      <p className="text-xs text-zinc-600">{order.qty} pcs · {order.paket1} {order.paket2}</p>
                    </div>
                    <span className={`text-[11px] px-2 py-0.5 rounded-md font-medium shrink-0 ${RISK_D[order.riskLevel || 'NORMAL']}`}>
                      {RISK_LABELS[order.riskLevel || 'NORMAL']}
                    </span>
                  </div>
                  <p className="text-xs text-zinc-600 mt-1">
                    DL: {formatDate(order.tglSelesai || order.dlCust)}
                    {order.daysLeft != null && (
                      <span className={`ml-2 font-medium ${order.daysLeft < 0 ? 'text-red-400' : 'text-amber-400'}`}>
                        {order.daysLeft < 0 ? `${Math.abs(order.daysLeft)} hari lewat` : `${order.daysLeft} hari lagi`}
                      </span>
                    )}
                  </p>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Recent orders */}
      <div className="rounded-xl border border-zinc-800 bg-zinc-900 overflow-hidden">
        <div className="px-5 py-4 border-b border-zinc-800 flex items-center justify-between">
          <h2 className="text-sm font-semibold text-zinc-200">Order Terbaru</h2>
          <Link href="/orders" className="text-[13px] text-indigo-400 hover:text-indigo-300 font-medium transition-colors">Lihat semua</Link>
        </div>

        {sortedMonths.length === 0 ? (
          <div className="px-5 py-8 text-center text-zinc-600 text-sm">Belum ada data order</div>
        ) : (
          <>
            {/* Month tabs */}
            <div className="px-5 pt-3 flex gap-1 overflow-x-auto border-b border-zinc-800">
              {sortedMonths.map(mk => (
                <button key={mk} onClick={() => { setSelectedMonth(mk); setOrderPage(1); }}
                  className={`shrink-0 px-3 py-2 text-[13px] font-medium border-b-2 transition-colors
                    ${mk === activeMonth ? 'border-zinc-100 text-zinc-100' : 'border-transparent text-zinc-600 hover:text-zinc-400'}`}>
                  {monthLabel(mk)}
                  <span className={`ml-1.5 text-xs tabular-nums ${mk === activeMonth ? 'text-zinc-400' : 'text-zinc-700'}`}>
                    {Array.from(monthsMap.get(mk)!.values()).reduce((s, a) => s + a.length, 0)}
                  </span>
                </button>
              ))}
            </div>

            {/* Date rows */}
            <div className="divide-y divide-zinc-800/50">
              {pagedDates.map(([dateKey, dateOrders]) => {
                const totalQty = dateOrders.reduce((s, o) => s + o.qty, 0);
                const RISK_RANK: Record<string, number> = { OVERDUE: 4, HIGH: 3, NEAR: 2, NORMAL: 1, SAFE: 0 };
                const worstRisk = dateOrders.reduce<string>((w, o) => (RISK_RANK[o.riskLevel || 'NORMAL'] > RISK_RANK[w] ? (o.riskLevel || 'NORMAL') : w), 'SAFE');
                const allDone = dateOrders.every(o => o.status === 'DONE');
                const statusSummary = allDone ? 'Selesai' : `${dateOrders.filter(o => o.status !== 'DONE').length} aktif`;
                return (
                  <div key={dateKey} className="px-5 py-3 flex items-center gap-4 hover:bg-zinc-800/30 transition-colors">
                    <div className="w-28 shrink-0 text-sm font-medium text-zinc-300">{formatDate(dateKey)}</div>
                    <div className="flex-1 flex flex-wrap gap-1.5 min-w-0">
                      {dateOrders.map(o => (
                        <span key={o.rowIndex} className="text-xs bg-zinc-800 text-zinc-400 px-2 py-0.5 rounded-md border border-zinc-700/50">
                          {o.customer} <span className="text-zinc-600">{o.qty}</span>
                        </span>
                      ))}
                    </div>
                    <div className="shrink-0 text-sm font-medium text-zinc-400 tabular-nums w-16 text-right">{totalQty} pcs</div>
                    <span className={`shrink-0 text-[11px] px-2 py-0.5 rounded-md font-medium ${allDone ? STATUS_D['DONE'] : STATUS_D['IN_PROGRESS']}`}>{statusSummary}</span>
                    <span className={`shrink-0 text-[11px] px-2 py-0.5 rounded-md font-medium ${RISK_D[worstRisk]}`}>{RISK_LABELS[worstRisk]}</span>
                  </div>
                );
              })}
            </div>

            {totalPages > 1 && (
              <div className="px-5 py-3 border-t border-zinc-800 flex justify-center">
                <div className="flex items-center gap-1">
                  <button onClick={() => orderPage > 1 && setOrderPage(orderPage - 1)} disabled={orderPage === 1}
                    className="px-2 py-1 rounded-md text-xs text-zinc-500 hover:text-zinc-300 hover:bg-zinc-800 disabled:opacity-30 transition-colors">Prev</button>
                  {Array.from({ length: totalPages }, (_, i) => (
                    <button key={i} onClick={() => setOrderPage(i + 1)}
                      className={`min-w-[28px] h-7 rounded-md text-xs font-medium transition-colors ${orderPage === i + 1 ? 'bg-zinc-100 text-zinc-900' : 'text-zinc-500 hover:bg-zinc-800'}`}>
                      {i + 1}
                    </button>
                  ))}
                  <button onClick={() => orderPage < totalPages && setOrderPage(orderPage + 1)} disabled={orderPage === totalPages}
                    className="px-2 py-1 rounded-md text-xs text-zinc-500 hover:text-zinc-300 hover:bg-zinc-800 disabled:opacity-30 transition-colors">Next</button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

function StatCard({ label, value, sub, color }: { label: string; value: number; sub: string; color: string }) {
  const c: Record<string, { text: string; dot: string }> = {
    indigo: { text: 'text-indigo-400', dot: 'bg-indigo-500' },
    amber: { text: 'text-amber-400', dot: 'bg-amber-500' },
    red: { text: 'text-red-400', dot: 'bg-red-500' },
    emerald: { text: 'text-emerald-400', dot: 'bg-emerald-500' },
  };
  const s = c[color] || c.indigo;
  return (
    <div className="rounded-xl border border-zinc-800 bg-zinc-900 p-4">
      <div className="flex items-center gap-2 mb-3">
        <div className={`w-2 h-2 rounded-full ${s.dot}`} />
        <span className="text-xs text-zinc-500">{label}</span>
      </div>
      <div className={`text-3xl font-bold ${s.text} tabular-nums`}>{value}</div>
      <div className="text-xs text-zinc-600 mt-1">{sub}</div>
    </div>
  );
}

function LoadingState() {
  return (
    <div className="space-y-4 max-w-7xl mx-auto">
      <div className="grid grid-cols-4 gap-3">
        {[1, 2, 3, 4].map(i => <div key={i} className="rounded-xl border border-zinc-800 bg-zinc-900 h-28 animate-pulse" />)}
      </div>
      <div className="rounded-xl border border-zinc-800 bg-zinc-900 h-64 animate-pulse" />
    </div>
  );
}

function ErrorState({ message, onRetry }: { message: string; onRetry: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center py-20 text-center">
      <div className="w-12 h-12 rounded-full bg-red-500/10 border border-red-500/20 grid place-items-center mb-4">
        <svg className="w-6 h-6 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
        </svg>
      </div>
      <h3 className="text-lg font-semibold text-zinc-200 mb-2">Gagal Memuat Data</h3>
      <p className="text-sm text-zinc-500 mb-4 max-w-sm">{message}</p>
      <button onClick={onRetry} className="bg-zinc-100 text-zinc-900 px-5 py-2 rounded-lg text-sm font-medium hover:bg-white transition-colors">Coba Lagi</button>
    </div>
  );
}
