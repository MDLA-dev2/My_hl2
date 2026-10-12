import os
import sys
import json
import subprocess

TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
CREDS_FILE = os.path.join(TOOLS_DIR, "deploy_credentials.json")
ASKPASS_BAT = os.path.join(TOOLS_DIR, "askpass.bat")

with open(CREDS_FILE, "r", encoding="utf-8") as f:
    creds = json.load(f)

# Collect all files in local oasis_rp
LOCAL_ROOT = os.path.abspath(os.path.join(TOOLS_DIR, "..", "garrysmod", "gamemodes", "oasis_rp"))
REMOTE_ROOT = "garrysmod/gamemodes/oasis_rp"

dirs_to_create = set()
files_to_upload = []

for root, dirs, files in os.walk(LOCAL_ROOT):
    rel_path = os.path.relpath(root, LOCAL_ROOT)
    if rel_path == ".":
        remote_dir = REMOTE_ROOT
    else:
        remote_dir = f"{REMOTE_ROOT}/{rel_path.replace(os.sep, '/')}"
    
    dirs_to_create.add(remote_dir)
    for file in files:
        local_file = os.path.join(root, file)
        remote_file = f"{remote_dir}/{file}"
        files_to_upload.append((local_file, remote_file))

# Sort dirs by depth
sorted_dirs = sorted(list(dirs_to_create), key=lambda d: d.count('/'))

# Build SFTP commands
commands = []
commands.append("-mkdir garrysmod/gamemodes")
for d in sorted_dirs:
    commands.append(f"-mkdir \"{d}\"")

for local_f, remote_f in files_to_upload:
    local_posix = local_f.replace('\\', '/')
    commands.append(f"put \"{local_posix}\" \"{remote_f}\"")

commands.append("ls -la garrysmod/gamemodes/oasis_rp")
commands.append("bye\n")

input_payload = "\n".join(commands)

print(f"Deploying {len(files_to_upload)} files to {creds['host']}:{creds['port']} via stdin pipe...")

env = os.environ.copy()
env["SSH_ASKPASS_REQUIRE"] = "force"
env["SSH_ASKPASS"] = r"E:\Try1\temp_assets\askpass.bat"

cmd = [
    "C:\\Windows\\System32\\OpenSSH\\sftp.exe",
    "-P", str(creds["port"]),
    "-o", "StrictHostKeyChecking=no",
    f"{creds['username']}@{creds['host']}"
]

res = subprocess.run(cmd, input=input_payload, env=env, capture_output=True, text=True)

print("SFTP OUTPUT:")
for line in res.stdout.splitlines():
    if "Uploading" in line or "oasis_rp" in line or "Connected" in line:
        print("  ", line)

if res.returncode == 0:
    print("\n[SUCCESS] Oasis RP successfully deployed to server!")
else:
    print(f"\n[ERROR] Deployment failed with code {res.returncode}")
    print(res.stderr)
