const fs = require('fs');
const path = require('path');

// Function to convert @ imports to relative imports
function convertImports(content, filePath) {
    const srcDir = path.resolve(__dirname, 'src');
    const currentDir = path.dirname(filePath);

    // Replace @/ imports with relative paths
    return content.replace(/@\/([^'"]+)/g, (match, importPath) => {
        const absolutePath = path.resolve(srcDir, importPath);
        const relativePath = path.relative(currentDir, absolutePath);
        return relativePath.startsWith('.') ? relativePath : `./${relativePath}`;
    });
}

// Function to process a file
function processFile(filePath) {
    try {
        const content = fs.readFileSync(filePath, 'utf8');
        const newContent = convertImports(content, filePath);

        if (content !== newContent) {
            fs.writeFileSync(filePath, newContent, 'utf8');
            console.log(`Fixed imports in: ${filePath}`);
        }
    } catch (error) {
        console.error(`Error processing ${filePath}:`, error.message);
    }
}

// Function to recursively find and process TypeScript/JavaScript files
function processDirectory(dir) {
    const files = fs.readdirSync(dir);

    for (const file of files) {
        const filePath = path.join(dir, file);
        const stat = fs.statSync(filePath);

        if (stat.isDirectory() && !file.startsWith('.') && file !== 'node_modules') {
            processDirectory(filePath);
        } else if (file.endsWith('.tsx') || file.endsWith('.ts')) {
            processFile(filePath);
        }
    }
}

// Main execution
console.log('Converting @ imports to relative imports...');
processDirectory(path.resolve(__dirname, 'src'));
processDirectory(path.resolve(__dirname, 'pages'));
console.log('Import conversion complete!'); 