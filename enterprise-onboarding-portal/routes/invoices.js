const express = require('express');
const nodemailer = require('nodemailer');
const { collections, SUBSCRIPTION_PLANS } = require('../firebase');
const { authenticateFirebaseToken } = require('../middleware/auth');

const router = express.Router();

// Email configuration
const transporter = nodemailer.createTransporter({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    },
    secure: true,
    tls: {
        rejectUnauthorized: false
    }
});

// Generate invoice HTML template
const generateInvoiceHTML = (invoiceData) => {
    return `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Invoice - ${invoiceData.invoiceNumber}</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 40px; }
                .header { text-align: center; margin-bottom: 30px; }
                .invoice-details { margin-bottom: 30px; }
                .table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                .table th, .table td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                .table th { background-color: #f8f9fa; }
                .total { font-weight: bold; font-size: 18px; }
                .bank-details { background-color: #f8f9fa; padding: 20px; margin: 20px 0; border-radius: 5px; }
                .footer { margin-top: 40px; font-size: 12px; color: #666; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>${process.env.COMPANY_NAME || 'App-Oint Enterprise'}</h1>
                <h2>INVOICE</h2>
            </div>
            
            <div class="invoice-details">
                <p><strong>Invoice Number:</strong> ${invoiceData.invoiceNumber}</p>
                <p><strong>Date:</strong> ${invoiceData.invoiceDate}</p>
                <p><strong>Due Date:</strong> ${invoiceData.dueDate}</p>
                <p><strong>Client:</strong> ${invoiceData.clientName}</p>
                <p><strong>Email:</strong> ${invoiceData.clientEmail}</p>
            </div>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>Description</th>
                        <th>Quantity</th>
                        <th>Rate</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>${invoiceData.planName} Plan - ${invoiceData.period}</td>
                        <td>1</td>
                        <td>$${invoiceData.planPrice}</td>
                        <td>$${invoiceData.planPrice}</td>
                    </tr>
                    ${invoiceData.overageCalls > 0 ? `
                    <tr>
                        <td>Overage API Calls (${invoiceData.overageCalls} calls)</td>
                        <td>${invoiceData.overageCalls}</td>
                        <td>$0.001 per call</td>
                        <td>$${invoiceData.overageAmount}</td>
                    </tr>
                    ` : ''}
                </tbody>
            </table>
            
            <div class="total">
                <p><strong>Total Amount:</strong> $${invoiceData.totalAmount}</p>
            </div>
            
            <div class="bank-details">
                <h3>Bank Transfer Instructions</h3>
                <p><strong>Bank Name:</strong> ${process.env.BANK_NAME || 'Enterprise Bank'}</p>
                <p><strong>Account Name:</strong> ${process.env.COMPANY_NAME || 'App-Oint Enterprise'}</p>
                <p><strong>IBAN:</strong> ${process.env.COMPANY_IBAN}</p>
                <p><strong>SWIFT/BIC:</strong> ${process.env.COMPANY_SWIFT}</p>
                <p><strong>Reference:</strong> ${invoiceData.invoiceNumber}</p>
                <p><strong>Amount:</strong> $${invoiceData.totalAmount}</p>
            </div>
            
            <div class="footer">
                <p>Please include the invoice number as reference when making the transfer.</p>
                <p>For any questions, please contact: ${process.env.COMPANY_EMAIL}</p>
            </div>
        </body>
        </html>
    `;
};

// Generate monthly invoices for all users
router.post('/generate-monthly', authenticateFirebaseToken, async (req, res) => {
    try {
        // Check if user is admin
        const userDoc = await collections.users.doc(req.user.uid).get();
        const userData = userDoc.data();

        if (!userData.isAdmin) {
            return res.status(403).json({ error: 'Admin access required' });
        }

        const now = new Date();
        const previousMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
        const endOfPreviousMonth = new Date(now.getFullYear(), now.getMonth(), 0);

        // Get all users with active subscriptions
        const usersSnapshot = await collections.users
            .where('subscriptionPlan', 'in', ['basic', 'pro', 'enterprise'])
            .get();

        const generatedInvoices = [];

        for (const userDoc of usersSnapshot.docs) {
            const userData = userDoc.data();
            const userId = userDoc.id;

            // Get usage for previous month
            const usageSnapshot = await collections.usageLogs
                .where('userId', '==', userId)
                .where('timestamp', '>=', previousMonth)
                .where('timestamp', '<=', endOfPreviousMonth)
                .get();

            let totalCalls = 0;
            usageSnapshot.forEach(() => {
                totalCalls++;
            });

            const plan = userData.subscriptionPlan || 'basic';
            const planData = SUBSCRIPTION_PLANS[plan];

            // Calculate overage
            const overageCalls = Math.max(0, totalCalls - planData.monthlyApiCalls);
            const overageAmount = overageCalls * 0.001; // $0.001 per call
            const totalAmount = planData.price + overageAmount;

            // Generate invoice number
            const invoiceNumber = `INV-${now.getFullYear()}${String(now.getMonth()).padStart(2, '0')}-${String(Math.floor(Math.random() * 10000)).padStart(4, '0')}`;

            // Create invoice data
            const invoiceData = {
                invoiceNumber,
                userId,
                clientName: userData.companyName || userData.displayName || 'Enterprise Client',
                clientEmail: userData.email,
                planName: planData.name,
                planPrice: planData.price,
                period: `${previousMonth.toLocaleDateString()} - ${endOfPreviousMonth.toLocaleDateString()}`,
                totalCalls,
                overageCalls,
                overageAmount,
                totalAmount,
                invoiceDate: now.toISOString(),
                dueDate: new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 30 days
                status: 'pending',
                createdAt: new Date()
            };

            // Store invoice in Firestore
            await collections.invoices.doc(invoiceNumber).set(invoiceData);

            // Send email
            const emailHTML = generateInvoiceHTML(invoiceData);

            await transporter.sendMail({
                from: process.env.EMAIL_USER,
                to: userData.email,
                subject: `Invoice ${invoiceNumber} - ${process.env.COMPANY_NAME || 'App-Oint Enterprise'}`,
                html: emailHTML
            });

            generatedInvoices.push({
                invoiceNumber,
                clientName: invoiceData.clientName,
                totalAmount,
                status: 'sent'
            });
        }

        res.json({
            message: `Generated ${generatedInvoices.length} invoices`,
            invoices: generatedInvoices
        });

    } catch (error) {
        console.error('Invoice generation error:', error);
        res.status(500).json({ error: 'Failed to generate invoices' });
    }
});

