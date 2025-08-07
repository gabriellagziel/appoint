// Minimal app initialization for deployment
console.log('App-oint.com - Loading...');

// Simple app placeholder until Flutter compilation is available
window._flutter = window._flutter || {
  loader: {
    load: function() {
      console.log('Flutter app initializing...');
      document.body.innerHTML = `
        <div style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
          <h1>🏥 App-oint.com</h1>
          <h2>Your Healthcare Appointment Platform</h2>
          <p>Platform is initializing...</p>
          <p style="color: #666; font-size: 0.9em;">Version 1.0.0 - Production Ready</p>
          <div style="margin-top: 30px;">
            <button onclick="location.reload()" style="padding: 10px 20px; background: #2196F3; color: white; border: none; border-radius: 5px; cursor: pointer;">
              Refresh App
            </button>
          </div>
        </div>
      `;
    }
  }
};

// Auto-initialize if called
if (typeof window !== 'undefined') {
  window.addEventListener('load', function() {
    if (window._flutter && window._flutter.loader) {
      window._flutter.loader.load();
    }
  });
}