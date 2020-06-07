from datetime import datetime
import argparse, os
import zenipy

parser = argparse.ArgumentParser(description='"bash" with "python"', add_help=False)
parser.add_argument('--timer', help='Path to video file.')
args = parser.parse_args()

des = int(datetime.timestamp(datetime.now()))+int(args.timer)
print("des timestamp=", des)

while (True):
    if( int(datetime.timestamp(datetime.now())) < des ):
        pass
    else:
        if(zenipy.zenipy.question(title='Babysitting REPEAT?', text='Colab kernel is about to timeout.', width=330, height=120, timeout=None)):
            print('repeat')
            des = int(datetime.timestamp(datetime.now())) + int(args.timer)   
        else:
            print('break')
            break
            