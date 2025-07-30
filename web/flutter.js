// Minimal Flutter loader for deployment
(function() {
  'use strict';
  
  console.log('Flutter loader initialized');
  
  window._flutter = window._flutter || {};
  window._flutter.loader = {
    load: function() {
      console.log('Loading App-oint Flutter application...');
      // This will be replaced with actual Flutter compilation
      return Promise.resolve();
    }
  };
  
  // Make loader available globally
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = window._flutter;
  }
})();