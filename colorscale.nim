# Copyright 2019 Tobias Frilling

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import strformat, math

# I'd like to use ranges, but tuple of subranges is awkward in nim
type
    HSV = tuple[h, s, v: int] # max (359,100,100)
    RGB = tuple[r, g, b: int] # max (255,255,255)

proc RGBasHex(input: RGB): string =
    let (r,g,b) = input
    result = fmt"#{r:02X}{g:02X}{b:02X}"

proc HSVtoRGB(input: HSV): RGB =
    var r, g, b: float
    let
        c = (input.v/100) * (input.s/100)
        x = c * (1 - abs((input.h / 60) mod 2 - 1))
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
    let factor = if t > 1.0: 1.0
                 else: t
    (int(float(a.h) + float(b.h - a.h) * factor),
     int(float(a.s) + float(b.s - a.s) * factor),
     int(float(a.v) + float(b.v - a.v) * factor))


const
    green_hsv: HSV = (120,100,100)
    green_hex*     = HSVtoRGB(green_hsv).RGBasHex()
    red_hsv  : HSV = (0  ,100,100)
    red_hex*       = HSVtoRGB(red_hsv).RGBasHex()

proc GreenToRed*(t:float): string =
    LerpHSV(green_hsv,red_hsv,t).HSVtoRGB().RGBasHex()
