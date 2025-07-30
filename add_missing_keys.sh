#!/bin/bash

# Script to add missing localization keys to all ARB files
# This adds the new keys that were added to app_en.arb

# List of new keys to add (in the order they appear in app_en.arb)
NEW_KEYS=(
  "checkingPermissions"
  "cancel"
  "close"
  "save"
  "sendNow"
  "details"
  "adminBroadcast"
  "composeBroadcastMessage"
  "noBroadcastMessages"
  "errorCheckingPermissions"
  "mediaOptional"
  "pickImage"
  "pickVideo"
  "pollOptions"
  "targetingFilters"
  "scheduling"
  "scheduleForLater"
  "errorEstimatingRecipients"
  "errorPickingImage"
  "errorPickingVideo"
  "noPermissionForBroadcast"
  "messageSavedSuccessfully"
  "errorSavingMessage"
  "messageSentSuccessfully"
  "errorSendingMessage"
  "content"
  "type"
  "link"
  "status"
  "recipients"
  "opened"
  "clicked"
  "created"
  "scheduled"
  "organizations"
  "noOrganizations"
  "errorLoadingOrganizations"
  "members"
  "users"
  "noUsers"
  "errorLoadingUsers"
  "changeRole"
  "totalAppointments"
  "completedAppointments"
  "revenue"
  "errorLoadingStats"
  "appointment"
  "from"
  "phone"
  "noRouteDefined"
  "meetingDetails"
  "meetingId"
  "creator"
  "context"
  "group"
  "requestPrivateSession"
  "privacyRequestSent"
  "failedToSendPrivacyRequest"
  "errorLoadingPrivacyRequests"
  "requestType"
  "statusColon"
  "failedToActionPrivacyRequest"
  "yes"
)

# Function to add keys to a specific language file
add_keys_to_file() {
  local file=$1
  local locale=$2
  
  echo "Processing $file..."
  
  # Remove the closing brace
  sed -i '' '$d' "$file"
  
  # Add each new key with appropriate translation
  for key in "${NEW_KEYS[@]}"; do
    case $locale in
      "ar")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "da")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "es")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "fi")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "fr")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "he")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "hu")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "it")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "ja")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "ko")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "nl")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "no")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "pl")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "pt")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "ru")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "sv")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "tr")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "vi")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      "zh")
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
      *)
        echo "  \"$key\": \"$key (TRANSLATE)\"," >> "$file"
        echo "  \"@$key\": { \"description\": \"$key description\" }," >> "$file"
        ;;
    esac
  done
  
  # Add the closing brace back
  echo "}" >> "$file"
}

# Process all ARB files except English and German (already updated)
for file in lib/l10n/app_*.arb; do
  if [[ "$file" != "lib/l10n/app_en.arb" && "$file" != "lib/l10n/app_de.arb" ]]; then
    # Extract locale from filename
    locale=$(basename "$file" .arb | sed 's/app_//')
    add_keys_to_file "$file" "$locale"
  fi
done

echo "Done adding missing keys to all ARB files!" 