#!/usr/bin/env python3
"""
Script to add missing translation keys to all ARB files.
"""

import json
import os
import glob

# Define the missing keys with their English translations
missing_translations = {
    "welcomeAmbassador": "Welcome Ambassador",
    "activeStatus": "Active Status", 
    "totalReferrals": "Total Referrals",
    "thisMonth": "This Month",
    "activeRewards": "Active Rewards",
    "nextTierProgress": "Next Tier Progress",
    "progressToPremium": "Progress to Premium",
    "remaining": "Remaining",
    "monthlyGoal": "Monthly Goal",
    "onTrack": "On Track",
    "needsAttention": "Needs Attention", 
    "monthlyReferralRequirement": "Monthly Referral Requirement",
    "viewRewards": "View Rewards",
    "referralStatistics": "Referral Statistics",
    "activeReferrals": "Active Referrals",
    "conversionRate": "Conversion Rate",
    "recentReferrals": "Recent Referrals", 
    "tierBenefits": "Tier Benefits",
    "yourReferralQRCode": "Your Referral QR Code",
    "yourReferralLink": "Your Referral Link",
    "shareYourLink": "Share Your Link",
    "shareViaMessage": "Share via Message",
    "shareViaEmail": "Share via Email",
    "shareMore": "Share More",
    "becomeAmbassador": "Become Ambassador",
    "ambassadorEligible": "Ambassador Eligible",
    "ambassadorWelcomeTitle": "Ambassador Welcome Title",
    "ambassadorWelcomeMessage": "Ambassador Welcome Message",
    "title": "Title",
    "pleaseEnterTitle": "Please Enter Title",
    "messageType": "Message Type",
    "pleaseEnterContent": "Please Enter Content",
    "imageSelected": "Image Selected",
    "videoSelected": "Video Selected",
    "externalLink": "External Link",
    "pleaseEnterLink": "Please Enter Link",
    "estimatedRecipients": "Estimated Recipients",
    "countries": "Countries",
    "cities": "Cities",
    "subscriptionTiers": "Subscription Tiers",
    "userRoles": "User Roles",
    "errorEstimatingRecipients": "Error Estimating Recipients",
    "errorPickingImage": "Error Picking Image",
    "errorPickingVideo": "Error Picking Video",
    "userNotAuthenticated": "User Not Authenticated",
    "failedToUploadImage": "Failed to Upload Image",
    "failedToUploadVideo": "Failed to Upload Video",
    "image": "Image",
    "video": "Video",
    "continue1": "Continue",
    "getStarted": "Get Started"
}

# Load untranslated messages to get the list of missing keys
with open('untranslated_messages.json', 'r') as f:
    untranslated_data = json.load(f)

def add_missing_keys_to_arb(arb_file_path):
    """Add missing keys to a specific ARB file."""
    print(f"Processing {arb_file_path}...")
    
    # Read the existing ARB file
    with open(arb_file_path, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Get the locale from the file name
    filename = os.path.basename(arb_file_path)
    locale = filename.replace('app_', '').replace('.arb', '')
    
    # Check if this locale has untranslated keys
    if locale in untranslated_data:
        missing_keys = untranslated_data[locale]
        added_count = 0
        
        for key in missing_keys:
            if key not in arb_data:
                # Add the key with English translation for now
                arb_data[key] = missing_translations.get(key, key)
                # Add description metadata
                arb_data[f"@{key}"] = {
                    "description": f"Translation for {key}"
                }
                added_count += 1
        
        if added_count > 0:
            # Write back to file with proper formatting
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_data, f, indent=2, ensure_ascii=False)
            print(f"  Added {added_count} missing keys to {locale}")
        else:
            print(f"  No missing keys found for {locale}")
    else:
        print(f"  No untranslated keys reported for {locale}")

def main():
    """Main function to process all ARB files."""
    print("Starting to fix missing translation keys...")
    
    # Find all ARB files in lib/l10n/
    arb_files = glob.glob('lib/l10n/app_*.arb')
    
    if not arb_files:
        print("No ARB files found in lib/l10n/")
        return
    
    print(f"Found {len(arb_files)} ARB files")
    
    for arb_file in sorted(arb_files):
        add_missing_keys_to_arb(arb_file)
    
    print("Completed adding missing translation keys!")

if __name__ == "__main__":
    main()