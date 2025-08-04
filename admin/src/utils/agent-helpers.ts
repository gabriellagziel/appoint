import { Octokit } from '@octokit/rest';
import * as admin from 'firebase-admin';
import { logAdminAction, fetchLatestInvoice, manageUser, manageAppointment } from './firebase-helpers';
import { getOpenPullRequests, commentOnPR, getCommitStatus, monitorBranchMerges } from './github-helpers';

// Initialize Octokit
const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Comprehensive helper for agent workflows
 */
export class AgentWorkflowHelpers {
  private githubConfig: {
    owner: string;
    repo: string;
  };

  constructor(githubConfig: { owner: string; repo: string }) {
    this.githubConfig = githubConfig;
  }

  /**
   * Automated PR review workflow
   */
  async automatedPRReview(prNumber: number, branch: string) {
    try {
      // Get PR details
      const pr = await octokit.pulls.get({
        owner: this.githubConfig.owner,
        repo: this.githubConfig.repo,
        pull_number: prNumber,
      });

      // Check CI status
      const status = await getCommitStatus(pr.data.head.sha, this.githubConfig);
      
      // Generate review comment
      const reviewComment = this.generateReviewComment(pr.data, status);
      
      // Post comment
      await commentOnPR(prNumber, reviewComment, this.githubConfig);
      
      // Log action
      await logAdminAction('agent', 'automated_pr_review', {
        prNumber,
        branch,
        status: status.state,
      });

      console.log(`✅ Automated PR review completed for #${prNumber}`);
    } catch (error) {
      console.error('Error in automated PR review:', error);
      throw error;
    }
  }

  /**
   * Monitor and respond to branch merges
   */
  async monitorAndRespondToMerges(baseBranch: string = 'main') {
    try {
      const mergedPRs = await monitorBranchMerges(baseBranch, this.githubConfig, async (pr) => {
        // Auto-deploy on merge
        await this.autoDeployOnMerge(pr);
        
        // Update deployment status
        await this.updateDeploymentStatus(pr.number, 'deployed');
        
        // Log merge
        await logAdminAction('agent', 'branch_merge_detected', {
          prNumber: pr.number,
          baseBranch,
          mergedAt: pr.merged_at,
        });
      });

      return mergedPRs;
    } catch (error) {
      console.error('Error monitoring merges:', error);
      throw error;
    }
  }

  /**
   * Auto-deploy on merge
   */
  private async autoDeployOnMerge(pr: any) {
    try {
      // Trigger deployment
      const deploymentComment = `🚀 Auto-deploying changes from PR #${pr.number}\n\n` +
        `- Branch: ${pr.head.ref}\n` +
        `- Commit: ${pr.head.sha.substring(0, 7)}\n` +
        `- Merged by: ${pr.merged_by?.login}\n\n` +
        `Deployment started at ${new Date().toISOString()}`;

      await commentOnPR(pr.number, deploymentComment, this.githubConfig);
      
      console.log(`✅ Auto-deploy triggered for PR #${pr.number}`);
    } catch (error) {
      console.error('Error in auto-deploy:', error);
      throw error;
    }
  }

