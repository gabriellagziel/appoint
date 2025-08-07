import fs from 'fs'
import matter from 'gray-matter'
import path from 'path'

export default function DocsHome({ docs }) {
    return (
        <div style={{ padding: '2rem', maxWidth: '1200px', margin: '0 auto' }}>
            <h1>App-Oint Documentation</h1>
            <p>Welcome to the App-Oint documentation site.</p>

            <h2>Available Documentation</h2>
            <ul>
                {docs.map((doc) => (
                    <li key={doc.slug}>
                        <a href={`/docs/${doc.slug}`}>{doc.title}</a>
                    </li>
                ))}
            </ul>
        </div>
    )
}

export async function getStaticProps() {
    const docsDirectory = path.join(process.cwd(), '..')
    const filenames = fs.readdirSync(docsDirectory)

    const docs = filenames
        .filter(filename => filename.endsWith('.md'))
        .map(filename => {
            const filePath = path.join(docsDirectory, filename)
            const fileContents = fs.readFileSync(filePath, 'utf8')
            const { data } = matter(fileContents)

            return {
                slug: filename.replace('.md', ''),
                title: data.title || filename.replace('.md', ''),
                description: data.description || ''
            }
        })
        .slice(0, 20) // Limit to first 20 docs

    return {
        props: {
            docs
        }
    }
}
