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

import strutils, ospaths, math, strformat
import colorscale

let threshold = if getEnv("threshold").len == 0: 0.0
                else: getEnv("threshold").parseInt() / 100

proc readInt(f: string): int =
    readFile(f).strip().parseInt()

let
    path = "/sys/class/power_supply/" & getEnv("BLOCK_INSTANCE") & "/"
    status = if open(path & "status").readLine() == "Charging": "C" else: "D"

    capacity = readInt(path & "capacity")
    current_now = readInt(path & "current_now")
    charge_now = readInt(path & "charge_now")
    charge_full = readInt(path & "charge_full")

var remaining_time: float

if status == "D":
    remaining_time = charge_now/current_now
else:
    remaining_time = (charge_full - charge_now)/current_now

let
    remaining_hours = int(remaining_time)
    remaining_minutes = int((remaining_time - floor(remaining_time)) * 60)
    short_text = fmt"{capacity}% {status}"
    full_text = short_text & fmt" {remaining_hours}:{remaining_minutes:02}"



# Don't print remaining time if battery is full
if remaining_time > 0:
    echo full_text
else:
    echo short_text
echo short_text
if status == "D" and (capacity/100) < threshold:
    echo GreenToRed(1 - capacity/100)
