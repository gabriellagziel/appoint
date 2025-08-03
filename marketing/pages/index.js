export default function Home() {
  return (
    <div style={{
      fontFamily: "Arial, sans-serif",
      margin: 0,
      padding: "20px",
      background: "#f5f5f5",
      minHeight: "100vh"
    }}>
      <div style={{
        maxWidth: "800px",
        margin: "0 auto",
        background: "white",
        padding: "40px",
        borderRadius: "8px",
        boxShadow: "0 2px 10px rgba(0,0,0,0.1)"
      }}>
        <h1 style={{ color: "#333", marginBottom: "20px" }}>
          App-Oint Marketing Portal
        </h1>
        <p style={{ color: "#666", lineHeight: "1.6" }}>
          Welcome to our marketing site! This is a simple, working deployment.
        </p>
        <div style={{ marginTop: "30px" }}>
          <h2 style={{ color: "#333", marginBottom: "15px" }}>Our Services</h2>
          <ul style={{ color: "#666", lineHeight: "1.6" }}>
            <li>Business Portal - Complete business management solution</li>
            <li>Enterprise Portal - Enterprise onboarding and management</li>
            <li>Marketing Portal - Customer-facing marketing site</li>
          </ul>
        </div>
        <div style={{ marginTop: "30px", padding: "20px", background: "#f8f9fa", borderRadius: "4px" }}>
          <h3 style={{ color: "#333", marginBottom: "10px" }}>Deployment Status</h3>
          <p style={{ color: "#28a745", margin: 0 }}>
            ✅ All systems operational
          </p>
        </div>
      </div>
    </div>
  );
}
