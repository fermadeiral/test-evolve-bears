import sys
import subprocess
import json

branch = sys.argv[1]

cmd = "git checkout -qf %s;" % branch
subprocess.call(cmd, shell=True)

with open('bears.json', 'r') as f:
    data = json.load(f)

data['version'] = "latest"

with open('bears.json', 'w') as f:
    f.write(json.dumps(data, indent=2))

cmd = "git add bears.json; git commit --amend --no-edit; git push -f github;"
subprocess.call(cmd, shell=True)
