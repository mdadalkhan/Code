/**
 * Full Documentation to PDF Script
 *
 * Requirements:
 * npm install puppeteer fs-extra pdf-merger-js
 *
 * Usage:
 * node generateDocsPDF.js
 */

import puppeteer from "puppeteer";
import fs from "fs-extra";
import PDFMerger from "pdf-merger-js";
import path from "path";

// ----------------------
// CONFIGURATION
// ----------------------
const BASE_URL = "https://svelte.dev/docs/svelte/overview"; // Change to your docs homepage
const OUTPUT_DIR = "pdfs";
const MERGED_FILE = "FullDocumentation.pdf";
const SIDEBAR_SELECTOR = "nav a"; // Adjust to match your site sidebar links
// e.g., ".sidebar a" for Docusaurus, ".toc a" for other docs

// ----------------------
// HELPER FUNCTIONS
// ----------------------
function sanitizeFilename(url) {
  return url
    .replace(/^https?:\/\//, "")
    .replace(/\/+/g, "_")
    .replace(/\?.*$/, "") + ".pdf";
}

// ----------------------
// MAIN
// ----------------------
(async () => {
  await fs.ensureDir(OUTPUT_DIR);

  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  await page.goto(BASE_URL, { waitUntil: "networkidle0" });

  // Extract all sidebar links
  let urls = await page.$$eval(SIDEBAR_SELECTOR, links =>
    links.map(l => l.href).filter(h => h.includes("/docs/"))
  );

  // Deduplicate URLs
  urls = Array.from(new Set(urls));
  console.log(`Found ${urls.length} documentation pages.`);

  const pdfFiles = [];

  // Convert each page to PDF
  for (const url of urls) {
    const p = await browser.newPage();
    await p.goto(url, { waitUntil: "networkidle0" });

    const filename = sanitizeFilename(url);
    const outputPath = path.join(OUTPUT_DIR, filename);

    await p.pdf({
      path: outputPath,
      format: "A4",
      printBackground: true,
    });

    console.log(`✅ Saved PDF: ${filename}`);
    pdfFiles.push(outputPath);
    await p.close();
  }

  await browser.close();

  // Merge PDFs into one
  const merger = new PDFMerger();
  for (const pdf of pdfFiles) {
    merger.add(pdf);
  }

  const mergedPath = path.join(OUTPUT_DIR, MERGED_FILE);
  await merger.save(mergedPath);

  console.log(`🎉 All PDFs merged into: ${mergedPath}`);
})();
