import sys
import os
import subprocess
import json

branch = sys.argv[1]

cmd = "git checkout -qf master;"
subprocess.call(cmd, shell=True)

with open(os.path.join("releases", "latest_branches.txt"), mode='a') as file:
    file.write(branch + "\n")



versions = None
if os.path.exists(os.path.join("releases", "branches_per_version.json")):
    with open(os.path.join("releases", "branches_per_version.json"),'r') as f:
        try:
            versions = json.load(f)
        except Exception as e:
            print("got %s on json.load()" % e)

if versions is not None:
    versions["latest"].append(branch)

    with open(os.path.join("releases", "branches_per_version.json"),'w') as f:
        f.write(json.dumps(versions, indent=2))

    cmd = "git add -A; git commit --amend --no-edit; git push -f github;"
    subprocess.call(cmd, shell=True)
