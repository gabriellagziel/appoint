export default function LocaleHealth({ params:{ locale } }:{ params:{locale:string} }) {
  return <pre style={{padding:16}}>OK :: /{locale}/health</pre>;
}
