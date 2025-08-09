#!/usr/bin/env ts-node

/**
 * Telemetry Verification Script for Share-in-Groups Feature
 * 
 * This script verifies that all required analytics events are firing correctly
 * in the last 24 hours. It checks for the presence and counts of key events
 * and provides a conversion funnel analysis.
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

// Initialize Firebase Admin
const serviceAccount = process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!serviceAccount) {
  console.error('❌ GOOGLE_APPLICATION_CREDENTIALS environment variable not set');
  process.exit(1);
}

initializeApp({
  credential: cert(serviceAccount)
});

const db = getFirestore();

interface AnalyticsEvent {
  event: string;
  meetingId?: string;
  groupId?: string;
  source?: string;
  shareId?: string;
  userId?: string;
  guestToken?: string;
  status?: string;
  timestamp: any;
}

interface EventCounts {
  share_link_created: number;
  share_link_clicked: number;
  group_member_joined_from_share: number;
  rsvp_submitted_from_share: number;
  guest_token_created: number;
  guest_token_validated: number;
  rate_limit_hit: number;
  public_meeting_page_viewed: number;
}

interface ConversionFunnel {
  shareLinksCreated: number;
  shareLinksClicked: number;
  clickThroughRate: number;
  groupMembersJoined: number;
  rsvpsSubmitted: number;
  conversionRate: number;
}

async function getAnalyticsEvents(hours: number = 24): Promise<AnalyticsEvent[]> {
  const now = new Date();
  const startTime = new Date(now.getTime() - (hours * 60 * 60 * 1000));
  
  console.log(`📊 Fetching analytics events from ${startTime.toISOString()} to ${now.toISOString()}`);
  
  const snapshot = await db.collection('analytics')
    .where('timestamp', '>=', startTime)
    .where('event', 'in', [
      'share_link_created',
      'share_link_clicked', 
      'group_member_joined_from_share',
      'rsvp_submitted_from_share',
      'guest_token_created',
      'guest_token_validated',
      'rate_limit_hit',
      'public_meeting_page_viewed'
    ])
    .orderBy('timestamp', 'desc')
    .get();

  return snapshot.docs.map(doc => doc.data() as AnalyticsEvent);
}

function countEvents(events: AnalyticsEvent[]): EventCounts {
  const counts: EventCounts = {
    share_link_created: 0,
    share_link_clicked: 0,
    group_member_joined_from_share: 0,
    rsvp_submitted_from_share: 0,
    guest_token_created: 0,
    guest_token_validated: 0,
    rate_limit_hit: 0,
    public_meeting_page_viewed: 0
  };

  events.forEach(event => {
    if (event.event in counts) {
      counts[event.event as keyof EventCounts]++;
    }
  });

  return counts;
}

function calculateConversionFunnel(counts: EventCounts): ConversionFunnel {
  const shareLinksCreated = counts.share_link_created;
  const shareLinksClicked = counts.share_link_clicked;
  const groupMembersJoined = counts.group_member_joined_from_share;
  const rsvpsSubmitted = counts.rsvp_submitted_from_share;

  const clickThroughRate = shareLinksCreated > 0 ? (shareLinksClicked / shareLinksCreated) * 100 : 0;
  const conversionRate = shareLinksClicked > 0 ? (rsvpsSubmitted / shareLinksClicked) * 100 : 0;

  return {
    shareLinksCreated,
    shareLinksClicked,
    clickThroughRate,
    groupMembersJoined,
    rsvpsSubmitted,
    conversionRate
  };
}

function printEventCounts(counts: EventCounts): void {
  console.log('\n📈 Event Counts (Last 24 Hours):');
  console.log('=====================================');
  console.log(`Share Links Created:     ${counts.share_link_created}`);
  console.log(`Share Links Clicked:     ${counts.share_link_clicked}`);
  console.log(`Group Members Joined:    ${counts.group_member_joined_from_share}`);
  console.log(`RSVPs Submitted:         ${counts.rsvp_submitted_from_share}`);
  console.log(`Guest Tokens Created:    ${counts.guest_token_created}`);
  console.log(`Guest Tokens Validated:  ${counts.guest_token_validated}`);
  console.log(`Rate Limit Hits:         ${counts.rate_limit_hit}`);
  console.log(`Public Pages Viewed:     ${counts.public_meeting_page_viewed}`);
}

function printConversionFunnel(funnel: ConversionFunnel): void {
  console.log('\n🔄 Conversion Funnel:');
  console.log('======================');
  console.log(`Share Links Created:     ${funnel.shareLinksCreated}`);
  console.log(`Share Links Clicked:     ${funnel.shareLinksClicked}`);
  console.log(`Click-Through Rate:      ${funnel.clickThroughRate.toFixed(2)}%`);
  console.log(`Group Members Joined:    ${funnel.groupMembersJoined}`);
  console.log(`RSVPs Submitted:         ${funnel.rsvpsSubmitted}`);
  console.log(`Conversion Rate:         ${funnel.conversionRate.toFixed(2)}%`);
}

function validateEvents(counts: EventCounts): boolean {
  const issues: string[] = [];
  
  // Check for zero events (potential issue)
  if (counts.share_link_created === 0) {
    issues.push('❌ No share links created in last 24 hours');
  }
  
  if (counts.share_link_clicked === 0) {
    issues.push('❌ No share links clicked in last 24 hours');
  }
  
  if (counts.public_meeting_page_viewed === 0) {
    issues.push('❌ No public meeting pages viewed in last 24 hours');
  }
  
  // Check for unusual patterns
  if (counts.rate_limit_hit > counts.share_link_created * 0.1) {
    issues.push('⚠️ High rate of rate limit hits (>10% of share link creations)');
  }
  
  if (counts.guest_token_validated === 0 && counts.guest_token_created > 0) {
    issues.push('⚠️ Guest tokens created but none validated');
  }
  
  if (issues.length > 0) {
    console.log('\n🚨 Issues Found:');
    issues.forEach(issue => console.log(issue));
    return false;
  }
  
  return true;
}

async function main(): Promise<void> {
  console.log('🔍 Share-in-Groups Telemetry Verification');
  console.log('==========================================');
  
  try {
    // Get analytics events from last 24 hours
    const events = await getAnalyticsEvents(24);
    
    if (events.length === 0) {
      console.log('\n❌ No analytics events found in the last 24 hours');
      console.log('This may indicate:');
      console.log('- Analytics not properly configured');
      console.log('- No user activity');
      console.log('- Database connection issues');
      process.exit(1);
    }
    
    console.log(`✅ Found ${events.length} analytics events`);
    
    // Count events by type
    const counts = countEvents(events);
    printEventCounts(counts);
    
    // Calculate conversion funnel
    const funnel = calculateConversionFunnel(counts);
    printConversionFunnel(funnel);
    
    // Validate events
    const isValid = validateEvents(counts);
    
    if (isValid) {
      console.log('\n✅ Telemetry verification passed');
      console.log('All required events are firing correctly');
      process.exit(0);
    } else {
      console.log('\n❌ Telemetry verification failed');
      console.log('Please investigate the issues above');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('\n💥 Error during telemetry verification:', error);
    process.exit(1);
  }
}

// Run the script
if (require.main === module) {
  main();
}

export { main, getAnalyticsEvents, countEvents, calculateConversionFunnel, validateEvents };


