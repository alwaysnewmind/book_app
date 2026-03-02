/**
 * Production example: Node.js receipt verification endpoint.
 * In production, replace the stubbed verification methods with calls to:
 * - Google Play Developer API (Android)
 * - Apple App Store Server API (iOS)
 */
const express = require('express');
const crypto = require('crypto');

const app = express();
app.use(express.json({ limit: '1mb' }));

// Store receipt hashes to reduce replay abuse attempts.
const usedReceiptHashes = new Set();

app.post('/verify-subscription', async (req, res) => {
  const { userId, receiptData, platform } = req.body || {};

  if (!userId || !receiptData || !['android', 'ios'].includes(platform)) {
    return res.status(400).json({
      isValid: false,
      error: 'Invalid payload. userId, receiptData, and platform are required.',
    });
  }

  const receiptHash = crypto
    .createHash('sha256')
    .update(`${platform}:${receiptData}`)
    .digest('hex');

  if (usedReceiptHashes.has(receiptHash)) {
    return res.status(409).json({
      isValid: false,
      error: 'Duplicate receipt detected (possible replay attack).',
    });
  }

  try {
    const verificationResult =
      platform === 'android'
        ? await verifyAndroidReceipt(receiptData)
        : await verifyIosReceipt(receiptData);

    if (!verificationResult.isValid) {
      return res.status(200).json({
        isValid: false,
        expiryDate: null,
        plan: null,
      });
    }

    usedReceiptHashes.add(receiptHash);

    // TODO: Persist subscription ownership per user in your DB.
    // await upsertUserSubscription(userId, verificationResult);

    return res.status(200).json({
      isValid: true,
      expiryDate: verificationResult.expiryDate,
      plan: verificationResult.plan,
    });
  } catch (error) {
    return res.status(500).json({
      isValid: false,
      error: `Verification failed: ${error.message}`,
    });
  }
});

async function verifyAndroidReceipt(receiptData) {
  // Replace with Google Play Developer API token + purchases.subscriptionsv2.get.
  return decodeMockReceipt(receiptData);
}

async function verifyIosReceipt(receiptData) {
  // Replace with App Store Server API JWT auth + transaction lookup.
  return decodeMockReceipt(receiptData);
}

function decodeMockReceipt(receiptData) {
  // Demo only: assumes receiptData is base64 JSON for local development.
  let payload;
  try {
    payload = JSON.parse(Buffer.from(receiptData, 'base64').toString('utf8'));
  } catch (_) {
    return { isValid: false, expiryDate: null, plan: null };
  }

  const expiryDate = payload.expiryDate;
  const plan = payload.plan;
  const isValid = Boolean(expiryDate && ['monthly', 'yearly'].includes(plan));

  return { isValid, expiryDate, plan };
}

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(`Subscription verification server running on :${port}`);
});
