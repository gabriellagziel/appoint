#!/usr/bin/env node

import * as admin from 'firebase-admin';

interface AnomalyReport {
  timestamp: admin.firestore.Timestamp;
  anomalyType: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  description: string;
  details: Record<string, any>;
  adminIds: string[];
  recommendations: string[];
}

class AnomalyDetector {
  private db: admin.firestore.Firestore;
  private webhookUrl?: string;

  constructor(webhookUrl?: string) {
    if (admin.apps.length === 0) {
      admin.initializeApp();
    }
    this.db = admin.firestore();
    this.webhookUrl = webhookUrl;
  }

  async runNightlyDetection(): Promise<void> {
    console.log('🔍 Starting nightly anomaly detection...');
    
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const startTime = admin.firestore.Timestamp.fromDate(yesterday);
    const endTime = admin.firestore.Timestamp.fromDate(new Date());

    try {
      const logsSnapshot = await this.db
        .collection('admin_logs')
        .where('timestamp', '>=', startTime)
        .where('timestamp', '<=', endTime)
        .get();

      const logs = logsSnapshot.docs.map(doc => ({
        adminId: doc.data().adminId,
        action: doc.data().action,
        timestamp: doc.data().timestamp,
        details: doc.data().details,
        ipAddress: doc.data().ipAddress,
      }));

      console.log(`📊 Analyzing ${logs.length} admin logs...`);

      const anomalies = await this.detectAnomalies(logs);
      
      if (anomalies.length > 0) {
        console.log(`🚨 Found ${anomalies.length} anomalies`);
        await this.storeAnomalies(anomalies);
        
        const criticalAnomalies = anomalies.filter(a => 
          a.severity === 'high' || a.severity === 'critical'
        );
        
        if (criticalAnomalies.length > 0) {
          await this.sendAlert(criticalAnomalies);
        }
      } else {
        console.log('✅ No anomalies detected');
      }

    } catch (error) {
      console.error('❌ Error during anomaly detection:', error);
      throw error;
    }
  }

  private async detectAnomalies(logs: any[]): Promise<AnomalyReport[]> {
    const anomalies: AnomalyReport[] = [];

    // High volume actions
    const actionCounts = new Map<string, number>();
    const adminCounts = new Map<string, number>();

    logs.forEach(log => {
      actionCounts.set(log.action, (actionCounts.get(log.action) || 0) + 1);
      adminCounts.set(log.adminId, (adminCounts.get(log.adminId) || 0) + 1);
    });

    const highVolumeActions = Array.from(actionCounts.entries())
      .filter(([_, count]) => count > 50);

    const highActivityAdmins = Array.from(adminCounts.entries())
      .filter(([_, count]) => count > 100);

    if (highVolumeActions.length > 0 || highActivityAdmins.length > 0) {
      anomalies.push({
        timestamp: admin.firestore.Timestamp.now(),
        anomalyType: 'high_volume_actions',
        severity: 'high',
        description: 'Unusually high volume of admin actions detected',
        details: {
          highVolumeActions,
          highActivityAdmins,
          totalActions: logs.length,
        },
        adminIds: highActivityAdmins.map(([adminId]) => adminId),
        recommendations: [
          'Review admin activity for potential automation or abuse',
          'Consider implementing rate limiting for admin actions',
          'Investigate if this is expected behavior',
        ],
      });
    }

    // Suspicious timing (actions at unusual hours)
    const suspiciousHours = [0, 1, 2, 3, 4, 5, 6];
    const suspiciousLogs = logs.filter(log => {
      const hour = log.timestamp.toDate().getHours();
      return suspiciousHours.includes(hour);
    });

    if (suspiciousLogs.length > 10) {
      const adminIds = [...new Set(suspiciousLogs.map(log => log.adminId))];
      anomalies.push({
        timestamp: admin.firestore.Timestamp.now(),
        anomalyType: 'suspicious_timing',
        severity: 'medium',
        description: 'Admin actions detected during unusual hours',
        details: {
          suspiciousLogsCount: suspiciousLogs.length,
          suspiciousHours,
          totalActions: logs.length,
        },
        adminIds,
        recommendations: [
          'Verify if these actions were performed by authorized personnel',
          'Check for potential unauthorized access',
          'Review admin access patterns',
        ],
      });
    }

    // COPPA violations
    const coppaViolations = logs.filter(log => 
      log.action === 'coppa_violation' ||
      (log.details?.reason && log.details.reason.includes('COPPA'))
    );

    if (coppaViolations.length > 0) {
      const adminIds = [...new Set(coppaViolations.map(log => log.adminId))];
      anomalies.push({
        timestamp: admin.firestore.Timestamp.now(),
        anomalyType: 'coppa_violation_pattern',
        severity: 'critical',
        description: 'COPPA compliance violations detected',
        details: {
          violationsCount: coppaViolations.length,
          totalActions: logs.length,
        },
        adminIds,
        recommendations: [
          'Immediately investigate COPPA violations',
          'Review child data handling procedures',
          'Ensure parental consent is properly obtained',
          'Consider legal review of compliance procedures',
        ],
      });
    }

    return anomalies;
  }

  private async storeAnomalies(anomalies: AnomalyReport[]): Promise<void> {
    const batch = this.db.batch();

    for (const anomaly of anomalies) {
      const docRef = this.db.collection('anomaly_reports').doc();
      batch.set(docRef, {
        ...anomaly,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        resolved: false,
      });
    }

    await batch.commit();
    console.log(`💾 Stored ${anomalies.length} anomalies in Firestore`);
  }

  private async sendAlert(anomalies: AnomalyReport[]): Promise<void> {
    if (!this.webhookUrl) {
      console.log('⚠️ No webhook URL configured - skipping alert');
      return;
    }

    const criticalCount = anomalies.filter(a => a.severity === 'critical').length;
    const highCount = anomalies.filter(a => a.severity === 'high').length;

    const message = {
      text: `🚨 Admin Panel Anomaly Alert`,
      attachments: [{
        color: criticalCount > 0 ? 'danger' : 'warning',
        fields: [
          {
            title: 'Critical Anomalies',
            value: criticalCount.toString(),
            short: true,
          },
          {
            title: 'High Severity Anomalies',
            value: highCount.toString(),
            short: true,
          },
          {
            title: 'Anomaly Types',
            value: anomalies.map(a => a.anomalyType).join(', '),
            short: false,
          },
        ],
        footer: 'Admin Panel Anomaly Detector',
        ts: Math.floor(Date.now() / 1000),
      }],
    };

    try {
      const response = await fetch(this.webhookUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(message),
      });

      if (response.ok) {
        console.log('📢 Alert sent successfully');
      } else {
        console.error('❌ Failed to send alert:', response.statusText);
      }
    } catch (error) {
      console.error('❌ Error sending alert:', error);
    }
  }
}

// CLI interface
if (require.main === module) {
  const webhookUrl = process.env.ANOMALY_WEBHOOK_URL;
  const detector = new AnomalyDetector(webhookUrl);

  detector.runNightlyDetection()
    .then(() => {
      console.log('✅ Anomaly detection completed');
      process.exit(0);
    })
    .catch((error) => {
      console.error('❌ Anomaly detection failed:', error);
      process.exit(1);
    });
}

export { AnomalyDetector, AnomalyReport };
