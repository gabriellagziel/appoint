import { agentHelpers } from '../utils/agent-helpers';
import { logAdminAction, fetchLatestInvoice, manageUser, manageAppointment } from '../utils/firebase-helpers';
import { getOpenPullRequests, commentOnPR, getCommitStatus } from '../utils/github-helpers';

/**
 * Demo: Show agent capabilities in action
 */
export async function demonstrateAgentCapabilities() {
  console.log('🚀 Starting Agent Capabilities Demo...\n');

  try {
    // 1. GitHub Integration Demo
    console.log('📦 1. GitHub Integration Demo');
    console.log('   - Checking open PRs...');
    const openPRs = await getOpenPullRequests('main', {
      owner: 'app-oint',
      repo: 'app-oint'
    });
    console.log(`   ✅ Found ${openPRs.length} open PRs`);

    // 2. Firebase Admin Demo
    console.log('\n🔥 2. Firebase Admin Demo');
    console.log('   - Logging admin action...');
    await logAdminAction('demo-agent', 'capability_demo', {
      feature: 'agent_enhancement',
      timestamp: new Date().toISOString()
    });
    console.log('   ✅ Admin action logged');

    // 3. Automated PR Review Demo
    console.log('\n🤖 3. Automated PR Review Demo');
    if (openPRs.length > 0) {
      const firstPR = openPRs[0];
      console.log(`   - Reviewing PR #${firstPR.number}...`);
      
      // Get commit status
      const status = await getCommitStatus(firstPR.head.sha, {
        owner: 'app-oint',
        repo: 'app-oint'
      });
      
             // Generate automated comment
       const reviewComment = `## 🤖 Automated Review Demo

**PR Status:** ${status.state === 'success' ? '✅' : '⚠️'} ${status.state}

**Changes:**
- PR Number: #${firstPR.number}
- Title: ${firstPR.title}
- State: ${firstPR.state}

**CI Status:** ${status.state}

This is a demo of the agent's automated review capabilities!`;

      // Comment on PR (commented out to avoid spam)
      // await commentOnPR(firstPR.number, reviewComment, {
      //   owner: 'app-oint',
      //   repo: 'app-oint'
      // });
      
      console.log('   ✅ Automated review comment generated');
    }

    // 4. Business Workflow Automation Demo
    console.log('\n💼 4. Business Workflow Automation Demo');
    console.log('   - Automating business workflows...');
    await agentHelpers.automateBusinessWorkflow('demo-business-id');
    console.log('   ✅ Business workflow automated');

    // 5. System Health Check Demo
    console.log('\n🏥 5. System Health Check Demo');
    console.log('   - Performing system health check...');
    const healthReport = await agentHelpers.performSystemHealthCheck();
    console.log('   ✅ System health check completed');
    console.log(`   📊 Health Report:`, {
      timestamp: healthReport.timestamp,
      github: healthReport.github,
      firebase: healthReport.firebase,
      system: {
        uptime: Math.round(healthReport.system.uptime),
        memoryUsage: Math.round(healthReport.system.memory.heapUsed / 1024 / 1024) + 'MB'
      }
    });

    // 6. User Management Demo
    console.log('\n👥 6. User Management Demo');
    console.log('   - Managing users programmatically...');
    try {
      const userRecord = await manageUser('create', {
        email: 'demo@example.com',
        password: 'demo123456',
        displayName: 'Demo User'
      });
      console.log(`   ✅ Created user: ${(userRecord as any).uid}`);
      
      // Clean up - delete the demo user
      await manageUser('delete', { uid: (userRecord as any).uid, email: 'demo@example.com' });
      console.log('   ✅ Cleaned up demo user');
    } catch (error) {
      console.log('   ⚠️ User management demo skipped (likely already exists)');
    }

    // 7. Appointment Management Demo
    console.log('\n📅 7. Appointment Management Demo');
    console.log('   - Managing appointments...');
    const appointmentData = {
      customerName: 'Demo Customer',
      service: 'Demo Service',
      date: new Date(),
      duration: 60,
      status: 'scheduled'
    };
    
    const appointment = await manageAppointment('create', appointmentData, 'demo-business-id');
    console.log(`   ✅ Created appointment: ${appointment.id}`);
    
    // Clean up - delete the demo appointment
    await manageAppointment('delete', { id: appointment.id }, 'demo-business-id');
    console.log('   ✅ Cleaned up demo appointment');

    console.log('\n🎉 Agent Capabilities Demo Completed Successfully!');
    console.log('\n📋 Summary of Capabilities:');
    console.log('   ✅ GitHub Integration (PR monitoring, commenting, CI/CD)');
    console.log('   ✅ Firebase Admin SDK (user/appointment management, logging)');
    console.log('   ✅ Automated PR Reviews');
    console.log('   ✅ Business Workflow Automation');
    console.log('   ✅ System Health Monitoring');
    console.log('   ✅ Admin Action Logging');
    console.log('   ✅ Invoice Management');
    console.log('   ✅ Scheduled Task Execution');

  } catch (error) {
    console.error('❌ Demo failed:', error);
    throw error;
  }
}

/**
 * Demo: Show specific workflow automation
 */
export async function demonstrateWorkflowAutomation() {
  console.log('🔄 Starting Workflow Automation Demo...\n');

  try {
    // Monitor branch merges
    console.log('📊 Monitoring branch merges...');
    const mergedPRs = await agentHelpers.monitorAndRespondToMerges('main');
    console.log(`   ✅ Found ${mergedPRs.length} recently merged PRs`);

    // Perform system health check
    console.log('🏥 Performing system health check...');
    const health = await agentHelpers.performSystemHealthCheck();
    console.log('   ✅ System health check completed');

    // Log the automation
    await logAdminAction('agent', 'workflow_automation_demo', {
      mergedPRs: mergedPRs.length,
      healthCheck: health.timestamp,
      automationType: 'scheduled'
    });

    console.log('✅ Workflow automation demo completed');

  } catch (error) {
    console.error('❌ Workflow automation demo failed:', error);
    throw error;
  }
}

// Export demo functions for easy access
export const demos = {
  capabilities: demonstrateAgentCapabilities,
  workflows: demonstrateWorkflowAutomation
}; 