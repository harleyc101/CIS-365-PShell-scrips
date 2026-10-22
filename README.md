# Ensure custom banned passwords lists are used (Automated)

**Benchmark:** CIS Microsoft 365 Foundations Benchmark v7.0.0, recommendation 5.2.3.2  
**Profile:** E3 Level 1, E5 Level 1  
**Script:** [`Ensure custom banned passwords lists are used (Automated).ps1`](./Ensure%20custom%20banned%20passwords%20lists%20are%20used%20(Automated).ps1)

## Why this is required

When choosing a password, people often draw on what's around them: the company name, products, office location or internal jargon, for example `Contoso2025!` or `Widget@London1`. Attackers know this and use **mangler** tools to generate thousands of variations of organisation-specific words for password spraying and hash cracking.

Microsoft's global banned password list covers common weak passwords, but it knows nothing about **your** organisation. A custom banned list of brand names, product names, locations and internal terms blocks these predictable choices when users change or reset their passwords.

## What the script does

1. Gets the Entra ID **Password Rule Settings** directory setting (template `5cf42378-d67d-4f36-ba46-e8b86229381d`).
2. Shows its values, including `EnableBannedPasswordCheck` and `BannedPasswordList`.

## Prerequisites

- The [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/installation):
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```
- A connected session with the permissions the check needs:
  ```powershell
  Connect-MgGraph -Scopes "Directory.Read.All"
  ```

## Usage

```powershell
& ".\Ensure custom banned passwords lists are used (Automated).ps1"
```

## Interpreting the results

| Output | Result |
| --- | --- |
| `EnableBannedPasswordCheck` is `True` **and** `BannedPasswordList` contains organisation-specific entries | **Pass.** |
| `EnableBannedPasswordCheck` is `False`, `BannedPasswordList` is empty, or there's no output | **Fail.** |

## Remediation

In the Entra admin center, go to **Entra ID > Authentication methods > Password protection**, set **Enforce custom list** to **Yes**, and add terms to **Custom banned password list**. Good candidates:
- brand and product names
- locations such as head office cities
- company-specific internal terms and abbreviations
- months and weekdays in your local languages

Avoid very short or very common dictionary words, which can block perfectly strong passwords.

## Default value

The custom banned password list is not enforced.

## Notes and limitations

- Entra ID scores passwords against the combined global and custom lists. A password containing a banned term can still be accepted if the rest of it is strong enough.

## References

- https://learn.microsoft.com/en-us/entra/identity/authentication/concept-password-ban-bad#custom-banned-password-list
- https://learn.microsoft.com/en-us/entra/identity/authentication/tutorial-configure-custom-password-protection
