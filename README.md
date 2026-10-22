# CIS-365-PShell-scrips

PowerShell scripts for auditing a Microsoft 365 tenant against the **CIS Microsoft 365 Foundations Benchmark v7.0.0**.

Each control lives on its own branch. The branch's README explains why the control is required, what the script does, the prerequisites, how to read the results, and how to fix a failure.

105 controls are covered: every recommendation in the benchmark that includes a PowerShell audit procedure. Recommendations that can only be audited in the admin portals or through the Graph REST API are not included.


## 1. Microsoft 365 admin center

| # | Control | Branch |
| --- | --- | --- |
| 1.1.1 | Ensure Administrative accounts are cloud-only (Automated) | [`ensure-admin-accounts-cloud-only`](../../tree/ensure-admin-accounts-cloud-only) |
| 1.1.3 | Ensure that between two and four global admins are designated (Automated) | [`1.1.3-global-admin-count`](../../tree/1.1.3-global-admin-count) |
| 1.1.4 | Ensure administrative accounts use licenses with a reduced application footprint (Automated) | [`1.1.4-admin-reduced-license-footprint`](../../tree/1.1.4-admin-reduced-license-footprint) |
| 1.2.1 | Ensure that only organizationally managed/approved public groups exist (Automated) | [`1.2.1-public-groups-approved`](../../tree/1.2.1-public-groups-approved) |
| 1.2.2 | Ensure sign-in to shared mailboxes is blocked (Automated) | [`1.2.2-shared-mailbox-signin-blocked`](../../tree/1.2.2-shared-mailbox-signin-blocked) |
| 1.3.1 | Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)' (Automated) | [`1.3.1-password-never-expire`](../../tree/1.3.1-password-never-expire) |
| 1.3.2 | Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices (Automated) | [`1.3.2-idle-session-timeout`](../../tree/1.3.2-idle-session-timeout) |
| 1.3.3 | Ensure 'External sharing' of calendars is not available (Automated) | [`1.3.3-external-calendar-sharing`](../../tree/1.3.3-external-calendar-sharing) |
| 1.3.4 | Ensure 'User owned apps and services' is restricted (Automated) | [`1.3.4-user-owned-apps-restricted`](../../tree/1.3.4-user-owned-apps-restricted) |
| 1.3.5 | Ensure internal phishing protection for Forms is enabled (Automated) | [`1.3.5-forms-phishing-protection`](../../tree/1.3.5-forms-phishing-protection) |
| 1.3.6 | Ensure the customer lockbox feature is enabled (Automated) | [`1.3.6-customer-lockbox`](../../tree/1.3.6-customer-lockbox) |
| 1.3.7 | Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web' (Automated) | [`1.3.7-third-party-storage-restricted`](../../tree/1.3.7-third-party-storage-restricted) |
| 1.3.9 | Ensure shared bookings pages are restricted to select users (Automated) | [`1.3.9-shared-bookings-restricted`](../../tree/1.3.9-shared-bookings-restricted) |

## 2. Microsoft Defender

