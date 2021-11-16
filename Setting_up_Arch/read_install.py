import subprocess
will_install = []
with open("installed.txt","r") as f:
    reader = f.read()
    reader = reader.split("\n")[:-1]
    for r in reader:
        will_install.append(r)

o = subprocess.run(["pacman","-Qq"],capture_output=True)
installed = o.stdout.decode().split("\n")
for s in will_install:
    if s not in installed and "perl" not in s:
        print(s)