  /**
   * Update deployment status
   */
  private async updateDeploymentStatus(prNumber: number, status: string) {
    try {
      await db.collection('deployments').add({
        prNumber,
        status,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (error) {
      console.error('Error updating deployment status:', error);
      throw error;
    }
  }

  /**
   * Generate review comment
   */
  private generateReviewComment(pr: any, status: any): string {
    const statusEmoji = status.state === 'success' ? '✅' : 
                       status.state === 'failure' ? '❌' : '⚠️';
    
    return `## 🤖 Automated Review

**PR Status:** ${statusEmoji} ${status.state}

**Changes:**
- Files changed: ${pr.changed_files}
- Additions: +${pr.additions}
- Deletions: -${pr.deletions}

**CI Status:** ${status.state}
${status.statuses?.map((s: any) => `- ${s.context}: ${s.state}`).join('\n') || 'No status checks found'}

**Recommendations:**
${this.generateRecommendations(pr, status)}`;
  }

  /**
   * Generate recommendations based on PR analysis
   */
  private generateRecommendations(pr: any, status: any): string {
    const recommendations = [];
    
    if (pr.changed_files > 50) {
      recommendations.push('- ⚠️ Large PR detected. Consider breaking into smaller changes.');
    }
    
    if (status.state === 'failure') {
      recommendations.push('- ❌ CI checks failed. Please fix the issues before merging.');
    }
    
    if (pr.additions > 1000) {
      recommendations.push('- 📝 Large number of additions. Consider code review best practices.');
    }
    
    if (recommendations.length === 0) {
      recommendations.push('- ✅ PR looks good! Ready for review.');
    }
    
    return recommendations.join('\n');
  }

  /**
   * Business workflow automation
   */
  async automateBusinessWorkflow(businessId: string) {
    try {
      // Fetch latest invoice
      const latestInvoice = await fetchLatestInvoice(businessId);
      
      // Check for overdue invoices
      if (latestInvoice && this.isInvoiceOverdue(latestInvoice)) {
        await this.handleOverdueInvoice(businessId, latestInvoice);
      }
      
      // Update business metrics
      await this.updateBusinessMetrics(businessId);
      
      console.log(`✅ Business workflow automated for ${businessId}`);
    } catch (error) {
      console.error('Error in business workflow automation:', error);
      throw error;
    }
  }

  /**
   * Check if invoice is overdue
   */
  private isInvoiceOverdue(invoice: any): boolean {
    const dueDate = new Date(invoice.dueDate);
    const now = new Date();
    return dueDate < now && invoice.status !== 'paid';
  }

  /**
   * Handle overdue invoice
   */
  private async handleOverdueInvoice(businessId: string, invoice: any) {
    try {
      // Send reminder
      await this.sendInvoiceReminder(businessId, invoice);
      
      // Log action
      await logAdminAction('agent', 'overdue_invoice_handled', {
        businessId,
        invoiceId: invoice.id,
        dueDate: invoice.dueDate,
      });
      
      console.log(`✅ Handled overdue invoice for ${businessId}`);
    } catch (error) {
      console.error('Error handling overdue invoice:', error);
      throw error;
    }
  }

  /**
   * Send invoice reminder
   */
  private async sendInvoiceReminder(businessId: string, invoice: any) {
    // Implementation for sending email/SMS reminders
    console.log(`📧 Sending reminder for invoice ${invoice.id} to business ${businessId}`);
  }

  /**
   * Update business metrics
   */
  private async updateBusinessMetrics(businessId: string) {
    try {
      const metrics = {
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
        // Add more metrics as needed
      };
      
      await db.collection('businesses').doc(businessId).update({
        metrics,
      });
    } catch (error) {
      console.error('Error updating business metrics:', error);
      throw error;
    }
  }

  /**
   * Comprehensive system health check
   */
  async performSystemHealthCheck() {
    try {
      const healthReport = {
        timestamp: new Date(),
        github: {
          openPRs: await getOpenPullRequests('main', this.githubConfig).then(prs => prs.length),
        },
        firebase: {
          collections: await db.listCollections().then(cols => cols.length),
        },
        system: {
          uptime: process.uptime(),
          memory: process.memoryUsage(),
        },
      };
      
      // Store health report
      await db.collection('system').doc('health_reports').collection('reports').add(healthReport);
      
      console.log('✅ System health check completed');
      return healthReport;
    } catch (error) {
      console.error('Error in system health check:', error);
      throw error;
    }
  }
}

// Export singleton instance
export const agentHelpers = new AgentWorkflowHelpers({
  owner: process.env.GITHUB_OWNER || 'app-oint',
  repo: process.env.GITHUB_REPO || 'app-oint',
}); 