| # | Control | Branch |
| --- | --- | --- |
| 2.1.1 | Ensure Safe Links for Office Applications is Enabled (Automated) | [`2.1.1-safe-links-office-apps`](../../tree/2.1.1-safe-links-office-apps) |
| 2.1.2 | Ensure the Common Attachment Types Filter is enabled (Automated) | [`2.1.2-common-attachment-filter`](../../tree/2.1.2-common-attachment-filter) |
| 2.1.3 | Ensure notifications for internal users sending malware is Enabled (Automated) | [`2.1.3-internal-malware-notifications`](../../tree/2.1.3-internal-malware-notifications) |
| 2.1.4 | Ensure Safe Attachments policy is enabled (Automated) | [`2.1.4-safe-attachments-policy`](../../tree/2.1.4-safe-attachments-policy) |
| 2.1.5 | Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled (Automated) | [`2.1.5-safe-attachments-spo-odb-teams`](../../tree/2.1.5-safe-attachments-spo-odb-teams) |
| 2.1.6 | Ensure Exchange Online Spam Policies are set to notify administrators (Automated) | [`2.1.6-spam-policy-notify-admins`](../../tree/2.1.6-spam-policy-notify-admins) |
| 2.1.7 | Ensure that an anti-phishing policy has been created (Automated) | [`2.1.7-anti-phishing-policy`](../../tree/2.1.7-anti-phishing-policy) |
| 2.1.8 | Ensure that SPF records are published for all Exchange Domains (Automated) | [`2.1.8-spf-records-published`](../../tree/2.1.8-spf-records-published) |
| 2.1.9 | Ensure that DKIM is enabled for all Exchange Online Domains (Automated) | [`2.1.9-dkim-enabled`](../../tree/2.1.9-dkim-enabled) |
| 2.1.10 | Ensure DMARC records for all Exchange Online domains are published (Automated) | [`2.1.10-dmarc-records-published`](../../tree/2.1.10-dmarc-records-published) |
| 2.1.11 | Ensure comprehensive attachment filtering is applied (Automated) | [`2.1.11-comprehensive-attachment-filtering`](../../tree/2.1.11-comprehensive-attachment-filtering) |
| 2.1.12 | Ensure the connection filter IP allow list is not used (Automated) | [`2.1.12-connection-filter-ip-allow-list`](../../tree/2.1.12-connection-filter-ip-allow-list) |
| 2.1.13 | Ensure the connection filter safe list is off (Automated) | [`2.1.13-connection-filter-safe-list-off`](../../tree/2.1.13-connection-filter-safe-list-off) |
| 2.1.14 | Ensure inbound anti-spam policies do not contain allowed domains (Automated) | [`2.1.14-anti-spam-no-allowed-domains`](../../tree/2.1.14-anti-spam-no-allowed-domains) |
| 2.1.15 | Ensure outbound anti-spam message limits are in place (Automated) | [`2.1.15-outbound-spam-limits`](../../tree/2.1.15-outbound-spam-limits) |
| 2.4.1 | Ensure Priority account protection is enabled and configured (Automated) | [`2.4.1-priority-account-protection`](../../tree/2.4.1-priority-account-protection) |
| 2.4.2 | Ensure Priority accounts have 'Strict protection' presets applied (Automated) | [`2.4.2-priority-accounts-strict-preset`](../../tree/2.4.2-priority-accounts-strict-preset) |
| 2.4.4 | Ensure Zero-hour auto purge for Microsoft Teams is on (Automated) | [`2.4.4-teams-zero-hour-auto-purge`](../../tree/2.4.4-teams-zero-hour-auto-purge) |

## 3. Microsoft Purview

| # | Control | Branch |
| --- | --- | --- |
| 3.1.1 | Ensure Microsoft 365 audit log search is Enabled (Automated) | [`3.1.1-audit-log-search-enabled`](../../tree/3.1.1-audit-log-search-enabled) |
| 3.2.1 | Ensure DLP policies are enabled (Automated) | [`3.2.1-dlp-policies-enabled`](../../tree/3.2.1-dlp-policies-enabled) |
| 3.2.2 | Ensure DLP policies are enabled for Microsoft Teams (Automated) | [`3.2.2-dlp-teams`](../../tree/3.2.2-dlp-teams) |
| 3.2.3 | Ensure DLP policies are published for Copilot users (Automated) | [`3.2.3-dlp-copilot`](../../tree/3.2.3-dlp-copilot) |
| 3.3.1 | Ensure Information Protection sensitivity label policies are published (Automated) | [`3.3.1-sensitivity-label-policies`](../../tree/3.3.1-sensitivity-label-policies) |

## 5. Microsoft Entra admin center

