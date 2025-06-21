import os
import subprocess
import shutil

ARB_DIR = 'lib/l10n'
TEST_DIR = 'lib/l10n/test'
REFERENCE_FILE = os.path.join(ARB_DIR, 'app_en.arb')

# Create test directory
os.makedirs(TEST_DIR, exist_ok=True)

# Start with just English
shutil.copy(REFERENCE_FILE, os.path.join(TEST_DIR, 'app_en.arb'))

# Get all ARB files except English
arb_files = [f for f in os.listdir(ARB_DIR) if f.endswith('.arb') and f != 'app_en.arb']

print("Testing ARB files systematically...")
print(f"Found {len(arb_files)} ARB files to test")

# Test each file individually
problematic_files = []
working_files = []

for arb_file in arb_files:
    print(f"\nTesting {arb_file}...")
    
    # Copy the file to test directory
    shutil.copy(os.path.join(ARB_DIR, arb_file), os.path.join(TEST_DIR, arb_file))
    
    # Try to generate l10n
    try:
        result = subprocess.run(['flutter', 'gen-l10n'], 
                              capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            print(f"✅ {arb_file} - OK")
            working_files.append(arb_file)
        else:
            print(f"❌ {arb_file} - FAILED")
            problematic_files.append(arb_file)
    except subprocess.TimeoutExpired:
        print(f"⏰ {arb_file} - TIMEOUT")
        problematic_files.append(arb_file)
    except Exception as e:
        print(f"💥 {arb_file} - ERROR: {e}")
        problematic_files.append(arb_file)

print(f"\n=== RESULTS ===")
print(f"Working files: {len(working_files)}")
print(f"Problematic files: {len(problematic_files)}")

if problematic_files:
    print(f"\nProblematic files:")
    for f in problematic_files:
        print(f"  - {f}")

# Clean up test directory
shutil.rmtree(TEST_DIR) 