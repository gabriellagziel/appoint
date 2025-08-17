# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for such patches depends on the CVSS v3.0 Rating:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of our applications seriously. If you believe you have found a security vulnerability, please report it to us as described below.

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to [security@gabriellagziel.com](mailto:security@gabriellagziel.com).

You should receive a response within 48 hours. If for some reason you do not, please follow up via email to ensure we received your original message.

Please include the requested information listed below (as much as you can provide) to help us better understand the nature and scope of the possible issue:

- Type of issue (buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the vulnerability
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

This information will help us triage your report more quickly.

## Preferred Languages

We prefer all communications to be in English.

## Policy

We take security seriously and will make every effort to promptly address any vulnerability that is reported to us. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

## Security Features

This repository includes several security features:

- **CodeQL Analysis**: Automated security scanning on every push and pull request
- **Dependabot**: Automated dependency updates to patch known vulnerabilities
- **Secret Scanning**: Detection of accidentally committed secrets
- **Branch Protection**: Required reviews and status checks before merging

## Reporting Security Issues in Dependencies

If you find a security issue in one of our dependencies, please report it to the maintainers of that package. You can also report it to us, and we'll help coordinate with the dependency maintainers.

## Security Updates

We regularly update our dependencies to patch known security vulnerabilities. These updates are automated through Dependabot and require manual review before merging.

## Contact

- **Security Email**: [security@gabriellagziel.com](mailto:security@gabriellagziel.com)
- **GitHub Security Advisories**: [Security Advisories](https://github.com/gabriellagziel/appoint/security/advisories)

---

**Thank you for helping keep our applications secure!**