| # | Control | Branch |
| --- | --- | --- |
| 5.1.2.2 | Ensure users cannot register applications (Automated) | [`5.1.2.2-users-cannot-register-apps`](../../tree/5.1.2.2-users-cannot-register-apps) |
| 5.1.2.3 | Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' (Automated) | [`5.1.2.3-restrict-tenant-creation`](../../tree/5.1.2.3-restrict-tenant-creation) |
| 5.1.3.1 | Ensure users cannot create security groups (Automated) | [`5.1.3.1-users-cannot-create-security-groups`](../../tree/5.1.3.1-users-cannot-create-security-groups) |
| 5.1.4.6 | Ensure users are restricted from recovering BitLocker keys (Automated) | [`5.1.4.6-restrict-bitlocker-key-recovery`](../../tree/5.1.4.6-restrict-bitlocker-key-recovery) |
| 5.1.5.1 | Ensure user consent to apps accessing company data on their behalf is not allowed (Automated) | [`5.1.5.1-user-consent-not-allowed`](../../tree/5.1.5.1-user-consent-not-allowed) |
| 5.1.5.2 | Ensure the admin consent workflow is enabled (Automated) | [`5.1.5.2-admin-consent-workflow`](../../tree/5.1.5.2-admin-consent-workflow) |
| 5.1.6.1 | Ensure that collaboration invitations are sent to allowed domains only (Automated) | [`5.1.6.1-b2b-invites-allowed-domains-only`](../../tree/5.1.6.1-b2b-invites-allowed-domains-only) |
| 5.1.6.2 | Ensure that guest user access is restricted (Automated) | [`5.1.6.2-guest-user-access-restricted`](../../tree/5.1.6.2-guest-user-access-restricted) |
| 5.1.6.3 | Ensure guest user invitations are limited (Automated) | [`5.1.6.3-guest-invitations-limited`](../../tree/5.1.6.3-guest-invitations-limited) |
| 5.1.8.1 | Ensure that password hash sync is enabled for hybrid deployments (Automated) | [`5.1.8.1-password-hash-sync-hybrid`](../../tree/5.1.8.1-password-hash-sync-hybrid) |
| 5.2.3.2 | Ensure custom banned passwords lists are used (Automated) | [`5.2.3.2-custom-banned-passwords`](../../tree/5.2.3.2-custom-banned-passwords) |
| 5.2.3.3 | Ensure password protection is enabled for on-prem Active Directory (Automated) | [`5.2.3.3-password-protection-on-prem-ad`](../../tree/5.2.3.3-password-protection-on-prem-ad) |
| 5.2.3.4 | Ensure all member users are 'MFA capable' (Automated) | [`5.2.3.4-all-members-mfa-capable`](../../tree/5.2.3.4-all-members-mfa-capable) |
| 5.2.3.5 | Ensure weak authentication methods are disabled (Automated) | [`5.2.3.5-weak-auth-methods-disabled`](../../tree/5.2.3.5-weak-auth-methods-disabled) |
| 5.2.3.6 | Ensure system-preferred multifactor authentication is enabled (Automated) | [`5.2.3.6-system-preferred-mfa`](../../tree/5.2.3.6-system-preferred-mfa) |
| 5.2.3.7 | Ensure the email OTP authentication method is disabled (Automated) | [`5.2.3.7-email-otp-disabled`](../../tree/5.2.3.7-email-otp-disabled) |

## 6. Exchange admin center

| # | Control | Branch |
| --- | --- | --- |
| 6.1.1 | Ensure 'AuditDisabled' organizationally is set to 'False' (Automated) | [`6.1.1-org-audit-not-disabled`](../../tree/6.1.1-org-audit-not-disabled) |
| 6.1.2 | Ensure mailbox audit actions are configured (Automated) | [`6.1.2-mailbox-audit-actions`](../../tree/6.1.2-mailbox-audit-actions) |
| 6.1.3 | Ensure 'AuditBypassEnabled' is not enabled on mailboxes (Automated) | [`6.1.3-audit-bypass-not-enabled`](../../tree/6.1.3-audit-bypass-not-enabled) |
| 6.2.1 | Ensure all forms of mail forwarding are blocked and/or disabled (Automated) | [`6.2.1-mail-forwarding-blocked`](../../tree/6.2.1-mail-forwarding-blocked) |
| 6.2.2 | Ensure mail transport rules do not whitelist specific domains (Automated) | [`6.2.2-transport-rules-no-domain-whitelist`](../../tree/6.2.2-transport-rules-no-domain-whitelist) |
| 6.2.3 | Ensure email from external senders is identified (Automated) | [`6.2.3-external-sender-identified`](../../tree/6.2.3-external-sender-identified) |
| 6.3.1 | Ensure users installing Outlook add-ins is not allowed (Automated) | [`6.3.1-outlook-addins-not-allowed`](../../tree/6.3.1-outlook-addins-not-allowed) |
| 6.3.2 | Ensure the ability to add personal email accounts and calendars is disabled (Automated) | [`6.3.2-personal-accounts-disabled`](../../tree/6.3.2-personal-accounts-disabled) |
| 6.5.1 | Ensure modern authentication for Exchange Online is enabled (Automated) | [`6.5.1-exo-modern-auth`](../../tree/6.5.1-exo-modern-auth) |
| 6.5.2 | Ensure MailTips are enabled for end users (Automated) | [`6.5.2-mailtips-enabled`](../../tree/6.5.2-mailtips-enabled) |
| 6.5.3 | Ensure additional storage providers are restricted in Outlook on the web (Automated) | [`6.5.3-owa-storage-providers-restricted`](../../tree/6.5.3-owa-storage-providers-restricted) |
| 6.5.4 | Ensure SMTP AUTH is disabled (Automated) | [`6.5.4-smtp-auth-disabled`](../../tree/6.5.4-smtp-auth-disabled) |
| 6.5.5 | Ensure Direct Send submissions are rejected (Automated) | [`6.5.5-reject-direct-send`](../../tree/6.5.5-reject-direct-send) |

