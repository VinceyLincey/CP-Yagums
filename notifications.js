/* ═══════════════════════════════════════════════
   YAGUMS  —  notifications.js
   Live notification engine (simulated polling)
   ═══════════════════════════════════════════════ */

const YAGUMS = (function () {

  /* ─── Notification store ─── */
  const store = {
    notifications: [],
    unreadCount: 0,
    listeners: [],
  };

  /* Role-specific notification pools used by the simulator */
  const pools = {
    admin: [
      { icon:'👤', title:'New Student Registration', msg:'A new student account has been created.', type:'info' },
      { icon:'📅', title:'Booking Submitted', msg:'Alice Tan submitted a new booking for Study Room 5.', type:'info' },
      { icon:'⚠️', title:'High Priority Maintenance', msg:'Computer Lab 1: critical hardware failure reported.', type:'warning' },
      { icon:'✅', title:'Booking Approved', msg:'Facility Manager approved Lecture Hall A booking.', type:'success' },
      { icon:'🔧', title:'Maintenance Completed', msg:'Projector in Lecture Hall A has been repaired.', type:'success' },
      { icon:'👥', title:'Role Change Request', msg:'Dr. Kumar requests access update for Lecturer role.', type:'info' },
      { icon:'🚨', title:'Booking Conflict Detected', msg:'Double booking attempt for Basketball Court on Apr 5.', type:'error' },
    ],
    manager: [
      { icon:'📅', title:'New Booking Request', msg:'Ben Lee has requested Study Room 5 on Apr 1, 1–3PM.', type:'info' },
      { icon:'📅', title:'New Booking Request', msg:'Dr. Kumar has requested Lecture Hall A on Apr 2.', type:'info' },
      { icon:'🔧', title:'Maintenance Request', msg:'Computer Lab 1: "Computers not working" — High priority.', type:'warning' },
      { icon:'✅', title:'Maintenance Completed', msg:'Projector in Lecture Hall A has been repaired by Ms. Lim.', type:'success' },
      { icon:'❌', title:'Booking Cancelled', msg:'Alice Tan cancelled her Basketball Court booking.', type:'info' },
      { icon:'⏰', title:'Pending Approval Reminder', msg:'2 bookings have been pending for over 24 hours.', type:'warning' },
    ],
    maintenance: [
      { icon:'🔧', title:'New Task Assigned', msg:'Inspect AC unit in Study Room 5 — Low priority.', type:'info' },
      { icon:'🔧', title:'New Task Assigned', msg:'Fix computers in Computer Lab 1 — High priority.', type:'warning' },
      { icon:'✅', title:'Task Marked Complete', msg:'Projector repair in Lecture Hall A was completed.', type:'success' },
      { icon:'📋', title:'Progress Update Required', msg:'Please update progress on Computer Lab 1 task.', type:'warning' },
      { icon:'🏢', title:'New Facility Report', msg:'Meeting Room 1 reported a broken light fixture.', type:'info' },
    ],
    lecturer: [
      { icon:'✅', title:'Booking Approved', msg:'Your Lecture Hall A booking on Apr 2 has been approved.', type:'success' },
      { icon:'✅', title:'Booking Approved', msg:'Computer Lab 1 booking on Apr 3 is confirmed.', type:'success' },
      { icon:'🔧', title:'Maintenance Update', msg:'Projector malfunction in Lecture Hall A is being fixed.', type:'info' },
      { icon:'📅', title:'Room Available', msg:'Meeting Room 1 is now available for your preferred slot.', type:'info' },
      { icon:'⚠️', title:'Facility Notice', msg:'Computer Lab 1 will be closed for maintenance tomorrow.', type:'warning' },
    ],
    student: [
      { icon:'✅', title:'Booking Approved', msg:'Your Study Room 5 booking on Apr 1 has been approved!', type:'success' },
      { icon:'❌', title:'Booking Rejected', msg:'Basketball Court booking on Apr 4 was rejected.', type:'error' },
      { icon:'⏳', title:'Booking Pending', msg:'Your Study Room 5 request is awaiting approval.', type:'info' },
      { icon:'🔔', title:'Reminder', msg:'Your Study Room 5 booking starts in 1 hour.', type:'info' },
      { icon:'🔧', title:'Facility Notice', msg:'Computer Lab 1 is temporarily unavailable for maintenance.', type:'warning' },
      { icon:'📅', title:'Booking Slot Opening', msg:'Basketball Court has a new slot available on Apr 6.', type:'info' },
    ],
  };

  let role = 'student';
  let panelOpen = false;
  let toastQueue = [];
  let toastBusy = false;
  let simInterval = null;

  /* ─── Helpers ─── */
  function timeAgo(ts) {
    const s = Math.floor((Date.now() - ts) / 1000);
    if (s < 60)  return 'Just now';
    if (s < 3600) return `${Math.floor(s/60)}m ago`;
    return `${Math.floor(s/3600)}h ago`;
  }

  function updateBadge() {
    const el = document.getElementById('notif-count');
    if (!el) return;
    store.unreadCount = store.notifications.filter(n => !n.read).length;
    el.textContent = store.unreadCount > 9 ? '9+' : store.unreadCount;
    el.classList.toggle('hidden', store.unreadCount === 0);
  }

  function renderPanel() {
    const list = document.getElementById('notif-list');
    if (!list) return;
    if (store.notifications.length === 0) {
      list.innerHTML = '<div class="notif-empty">🎉 You\'re all caught up!</div>';
      return;
    }
    list.innerHTML = store.notifications.slice(0, 20).map((n, i) => `
      <div class="notif-row ${n.read ? '' : 'unread'}" onclick="YAGUMS.readNotif(${i})">
        <div class="notif-dot ${n.read ? 'read' : 'unread'}"></div>
        <div>
          <div class="notif-text"><strong>${n.icon} ${n.title}</strong></div>
          <div class="notif-text">${n.msg}</div>
          <div class="notif-time">${timeAgo(n.ts)}</div>
        </div>
      </div>
    `).join('');
  }

  /* ─── Toast ─── */
  function showToast(notif) {
    toastQueue.push(notif);
    if (!toastBusy) processQueue();
  }

  function processQueue() {
    if (toastQueue.length === 0) { toastBusy = false; return; }
    toastBusy = true;
    const n = toastQueue.shift();
    const container = document.getElementById('toast-container');
    if (!container) return;

    const id = 'toast-' + Date.now();
    const el = document.createElement('div');
    el.className = `toast ${n.type || 'info'}`;
    el.id = id;
    el.innerHTML = `
      <span class="toast-icon">${n.icon}</span>
      <div class="toast-body">
        <div class="toast-title">${n.title}</div>
        <div class="toast-msg">${n.msg}</div>
      </div>
      <button class="toast-close" onclick="YAGUMS.dismissToast('${id}')">✕</button>
    `;
    container.appendChild(el);

    setTimeout(() => dismissToast(id), 5000);
    setTimeout(() => { toastBusy = false; processQueue(); }, 600);
  }

  function dismissToast(id) {
    const el = document.getElementById(id);
    if (!el) return;
    el.classList.add('out');
    setTimeout(() => el.remove(), 320);
  }

  /* ─── Add notification ─── */
  function addNotif(n) {
    const notif = { ...n, read: false, ts: Date.now() };
    store.notifications.unshift(notif);
    updateBadge();
    if (panelOpen) renderPanel();
    showToast(notif);
  }

  /* ─── Simulator (fake polling) ─── */
  function startSimulator() {
    const pool = pools[role] || pools.student;
    let idx = 0;

    // Seed 2–3 existing unread notifications immediately
    const seed = pool.slice(0, 3);
    seed.forEach(n => {
      store.notifications.push({ ...n, read: false, ts: Date.now() - Math.floor(Math.random()*3600000) });
    });
    updateBadge();

    // Simulate new notifications arriving every 15–30 seconds
    function schedule() {
      const delay = 15000 + Math.random() * 15000;
      simInterval = setTimeout(() => {
        const notif = pool[idx % pool.length];
        idx++;
        addNotif(notif);
        schedule();
      }, delay);
    }
    schedule();
  }

  /* ─── Public API ─── */
  function init(userRole) {
    role = userRole || 'student';
    startSimulator();
    updateBadge();
    renderPanel();

    // Close panel on outside click
    document.addEventListener('click', (e) => {
      const panel = document.getElementById('notif-panel');
      const btn   = document.getElementById('notif-btn');
      if (panel && btn && !panel.contains(e.target) && !btn.contains(e.target)) {
        closePanel();
      }
    });
  }

  function togglePanel() {
    panelOpen = !panelOpen;
    const panel = document.getElementById('notif-panel');
    if (!panel) return;
    panel.classList.toggle('open', panelOpen);
    if (panelOpen) renderPanel();
  }

  function closePanel() {
    panelOpen = false;
    const panel = document.getElementById('notif-panel');
    if (panel) panel.classList.remove('open');
  }

  function readNotif(i) {
    if (store.notifications[i]) store.notifications[i].read = true;
    updateBadge();
    renderPanel();
  }

  function markAllRead() {
    store.notifications.forEach(n => n.read = true);
    updateBadge();
    renderPanel();
  }

  function destroy() {
    if (simInterval) clearTimeout(simInterval);
  }

  return { init, togglePanel, closePanel, readNotif, markAllRead, dismissToast, addNotif };

})();