// Get user's invoices
router.get('/user', authenticateFirebaseToken, async (req, res) => {
    try {
        const userId = req.user.uid;

        const invoicesSnapshot = await collections.invoices
            .where('userId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();

        const invoices = [];
        invoicesSnapshot.forEach(doc => {
            const data = doc.data();
            invoices.push({
                invoiceNumber: data.invoiceNumber,
                clientName: data.clientName,
                planName: data.planName,
                totalAmount: data.totalAmount,
                status: data.status,
                invoiceDate: data.invoiceDate,
                dueDate: data.dueDate
            });
        });

        res.json({ invoices });

    } catch (error) {
        console.error('Get user invoices error:', error);
        res.status(500).json({ error: 'Failed to get invoices' });
    }
});

// Get specific invoice
router.get('/:invoiceNumber', authenticateFirebaseToken, async (req, res) => {
    try {
        const { invoiceNumber } = req.params;
        const userId = req.user.uid;

        const invoiceDoc = await collections.invoices.doc(invoiceNumber).get();

        if (!invoiceDoc.exists) {
            return res.status(404).json({ error: 'Invoice not found' });
        }

        const invoiceData = invoiceDoc.data();

        // Check ownership (unless admin)
        const userDoc = await collections.users.doc(userId).get();
        const userData = userDoc.data();

        if (!userData.isAdmin && invoiceData.userId !== userId) {
            return res.status(403).json({ error: 'Access denied' });
        }

        res.json(invoiceData);

    } catch (error) {
        console.error('Get invoice error:', error);
        res.status(500).json({ error: 'Failed to get invoice' });
    }
});

// Update invoice status (admin only)
router.put('/:invoiceNumber/status', authenticateFirebaseToken, async (req, res) => {
    try {
        const { invoiceNumber } = req.params;
        const { status } = req.body;

        // Check if user is admin
        const userDoc = await collections.users.doc(req.user.uid).get();
        const userData = userDoc.data();

        if (!userData.isAdmin) {
            return res.status(403).json({ error: 'Admin access required' });
        }

        await collections.invoices.doc(invoiceNumber).update({
            status,
            updatedAt: new Date()
        });

        res.json({ message: 'Invoice status updated successfully' });

    } catch (error) {
        console.error('Update invoice status error:', error);
        res.status(500).json({ error: 'Failed to update invoice status' });
    }
});

// Get all invoices (admin only)
router.get('/admin/all', authenticateFirebaseToken, async (req, res) => {
    try {
        // Check if user is admin
        const userDoc = await collections.users.doc(req.user.uid).get();
        const userData = userDoc.data();

        if (!userData.isAdmin) {
            return res.status(403).json({ error: 'Admin access required' });
        }

        const invoicesSnapshot = await collections.invoices
            .orderBy('createdAt', 'desc')
            .limit(100)
            .get();

        const invoices = [];
        invoicesSnapshot.forEach(doc => {
            const data = doc.data();
            invoices.push({
                invoiceNumber: data.invoiceNumber,
                clientName: data.clientName,
                clientEmail: data.clientEmail,
                totalAmount: data.totalAmount,
                status: data.status,
                invoiceDate: data.invoiceDate,
                dueDate: data.dueDate
            });
        });

        res.json({ invoices });

    } catch (error) {
        console.error('Get all invoices error:', error);
        res.status(500).json({ error: 'Failed to get invoices' });
    }
});

module.exports = router; 