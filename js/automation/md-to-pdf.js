import { mdToPdf } from "md-to-pdf";
import fs from "fs";
import path from "path";
import os from "os";

const INPUT_DIR = path.resolve("docs");
const OUTPUT_DIR = path.resolve("pdfs");
const CSS_FILE = path.resolve("style.css"); // optional

function walk(dir) {
  let results = [];
  for (const file of fs.readdirSync(dir)) {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      results = results.concat(walk(fullPath));
    } else if (file.endsWith(".md")) {
      results.push(fullPath);
    }
  }
  return results;
}

function stripFrontmatter(content) {
  if (content.startsWith("---")) {
    const end = content.indexOf("\n---", 3);
    if (end !== -1) {
      return content.slice(end + 4).trimStart();
    }
  }
  return content;
}

(async () => {
  const files = walk(INPUT_DIR);

  if (!files.length) {
    console.log("No markdown files found.");
    return;
  }

  for (const file of files) {
    const relative = path.relative(INPUT_DIR, file);
    const output = path.join(
      OUTPUT_DIR,
      relative.replace(/\.md$/, ".pdf")
    );

    fs.mkdirSync(path.dirname(output), { recursive: true });

    console.log(`Converting: ${relative}`);

    const content = fs.readFileSync(file, "utf8");
    const sanitizedContent = stripFrontmatter(content);

    const tempFile = path.join(os.tmpdir(), `tmp-${path.basename(file)}`);
    fs.writeFileSync(tempFile, sanitizedContent);

    try {
      await mdToPdf(
        { path: tempFile },
        { dest: output, css: fs.existsSync(CSS_FILE) ? CSS_FILE : undefined }
      );
      console.log(`✅ Generated: ${relative.replace(/\.md$/, ".pdf")}`);
    } catch (err) {
      console.error(`❌ Failed to convert ${relative}:`, err.message);
    } finally {
      fs.unlinkSync(tempFile);
    }
  }

  console.log("🎉 All PDFs processed");
})();
