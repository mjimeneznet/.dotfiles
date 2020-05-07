from pyluxafor import LuxaforFlag
from time import sleep
import argparse

def main():
    parser = argparse.ArgumentParser(description='Change Luxafor colour')
    parser.add_argument('colour', choices=['green', 'yellow', 'red', 'off'], help='colour to change to')
    args = parser.parse_args()
    colour_codes = {'green': 'r=0, g=128, b=0', 'yellow': 89, 'red': 82}

    #flag = LuxaforFlag()
    #flag.off()
    #flag.do_fade_colour(
    #    leds=[LuxaforFlag.LED_TAB_1, LuxaforFlag.LED_BACK_1, LuxaforFlag.LED_BACK_2],
    #    r=10, g=10, b=0,
    #    duration=255
    #)

    #flag.do_static_colour(leds=LuxaforFlag.LED_BACK_3, r=0, g=0, b=100)

    #sleep(3)
    #flag.off()

    #flag.do_pattern(LuxaforFlag.PATTERN_POLICE, 3)

    flag = LuxaforFlag()
    flag.off()
    if args.colour == "green":
        flag.do_static_colour(leds=LuxaforFlag.LED_ALL, r=0, g=128, b=0)
    elif args.colour == "yellow":
        flag.do_static_colour(leds=LuxaforFlag.LED_ALL, r=255, g=255, b=0)
    elif args.colour == "red":
        flag.do_static_colour(leds=LuxaforFlag.LED_ALL, r=128, g=0, b=0)
    elif args.colour == "off":
        flag.off()
    else:
        print("not implemented")

if __name__ == '__main__':
    main()

