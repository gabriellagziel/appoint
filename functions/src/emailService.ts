import * as admin from 'firebase-admin';
import * as nodemailer from 'nodemailer';

// Initialize Firebase Admin if not already initialised
if (!admin.apps.length) {
    admin.initializeApp();
}

// Email configuration
const transporter = nodemailer.createTransporter({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'noreply@appoint.com',
        pass: process.env.EMAIL_PASS || 'secure-password'
    },
    secure: true,
    tls: {
        rejectUnauthorized: false
    }
});

interface ApiKeyEmailData {
    companyName: string;
    contactName: string;
    email: string;
    apiKey: string;
    businessId: string;
    monthlyQuota: number;
    dashboardUrl: string;
}

interface WelcomeEmailData {
    companyName: string;
    contactName: string;
    email: string;
    plan: string;
    dashboardUrl: string;
}

/**
 * Send API key email to newly registered business
 */
export async function sendApiKeyEmail(data: ApiKeyEmailData): Promise<void> {
    const { companyName, contactName, email, apiKey, businessId, monthlyQuota, dashboardUrl } = data;

    const subject = `Your App-Oint Enterprise API Access - ${companyName}`;

    const htmlBody = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Your API Access</title>
      <style>
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: white; padding: 30px; border-radius: 12px; text-align: center; }
        .content { background: white; padding: 30px; border-radius: 12px; margin-top: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .api-key-box { background: #f1f5f9; padding: 20px; border-radius: 8px; font-family: monospace; font-size: 14px; word-break: break-all; margin: 20px 0; }
        .button { display: inline-block; background: #2563eb; color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px; font-weight: 600; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .warning { background: #fef3c7; border: 1px solid #f59e0b; padding: 15px; border-radius: 8px; margin: 20px 0; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎉 Welcome to App-Oint Enterprise!</h1>
          <p>Your API access is ready</p>
        </div>
        
        <div class="content">
          <h2>Hello ${contactName},</h2>
          
          <p>Thank you for registering <strong>${companyName}</strong> with App-Oint Enterprise API. Your account has been successfully created and your API access is now active.</p>
          
          <h3>🔑 Your API Key</h3>
          <p>Here's your unique API key for accessing our services:</p>
          <div class="api-key-box">${apiKey}</div>
          
          <div class="warning">
            <strong>⚠️ Security Notice:</strong> Keep this API key secure and never share it publicly. 
            You can regenerate it anytime from your dashboard if needed.
          </div>
          
          <h3>📊 Your Account Details</h3>
          <ul>
            <li><strong>Business ID:</strong> ${businessId}</li>
            <li><strong>Monthly Quota:</strong> ${monthlyQuota.toLocaleString()} API calls</li>
            <li><strong>Status:</strong> Active</li>
          </ul>
          
          <h3>🚀 Next Steps</h3>
          <ol>
            <li>Access your <a href="${dashboardUrl}" class="button">Enterprise Dashboard</a></li>
            <li>Review our <a href="https://docs.app-oint.com">API Documentation</a></li>
            <li>Start integrating with your first API call</li>
            <li>Monitor usage and billing in your dashboard</li>
          </ol>
          
          <h3>📚 Quick Start Guide</h3>
          <p>To make your first API call:</p>
          <div class="api-key-box">
curl -X POST https://api.app-oint.com/v1/appointments \\<br>
  -H "X-API-Key: ${apiKey}" \\<br>
  -H "Content-Type: application/json" \\<br>
  -d '{"customerEmail": "customer@example.com", "appointmentTime": "2025-01-15T10:00:00Z"}'
          </div>
          
          <h3>💬 Support</h3>
          <p>Need help getting started?</p>
          <ul>
            <li>📖 <a href="https://docs.app-oint.com">Documentation</a></li>
            <li>💬 <a href="mailto:support@app-oint.com">Email Support</a></li>
            <li>📞 <a href="tel:+1-555-0123">Phone Support</a> (Enterprise customers)</li>
          </ul>
        </div>
        
        <div class="footer">
          <p>© 2025 App-Oint. All rights reserved.</p>
          <p>This email was sent to ${email} for ${companyName}</p>
        </div>
      </div>
    </body>
    </html>
  `;

    const textBody = `
Welcome to App-Oint Enterprise!

Hello ${contactName},

Thank you for registering ${companyName} with App-Oint Enterprise API. Your account has been successfully created and your API access is now active.

YOUR API KEY:
${apiKey}

SECURITY NOTICE: Keep this API key secure and never share it publicly. You can regenerate it anytime from your dashboard if needed.

ACCOUNT DETAILS:
- Business ID: ${businessId}
- Monthly Quota: ${monthlyQuota.toLocaleString()} API calls
- Status: Active

NEXT STEPS:
1. Access your Enterprise Dashboard: ${dashboardUrl}
2. Review our API Documentation: https://docs.app-oint.com
3. Start integrating with your first API call
4. Monitor usage and billing in your dashboard

QUICK START:
To make your first API call:

curl -X POST https://api.app-oint.com/v1/appointments \\
  -H "X-API-Key: ${apiKey}" \\
  -H "Content-Type: application/json" \\
  -d '{"customerEmail": "customer@example.com", "appointmentTime": "2025-01-15T10:00:00Z"}'

SUPPORT:
- Documentation: https://docs.app-oint.com
- Email Support: support@app-oint.com
- Phone Support: +1-555-0123 (Enterprise customers)

© 2025 App-Oint. All rights reserved.
This email was sent to ${email} for ${companyName}
  `;

    const mailOptions = {
        from: process.env.EMAIL_USER || 'noreply@appoint.com',
        to: email,
        subject: subject,
        html: htmlBody,
        text: textBody
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`✅ API key email sent to ${email} for ${companyName}`);

        // Log email sent to Firestore
        await admin.firestore().collection('email_logs').add({
            type: 'api_key_email',
            businessId: businessId,
            email: email,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
            success: true
        });
    } catch (error) {
        console.error('❌ Failed to send API key email:', error);

        // Log failed email attempt
        await admin.firestore().collection('email_logs').add({
            type: 'api_key_email',
            businessId: businessId,
            email: email,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
            success: false,
            error: error instanceof Error ? error.message : 'Unknown error'
        });

        throw error;
    }
}

/**
 * Send welcome email to newly registered business
 */
export async function sendWelcomeEmail(data: WelcomeEmailData): Promise<void> {
    const { companyName, contactName, email, plan, dashboardUrl } = data;

    const subject = `Welcome to App-Oint Enterprise - ${companyName}`;

    const htmlBody = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Welcome to App-Oint</title>
      <style>
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: white; padding: 30px; border-radius: 12px; text-align: center; }
        .content { background: white; padding: 30px; border-radius: 12px; margin-top: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .button { display: inline-block; background: #2563eb; color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px; font-weight: 600; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎉 Welcome to App-Oint Enterprise!</h1>
          <p>Your account is being set up</p>
        </div>
        
        <div class="content">
          <h2>Hello ${contactName},</h2>
          
          <p>Thank you for registering <strong>${companyName}</strong> with App-Oint Enterprise API. We're excited to have you on board!</p>
          
          <h3>📋 What's Next?</h3>
          <p>Our team is reviewing your registration and will activate your API access within 24 hours. You'll receive a separate email with your API key once your account is approved.</p>
          
          <h3>📊 Your Plan Details</h3>
          <ul>
            <li><strong>Plan:</strong> ${plan}</li>
            <li><strong>Status:</strong> Pending Approval</li>
            <li><strong>Expected Activation:</strong> Within 24 hours</li>
          </ul>
          
          <h3>🚀 Get Ready</h3>
          <p>While you wait, you can:</p>
          <ul>
            <li>Review our <a href="https://docs.app-oint.com">API Documentation</a></li>
            <li>Explore your <a href="${dashboardUrl}" class="button">Dashboard</a></li>
            <li>Check out our <a href="https://github.com/appoint/examples">Code Examples</a></li>
          </ul>
          
          <h3>💬 Questions?</h3>
          <p>Our support team is here to help:</p>
          <ul>
            <li>📧 <a href="mailto:support@app-oint.com">support@app-oint.com</a></li>
            <li>📞 <a href="tel:+1-555-0123">+1-555-0123</a> (Enterprise customers)</li>
            <li>💬 <a href="https://app-oint.com/support">Live Chat</a></li>
          </ul>
        </div>
        
        <div class="footer">
          <p>© 2025 App-Oint. All rights reserved.</p>
          <p>This email was sent to ${email} for ${companyName}</p>
        </div>
      </div>
    </body>
    </html>
  `;

    const textBody = `
Welcome to App-Oint Enterprise!

Hello ${contactName},

Thank you for registering ${companyName} with App-Oint Enterprise API. We're excited to have you on board!

WHAT'S NEXT?
Our team is reviewing your registration and will activate your API access within 24 hours. You'll receive a separate email with your API key once your account is approved.

YOUR PLAN DETAILS:
- Plan: ${plan}
- Status: Pending Approval
- Expected Activation: Within 24 hours

GET READY:
While you wait, you can:
- Review our API Documentation: https://docs.app-oint.com
- Explore your Dashboard: ${dashboardUrl}
- Check out our Code Examples: https://github.com/appoint/examples

QUESTIONS?
Our support team is here to help:
- Email: support@app-oint.com
- Phone: +1-555-0123 (Enterprise customers)
- Live Chat: https://app-oint.com/support

© 2025 App-Oint. All rights reserved.
This email was sent to ${email} for ${companyName}
  `;

    const mailOptions = {
        from: process.env.EMAIL_USER || 'noreply@appoint.com',
        to: email,
        subject: subject,
        html: htmlBody,
        text: textBody
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`✅ Welcome email sent to ${email} for ${companyName}`);

        // Log email sent to Firestore
        await admin.firestore().collection('email_logs').add({
            type: 'welcome_email',
            email: email,
            companyName: companyName,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
            success: true
        });
    } catch (error) {
        console.error('❌ Failed to send welcome email:', error);

        // Log failed email attempt
        await admin.firestore().collection('email_logs').add({
            type: 'welcome_email',
            email: email,
            companyName: companyName,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
            success: false,
            error: error instanceof Error ? error.message : 'Unknown error'
        });

        throw error;
    }
}

/**
 * Send invoice email with PDF attachment
 */
export async function sendInvoiceEmail(
    to: string,
    pdfBuffer: Buffer,
    filename: string,
    isOverageInvoice = false
): Promise<void> {
    const subject = isOverageInvoice
        ? 'App-Oint Enterprise - Map Usage Invoice'
        : 'App-Oint Enterprise - Monthly Invoice';

    const htmlBody = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Invoice</title>
      <style>
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: white; padding: 30px; border-radius: 12px; text-align: center; }
        .content { background: white; padding: 30px; border-radius: 12px; margin-top: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>📄 Invoice Available</h1>
          <p>Your ${isOverageInvoice ? 'map usage' : 'monthly'} invoice is ready</p>
        </div>
        
        <div class="content">
          <h2>Hello,</h2>
          
          <p>Your ${isOverageInvoice ? 'map usage' : 'monthly'} invoice for App-Oint Enterprise API is attached to this email.</p>
          
          <h3>📋 Payment Details</h3>
          <ul>
            <li><strong>Invoice Type:</strong> ${isOverageInvoice ? 'Map Usage Overage' : 'Monthly Subscription'}</li>
            <li><strong>Payment Method:</strong> Bank Transfer</li>
            <li><strong>Due Date:</strong> 7-10 business days</li>
          </ul>
          
          <h3>🏦 Bank Transfer Information</h3>
          <p>Please use the following details for payment:</p>
          <ul>
            <li><strong>Account Name:</strong> App-Oint Enterprise</li>
            <li><strong>IBAN:</strong> DE89370400440532013000</li>
            <li><strong>SWIFT:</strong> COBADEFFXXX</li>
            <li><strong>Reference:</strong> Your Business ID</li>
          </ul>
          
          <h3>❓ Questions?</h3>
          <p>If you have any questions about this invoice, please contact our billing team:</p>
          <ul>
            <li>📧 <a href="mailto:billing@app-oint.com">billing@app-oint.com</a></li>
            <li>📞 <a href="tel:+1-555-0123">+1-555-0123</a></li>
          </ul>
        </div>
        
        <div class="footer">
          <p>© 2025 App-Oint. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
  `;

    const textBody = `
Invoice Available

Hello,

Your ${isOverageInvoice ? 'map usage' : 'monthly'} invoice for App-Oint Enterprise API is attached to this email.

PAYMENT DETAILS:
- Invoice Type: ${isOverageInvoice ? 'Map Usage Overage' : 'Monthly Subscription'}
- Payment Method: Bank Transfer
- Due Date: 7-10 business days

BANK TRANSFER INFORMATION:
Please use the following details for payment:
- Account Name: App-Oint Enterprise
- IBAN: DE89370400440532013000
- SWIFT: COBADEFFXXX
- Reference: Your Business ID

QUESTIONS?
If you have any questions about this invoice, please contact our billing team:
- Email: billing@app-oint.com
- Phone: +1-555-0123

© 2025 App-Oint. All rights reserved.
  `;

    const mailOptions = {
        from: process.env.EMAIL_USER || 'noreply@appoint.com',
        to: to,
        subject: subject,
        html: htmlBody,
        text: textBody,
        attachments: [
            {
                filename: filename,
                content: pdfBuffer,
                contentType: 'application/pdf'
            }
        ]
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`✅ Invoice email sent to ${to}`);

        // Log email sent to Firestore
        await admin.firestore().collection('email_logs').add({
            type: 'invoice_email',
            email: to,
            filename: filename,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
            success: true
        });
    } catch (error) {
        console.error('❌ Failed to send invoice email:', error);

        // Log failed email attempt
        await admin.firestore().collection('email_logs').add({
            type: 'invoice_email',
            email: to,
            filename: filename,
            sentAt: admin.firestore.FieldValue.serverTimestamp(),
            success: false,
            error: error instanceof Error ? error.message : 'Unknown error'
        });

        throw error;
    }
} 