## 7. SharePoint admin center

| # | Control | Branch |
| --- | --- | --- |
| 7.2.1 | Ensure modern authentication for SharePoint applications is required (Automated) | [`7.2.1-spo-modern-auth-required`](../../tree/7.2.1-spo-modern-auth-required) |
| 7.2.2 | Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled (Automated) | [`7.2.2-spo-entra-b2b-integration`](../../tree/7.2.2-spo-entra-b2b-integration) |
| 7.2.3 | Ensure external content sharing is restricted (Automated) | [`7.2.3-external-content-sharing-restricted`](../../tree/7.2.3-external-content-sharing-restricted) |
| 7.2.4 | Ensure OneDrive content sharing is restricted (Automated) | [`7.2.4-onedrive-sharing-restricted`](../../tree/7.2.4-onedrive-sharing-restricted) |
| 7.2.5 | Ensure that SharePoint guest users cannot share items they don't own (Automated) | [`7.2.5-guests-cannot-reshare`](../../tree/7.2.5-guests-cannot-reshare) |
| 7.2.6 | Ensure SharePoint external sharing is restricted (Automated) | [`7.2.6-spo-sharing-allowed-domains`](../../tree/7.2.6-spo-sharing-allowed-domains) |
| 7.2.7 | Ensure link sharing is restricted in SharePoint and OneDrive (Automated) | [`7.2.7-default-sharing-link-type`](../../tree/7.2.7-default-sharing-link-type) |
| 7.2.8 | Ensure external sharing is restricted by security group (Automated) | [`7.2.8-external-sharing-by-security-group`](../../tree/7.2.8-external-sharing-by-security-group) |
| 7.2.9 | Ensure guest access to a site or OneDrive will expire automatically (Automated) | [`7.2.9-guest-access-expires`](../../tree/7.2.9-guest-access-expires) |
| 7.2.10 | Ensure reauthentication with verification code is restricted (Automated) | [`7.2.10-verification-code-reauth`](../../tree/7.2.10-verification-code-reauth) |
| 7.2.11 | Ensure the SharePoint default sharing link permission is set (Automated) | [`7.2.11-default-link-permission-view`](../../tree/7.2.11-default-link-permission-view) |
| 7.3.1 | Ensure Office 365 SharePoint infected files are disallowed for download (Automated) | [`7.3.1-disallow-infected-file-download`](../../tree/7.3.1-disallow-infected-file-download) |

## 8. Microsoft Teams admin center

