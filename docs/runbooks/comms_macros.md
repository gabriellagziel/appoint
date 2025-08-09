# Communication Macros for Incidents

## Slack — Initial (internal)
> Heads up: {{product}} incident ongoing (SEV{{N}}). Impact: {{X}}. Tracking in #incidents-{{date}}. Next update in 15m.

## Status Page — Initial (public)
> We're investigating degraded performance impacting {{feature}}. We'll update within 30 minutes.

## Status Page — Resolved
> This incident has been resolved. Root cause analysis will follow on our blog/status page.

## Customer Email (if needed)
**Subject:** Service Interruption on {{date}}
**Body:** We experienced an interruption affecting {{feature}} between {{start}}–{{end}} UTC. The issue is resolved. We're implementing safeguards to prevent recurrence. We're sorry for the disruption.

## Slack — Update (internal)
> Update: {{product}} incident - {{status}}. Impact: {{X}}. ETA: {{time}}. Next update in 30m.

## Slack — Resolution (internal)
> Resolved: {{product}} incident. Root cause: {{cause}}. Action items: {{items}}. Post-mortem scheduled for {{time}}.

## Status Page — Update
> We're continuing to work on resolving the issue affecting {{feature}}. We expect resolution within {{time}}.

## Executive Summary
> **Incident:** {{brief description}}
> **Impact:** {{affected users/features}}
> **Duration:** {{start}} - {{end}}
> **Root Cause:** {{cause}}
> **Prevention:** {{actions taken}}

## Customer Communication Template
```
Dear {{customer}},

We wanted to inform you about a service interruption that occurred on {{date}}.

**What happened:**
{{brief description}}

**Impact:**
{{specific impact on customer}}

**Resolution:**
{{what was done to fix it}}

**Prevention:**
{{steps taken to prevent recurrence}}

We apologize for any inconvenience this may have caused. If you have any questions, please don't hesitate to contact us.

Best regards,
The AppOint Team
```

## Press Release Template (for major incidents)
```
FOR IMMEDIATE RELEASE

AppOint Experiences Service Interruption

[City, Date] - AppOint today experienced a service interruption affecting {{features}}.

The issue began at {{start time}} and was resolved by {{end time}}. During this time, {{impact description}}.

Our engineering team immediately began investigating and implemented a fix. We have also put in place additional monitoring to prevent similar issues in the future.

We apologize to our users for any inconvenience this may have caused. We are committed to providing reliable service and are taking steps to ensure this doesn't happen again.

For more information, contact: {{contact info}}
```

## Social Media Templates

### Twitter - Initial
> We're aware of issues with {{feature}} and are working to resolve them. We'll provide updates here.

### Twitter - Update
> Update: We're continuing to work on the {{feature}} issue. We expect resolution within {{time}}.

### Twitter - Resolved
> The {{feature}} issue has been resolved. We apologize for the inconvenience and thank you for your patience.

### LinkedIn - Post-Mortem
> We recently experienced a service interruption that affected {{features}}. Here's what happened and what we learned: {{link to blog post}}

