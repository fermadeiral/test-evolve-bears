import sys
import subprocess
import json

branch = sys.argv[1]

# check out new created branch
cmd = "git checkout -qf %s;" % branch
subprocess.call(cmd, shell=True)

# read bears.json
with open('bears.json', 'r') as f:
    data = json.load(f)

# add into bears.json the property { "version": "latest" }
data['version'] = "latest"

# write bears.json
with open('bears.json', 'w') as f:
    f.write(json.dumps(data, indent=2))

# update branch
cmd = "git add bears.json; git commit --amend --no-edit; git push -f github;"
subprocess.call(cmd, shell=True)
