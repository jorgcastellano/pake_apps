/**
 * Generic Web App Desktop Injection Script
 * Adds desktop-native keyboard shortcuts without forcing WebRTC initialization.
 */

(function () {
  console.log("Web App Desktop: Injecting helper scripts...");

  // 1. Keyboard Shortcuts (Reload, Zoom, and Navigation)
  window.addEventListener('keydown', (e) => {
    // Reload: Ctrl+R or Cmd+R or F5
    if ((e.ctrlKey || e.metaKey) && e.key === 'r' || e.key === 'F5') {
      window.location.reload();
    }
    // Zoom In: Ctrl+Plus or Cmd+Plus
    if ((e.ctrlKey || e.metaKey) && (e.key === '=' || e.key === '+')) {
      e.preventDefault();
      adjustZoom(0.1);
    }
    // Zoom Out: Ctrl+Minus or Cmd+Minus
    if ((e.ctrlKey || e.metaKey) && e.key === '-') {
      e.preventDefault();
      adjustZoom(-0.1);
    }
    // Reset Zoom: Ctrl+0 or Cmd+0
    if ((e.ctrlKey || e.metaKey) && e.key === '0') {
      e.preventDefault();
      resetZoom();
    }
  });

  // Zoom manipulation helpers
  let currentZoom = 1.0;
  function adjustZoom(delta) {
    currentZoom = Math.min(Math.max(currentZoom + delta, 0.5), 2.0);
    document.body.style.zoom = currentZoom;
    // Fallback for browsers that don't support document.body.style.zoom perfectly
    document.body.style.transform = `scale(${currentZoom})`;
    document.body.style.transformOrigin = 'top left';
    document.body.style.width = `${100 / currentZoom}%`;
    document.body.style.height = `${100 / currentZoom}%`;
  }

  function resetZoom() {
    currentZoom = 1.0;
    document.body.style.zoom = 1.0;
    document.body.style.transform = 'none';
    document.body.style.width = '100%';
    document.body.style.height = '100%';
  }

  console.log("Web App Desktop: Injection completed successfully.");
})();
