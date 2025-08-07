// Email service for business registration notifications
// Uses SendGrid for sending emails

interface EmailData {
    to: string
    subject: string
    html: string
    text?: string
}

export const sendEmail = async (emailData: EmailData): Promise<void> => {
    const sendgridApiKey = process.env.SENDGRID_API_KEY
    const fromEmail = process.env.SENDGRID_FROM_EMAIL || 'noreply@app-oint.com'

    if (!sendgridApiKey) {
        console.log('📧 Email not sent - SENDGRID_API_KEY not configured')
        console.log('📧 Would send:', emailData)
        return
    }

    try {
        const response = await fetch('https://api.sendgrid.com/v3/mail/send', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${sendgridApiKey}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                personalizations: [
                    {
                        to: [{ email: emailData.to }],
                        subject: emailData.subject,
                    },
                ],
                from: { email: fromEmail, name: 'App-Oint Enterprise API' },
                content: [
                    {
                        type: 'text/html',
                        value: emailData.html,
                    },
                ],
            }),
        })

        if (!response.ok) {
            throw new Error(`SendGrid API error: ${response.status}`)
        }

        console.log(`📧 Email sent successfully to ${emailData.to}`)
    } catch (error) {
        console.error('📧 Email sending failed:', error)
        throw error
    }
}

export const sendApprovalEmail = async (email: string, apiKey: string, companyName: string): Promise<void> => {
    const subject = '🎉 Your App-Oint Enterprise API Access is Approved!'

    const html = `
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background: #3b82f6; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { background: #f9fafb; padding: 20px; border-radius: 0 0 8px 8px; }
                .api-key { background: #1f2937; color: #fbbf24; padding: 15px; border-radius: 6px; font-family: monospace; font-size: 14px; margin: 20px 0; }
                .button { display: inline-block; background: #10b981; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
                .footer { text-align: center; margin-top: 30px; color: #6b7280; font-size: 14px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🚀 Welcome to App-Oint Enterprise API!</h1>
                </div>
                <div class="content">
                    <h2>Congratulations, ${companyName}!</h2>
                    <p>Your business registration has been approved. You now have access to the App-Oint Enterprise API.</p>
                    
                    <h3>Your API Key</h3>
                    <div class="api-key">${apiKey}</div>
                    <p><strong>Keep this key secure!</strong> It provides access to your API account.</p>
                    
                    <h3>Next Steps</h3>
                    <ol>
                        <li>Store your API key securely</li>
                        <li>Review our <a href="https://docs.app-oint.com">API documentation</a></li>
                        <li>Start integrating the API into your application</li>
                        <li>Monitor your usage in the <a href="https://api.app-oint.com/dashboard">dashboard</a></li>
                    </ol>
                    
                    <a href="https://docs.app-oint.com" class="button">📚 View Documentation</a>
                    
                    <h3>Support</h3>
                    <p>Need help getting started? Contact our support team:</p>
                    <ul>
                        <li>📧 Email: support@app-oint.com</li>
                        <li>💬 Chat: Available in your dashboard</li>
                        <li>📞 Phone: +1 (555) 123-4567</li>
                    </ul>
                </div>
                <div class="footer">
                    <p>App-Oint Enterprise API Team</p>
                    <p>This is an automated message. Please do not reply to this email.</p>
                </div>
            </div>
        </body>
        </html>
    `

    await sendEmail({
        to: email,
        subject,
        html,
    })
}

export const sendRejectionEmail = async (email: string, companyName: string, reason?: string): Promise<void> => {
    const subject = 'App-Oint Enterprise API Application Update'

    const html = `
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background: #ef4444; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { background: #f9fafb; padding: 20px; border-radius: 0 0 8px 8px; }
                .footer { text-align: center; margin-top: 30px; color: #6b7280; font-size: 14px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Application Update</h1>
                </div>
                <div class="content">
                    <h2>Dear ${companyName},</h2>
                    <p>Thank you for your interest in the App-Oint Enterprise API.</p>
                    
                    <p>After careful review of your application, we regret to inform you that we are unable to approve your request at this time.</p>
                    
                    ${reason ? `<p><strong>Reason:</strong> ${reason}</p>` : ''}
                    
                    <h3>What's Next?</h3>
                    <ul>
                        <li>You may reapply in 30 days</li>
                        <li>Consider our <a href="https://app-oint.com">standard App-Oint platform</a> for smaller businesses</li>
                        <li>Contact us if you have questions about the decision</li>
                    </ul>
                    
                    <h3>Questions?</h3>
                    <p>If you have any questions about this decision, please contact us:</p>
                    <ul>
                        <li>📧 Email: support@app-oint.com</li>
                        <li>📞 Phone: +1 (555) 123-4567</li>
                    </ul>
                    
                    <p>Thank you for your understanding.</p>
                </div>
                <div class="footer">
                    <p>App-Oint Enterprise API Team</p>
                    <p>This is an automated message. Please do not reply to this email.</p>
                </div>
            </div>
        </body>
        </html>
    `

    await sendEmail({
        to: email,
        subject,
        html,
    })
}

export const sendAdminNotification = async (registrationData: any): Promise<void> => {
    const adminEmail = process.env.ADMIN_EMAIL || 'admin@app-oint.com'
    const subject = '🆕 New Business Registration Received'

    const html = `
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background: #3b82f6; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
                .content { background: #f9fafb; padding: 20px; border-radius: 0 0 8px 8px; }
                .info { background: white; padding: 15px; border-radius: 6px; margin: 10px 0; }
                .button { display: inline-block; background: #3b82f6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🆕 New Business Registration</h1>
                </div>
                <div class="content">
                    <h2>New registration received:</h2>
                    
                    <div class="info">
                        <strong>Company:</strong> ${registrationData.companyName}<br>
                        <strong>Contact:</strong> ${registrationData.contactName}<br>
                        <strong>Email:</strong> ${registrationData.contactEmail}<br>
                        <strong>Industry:</strong> ${registrationData.industry}<br>
                        <strong>Size:</strong> ${registrationData.employeeCount}<br>
                        <strong>Use Case:</strong> ${registrationData.useCase}
                    </div>
                    
                    <a href="https://api.app-oint.com/admin/business/registrations" class="button">Review Registration</a>
                </div>
            </div>
        </body>
        </html>
    `

    await sendEmail({
        to: adminEmail,
        subject,
        html,
    })
} 