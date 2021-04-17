#!/usr/bin/env node

const puppeteer = require('puppeteer');

async function exportPdf() {
  const browser = await puppeteer.launch({
    executablePath: '/usr/bin/chromium-browser',
    args: ['--no-sandbox'],
  });

  const page = await browser.newPage();
  await page.goto(process.argv[2], {
    waitUntil: ['networkidle2'],
  });

  data = await page.pdf({ format: 'A4' });
  process.stdout.write(data);

  await browser.close();
}

exportPdf();
