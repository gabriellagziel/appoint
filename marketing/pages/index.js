export default function Home() {
  return (
    <html>
      <head>
        <title>App-Oint Marketing</title>
        <style>{`
          body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f5f5; 
          }
          .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: white; 
            padding: 40px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
          }
          h1 { color: #333; }
          p { color: #666; line-height: 1.6; }
        `}</style>
      </head>
      <body>
        <div className="container">
          <h1>App-Oint Marketing</h1>
          <p>Welcome to our marketing site! This is a simple, working deployment.</p>
        </div>
      </body>
    </html>
  )
}
