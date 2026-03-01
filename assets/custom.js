// Allow interactive iframes to overflow the content column (e.g. width="160%")
document.addEventListener('DOMContentLoaded', function () {
  var style = document.createElement('style');
  style.textContent = '.interactive-iframe-container { overflow: visible !important; }';
  document.head.appendChild(style);
});
