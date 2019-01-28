import strformat

# I would like to use ranges, but tuple of subranges is awkward in nim
type
    HSV = tuple[h, s, v: int] # max (359,100,100)
    RGB = tuple[r, g, b: int] # max (255,255,255)

proc `mod`(x:float, y:int): float =
    result = x - float(int(x) div y * y)

proc RGBasHex(input: RGB): string =
    let (r,g,b) = input
    result = fmt"#{r:02X}{g:02X}{b:02X}"

proc HSVtoRGB(input: HSV): RGB =
    var r, g, b: float
    let
        c = (input.v/100) * (input.s/100)
        x = c * float(1 - abs((input.h / 60) mod 2 - 1))
        m = (input.v/100) - c
    case input.h div 60:
        of 0: (r,g,b) = (c,x,0.0)
        of 1: (r,g,b) = (x,c,0.0)
        of 2: (r,g,b) = (0.0,c,x)
        of 3: (r,g,b) = (0.0,x,c)
        of 4: (r,g,b) = (x,0.0,c)
        else: (r,g,b) = (c,0.0,x)
    result = (int((r+m)*255),
              int((g+m)*255),
              int((b+m)*244))

proc LerpHSV(a,b: HSV, t:float): HSV =
    (int(float(a.h) + float(b.h - a.h) * t),
     int(float(a.s) + float(b.s - a.s) * t),
     int(float(a.v) + float(b.v - a.v) * t))


const
    green: HSV = (120,100,100)
    red  : HSV = (0  ,100,100)

proc GreenToRed*(t:float): string =
    RGBasHex(HSVtoRGB(LerpHSV(green,red,t)))
