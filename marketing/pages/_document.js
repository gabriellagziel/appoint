import { Html, Head, Main, NextScript } from 'next/document'

export default function Document(props) {
  // Allow per-request locale via __NEXT_DATA__.props.pageProps.locale if provided by getServerSideProps
  const locale = props?.__NEXT_DATA__?.props?.pageProps?.locale || 'en'
  return (
    <Html lang={locale} data-theme="light">
      <Head />
      <body>
        <Main />
        <NextScript />
      </body>
    </Html>
  )
}