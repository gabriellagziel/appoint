import '../styles/globals.css'
import '@app-oint/design-system/dist/css/tokens.css'

export default function App({ Component, pageProps }) {
  // If you need any context/provider, place it here (client-friendly only)
  return <Component {...pageProps} />;
}