| # | Control | Branch |
| --- | --- | --- |
| 8.1.1 | Ensure external file sharing in Teams is enabled for only approved cloud storage services (Automated) | [`8.1.1-teams-approved-cloud-storage`](../../tree/8.1.1-teams-approved-cloud-storage) |
| 8.1.2 | Ensure users can't send emails to a channel email address (Automated) | [`8.1.2-no-email-into-channels`](../../tree/8.1.2-no-email-into-channels) |
| 8.2.1 | Ensure external domains are restricted in the Teams admin center (Automated) | [`8.2.1-teams-external-domains-restricted`](../../tree/8.2.1-teams-external-domains-restricted) |
| 8.2.2 | Ensure communication with unmanaged Teams users is disabled (Automated) | [`8.2.2-teams-unmanaged-users-disabled`](../../tree/8.2.2-teams-unmanaged-users-disabled) |
| 8.2.3 | Ensure external Teams users cannot initiate conversations (Automated) | [`8.2.3-teams-external-cannot-initiate`](../../tree/8.2.3-teams-external-cannot-initiate) |
| 8.2.4 | Ensure the organization cannot communicate with accounts in trial Teams tenants (Automated) | [`8.2.4-teams-trial-tenants-blocked`](../../tree/8.2.4-teams-trial-tenants-blocked) |
| 8.5.1 | Ensure anonymous users can't join a meeting (Automated) | [`8.5.1-anonymous-cannot-join-meetings`](../../tree/8.5.1-anonymous-cannot-join-meetings) |
| 8.5.2 | Ensure anonymous users and dial-in callers can't start a meeting (Automated) | [`8.5.2-anonymous-cannot-start-meetings`](../../tree/8.5.2-anonymous-cannot-start-meetings) |
| 8.5.3 | Ensure only people in my org can bypass the lobby (Automated) | [`8.5.3-lobby-bypass-org-only`](../../tree/8.5.3-lobby-bypass-org-only) |
| 8.5.4 | Ensure users dialing in can't bypass the lobby (Automated) | [`8.5.4-dial-in-cannot-bypass-lobby`](../../tree/8.5.4-dial-in-cannot-bypass-lobby) |
| 8.5.5 | Ensure meeting chat does not allow anonymous users (Automated) | [`8.5.5-meeting-chat-no-anonymous`](../../tree/8.5.5-meeting-chat-no-anonymous) |
| 8.5.6 | Ensure only organizers and co-organizers can present (Automated) | [`8.5.6-only-organizers-present`](../../tree/8.5.6-only-organizers-present) |
| 8.5.7 | Ensure external participants can't give or request control (Automated) | [`8.5.7-external-no-give-request-control`](../../tree/8.5.7-external-no-give-request-control) |
| 8.5.8 | Ensure external meeting chat is off (Automated) | [`8.5.8-external-meeting-chat-off`](../../tree/8.5.8-external-meeting-chat-off) |
| 8.5.9 | Ensure meeting recording is off by default (Automated) | [`8.5.9-meeting-recording-off-default`](../../tree/8.5.9-meeting-recording-off-default) |
| 8.6.1 | Ensure users can report security concerns in Teams (Automated) | [`8.6.1-teams-report-security-concerns`](../../tree/8.6.1-teams-report-security-concerns) |

## 9. Microsoft Fabric

| # | Control | Branch |
| --- | --- | --- |
| 9.1.1 | Ensure guest user access is restricted (Automated) | [`9.1.1-fabric-guest-access-restricted`](../../tree/9.1.1-fabric-guest-access-restricted) |
| 9.1.2 | Ensure external user invitations are restricted (Automated) | [`9.1.2-fabric-external-invites-restricted`](../../tree/9.1.2-fabric-external-invites-restricted) |
| 9.1.3 | Ensure guest access to content is restricted (Automated) | [`9.1.3-fabric-guest-content-restricted`](../../tree/9.1.3-fabric-guest-content-restricted) |
| 9.1.4 | Ensure 'Publish to web' is restricted (Automated) | [`9.1.4-fabric-publish-to-web-restricted`](../../tree/9.1.4-fabric-publish-to-web-restricted) |
| 9.1.5 | Ensure 'Interact with and share R and Python' visuals is 'Disabled' (Automated) | [`9.1.5-fabric-r-python-visuals-disabled`](../../tree/9.1.5-fabric-r-python-visuals-disabled) |
| 9.1.6 | Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled' (Automated) | [`9.1.6-fabric-sensitivity-labels-enabled`](../../tree/9.1.6-fabric-sensitivity-labels-enabled) |
| 9.1.7 | Ensure shareable links are restricted (Automated) | [`9.1.7-fabric-shareable-links-restricted`](../../tree/9.1.7-fabric-shareable-links-restricted) |
| 9.1.8 | Ensure enabling of external data sharing is restricted (Automated) | [`9.1.8-fabric-external-data-sharing-restricted`](../../tree/9.1.8-fabric-external-data-sharing-restricted) |
| 9.1.9 | Ensure 'Block ResourceKey Authentication' is 'Enabled' (Automated) | [`9.1.9-fabric-block-resourcekey-auth`](../../tree/9.1.9-fabric-block-resourcekey-auth) |
| 9.1.10 | Ensure access to APIs by service principals is restricted (Automated) | [`9.1.10-fabric-sp-api-access-restricted`](../../tree/9.1.10-fabric-sp-api-access-restricted) |
| 9.1.11 | Ensure service principals cannot create and use profiles (Automated) | [`9.1.11-fabric-sp-profiles-restricted`](../../tree/9.1.11-fabric-sp-profiles-restricted) |
| 9.1.12 | Ensure service principals ability to create workspaces, connections and deployment pipelines is restricted (Automated) | [`9.1.12-fabric-sp-global-apis-restricted`](../../tree/9.1.12-fabric-sp-global-apis-restricted) |
