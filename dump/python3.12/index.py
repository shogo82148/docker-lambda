import os
import sys
import subprocess
import json

def handler(event, context):
    bucket = os.environ['BUCKET']
    subprocess.call(['sh', '-c', f'lambda-dump -bucket {bucket} -key fs/__ARCH__/python3.12.tgz'])

    info = {
        'sys.executable': sys.executable,
        'sys.argv': sys.argv,
        'sys.path': sys.path,
        'os.getcwd': os.getcwd(),
        '__file__': __file__,
        'os.environ': {k: str(v) for k, v in os.environ.items()},
        'context': {k: str(v) for k, v in context.__dict__.items()},
    }

    print(json.dumps(info, indent=2))

    return {}
