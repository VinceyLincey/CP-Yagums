/**
 * YAGUMS — mobile.js
 * Include this AFTER the DOM. Handles:
 *  - Hamburger open/close
 *  - Overlay tap to close
 *  - Swipe-left on sidebar to close
 *  - Bottom nav active state
 *
 * Requires:
 *   <button id="hamburger-btn"> in the topbar
 *   <div id="sidebar"> and <div id="sidebarOverlay">
 */
(function () {
  const sidebar  = document.getElementById('sidebar');
  const overlay  = document.getElementById('sidebarOverlay');
  const hamburger = document.getElementById('hamburger-btn');

  if (!sidebar || !overlay || !hamburger) return;

  function openSidebar() {
    sidebar.classList.add('open');
    overlay.classList.add('show');
    document.body.style.overflow = 'hidden';
  }
  function closeSidebar() {
    sidebar.classList.remove('open');
    overlay.classList.remove('show');
    document.body.style.overflow = '';
  }

  // Expose globally so inline onclick can still call closeSidebar()
  window.openSidebar  = openSidebar;
  window.closeSidebar = closeSidebar;
  window.toggleSidebar = function () {
    sidebar.classList.contains('open') ? closeSidebar() : openSidebar();
  };

  // Hamburger — addEventListener is reliable on all mobile browsers
  hamburger.addEventListener('click', function (e) {
    e.stopPropagation();
    window.toggleSidebar();
  });

  // Overlay tap closes sidebar
  overlay.addEventListener('click', closeSidebar);

  // Swipe left on sidebar to close
  let _startX = 0;
  sidebar.addEventListener('touchstart', function (e) {
    _startX = e.touches[0].clientX;
  }, { passive: true });
  sidebar.addEventListener('touchend', function (e) {
    if (e.changedTouches[0].clientX - _startX < -50) closeSidebar();
  }, { passive: true });

  // Close sidebar when any nav-item inside it is clicked (mobile only)
  sidebar.querySelectorAll('.nav-item').forEach(function (item) {
    item.addEventListener('click', function () {
      if (window.innerWidth <= 768) closeSidebar();
    });
  });
})();
