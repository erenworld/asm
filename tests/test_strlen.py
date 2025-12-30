import subprocess

res = subprocess.run(["./test_strlen"])
assert res.returncode == 5
