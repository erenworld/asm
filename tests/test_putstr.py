import subprocess

res = subprocess.run(["./test_putstr"], capture_output=True, text=True)

assert res.stdout == "hi\n"
