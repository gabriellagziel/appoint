/**
 * jscodeshift - replace local UI imports with DS
 * Usage: npx jscodeshift -t tools/codemods/replace-ui-imports.js ./business/src ./dashboard/src ./admin/src ./enterprise-app/src
 */
export default function transformer(file, api) {
  const j = api.jscodeshift;
  const r = j(file.source)
    .find(j.ImportDeclaration)
    .forEach(p => {
      const v = p.value.source.value;
      if (/components\/ui\//.test(v) || /components\/shared\//.test(v)) {
        p.value.source.value = "@app-oint/design-system";
      }
    });
  return r.toSource();
}

