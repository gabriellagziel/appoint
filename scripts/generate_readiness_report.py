#!/usr/bin/env python3
import subprocess
import re
import os
import sys
from datetime import datetime

REPORT_FILE = "readiness_report.md"
LOG_DIR = "readiness_logs"

# Ensure log directory exists
os.makedirs(LOG_DIR, exist_ok=True)

def run_cmd(name, cmd, cwd=None, parse_test_output=False):
    """Run a shell command and capture its exit code & output."""
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            check=False,
        )
        exit_code = result.returncode
        output = result.stdout
    except FileNotFoundError:
        exit_code = 127
        output = f"Command not found: {cmd[0]}\n"
    # Save output to log file for debugging
    log_path = os.path.join(LOG_DIR, f"{name.replace(' ', '_').lower()}.log")
    with open(log_path, "w") as log_file:
        log_file.write(output)
    # Determine status
    status = "PASS" if exit_code == 0 else "FAIL"
    tests_passed = None
    if parse_test_output:
        # Try to extract "+<num>" passed pattern (flutter) or jest summary
        match = re.search(r"\+(\d+).*Some tests failed", output)
        if not match:
            match = re.search(r"\+(\d+).*All tests passed", output)
        if not match:
            # Jest summary like "Tests:       10 passed"
            match = re.search(r"Tests:\s+(\d+) passed", output)
        if match:
            tests_passed = int(match.group(1))
    return status, tests_passed

# -------------------------------
# Execute all checks
# -------------------------------
results = {}
counts = {}

print("Running readiness checks – this may take a while…\n")

# 1. Flutter section
results["Flutter analyze"], _ = run_cmd("flutter_analyze", ["flutter", "analyze"])
results["Flutter tests"], counts["Flutter tests"] = run_cmd(
    "flutter_tests", ["flutter", "test"], parse_test_output=True
)
results["Flutter build APK"], _ = run_cmd(
    "flutter_build_apk", ["flutter", "build", "apk", "--release"]
)
results["Flutter build Web"], _ = run_cmd(
    "flutter_build_web", ["flutter", "build", "web", "--release"]
)

# 2. Website section – assume project located in ./website
# If directory is missing, commands will fail gracefully.
website_dir = "website"
results["Website lint"], _ = run_cmd("website_lint", ["npm", "run", "lint"], cwd=website_dir)
results["Website tests"], counts["Website tests"] = run_cmd(
    "website_tests", ["npm", "run", "test", "--", "--ci"], cwd=website_dir, parse_test_output=True
)
results["Website build"], _ = run_cmd("website_build", ["npm", "run", "build"], cwd=website_dir)

# Website health check – run only if build passed and server can start
health_status = "FAIL"
if results["Website build"] == "PASS":
    try:
        # Start server in background on custom port
        port = os.environ.get("PORT", "3000")
        server = subprocess.Popen(["npm", "start"], cwd=website_dir, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # Give server time to boot
        import time
        time.sleep(10)
        health = subprocess.run(["curl", "-sf", f"http://localhost:{port}/healthz"], text=True)
        health_status = "PASS" if health.returncode == 0 else "FAIL"
    finally:
        try:
            server.terminate()
        except Exception:
            pass
else:
    health_status = "FAIL"
results["Website health check"] = health_status

# -------------------------------
# Generate Markdown report
# -------------------------------

lines = ["# Readiness Report", "", f"_Generated: {datetime.utcnow().isoformat()} UTC_", ""]

def format_line(key):
    status = results.get(key, "FAIL")
    line = f"- **{key}:** {status}"
    if "tests" in key.lower() and key in counts and counts[key] is not None:
        line += f" ({counts[key]} tests passed)"
    return line + "  "

ordered_keys = [
    "Flutter analyze",
    "Flutter tests",
    "Flutter build APK",
    "Flutter build Web",
    "Website lint",
    "Website tests",
    "Website build",
    "Website health check",
]

for k in ordered_keys:
    lines.append(format_line(k))

all_passed = all(status == "PASS" for status in results.values())

if all_passed:
    lines.append("\n🎉 **All readiness checks passed – ready for deployment!** 🎉")
else:
    lines.append("\n⚠️ **One or more checks failed. Please review the logs.**")

# Write to file
with open(REPORT_FILE, "w") as f:
    f.write("\n".join(lines))

# Print to console
print("\n".join(lines))

# Exit code
sys.exit(0 if all_passed else 1)