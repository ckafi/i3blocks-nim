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

import re, strutils, os
import colorscale

proc sum(a: openArray[string]): int =
    for i in a:
        result += parseInt(i)

proc stats(): tuple[idle, total: int] =
    for line in lines("/proc/stat"):
        if line.startsWith(re"cpu\s+"):
            let matches = line.findAll(re"\d+")
            return (parseInt(matches[3]), sum(matches))

var (idle1, total1) = stats()
sleep(1000)
var (idle2, total2) = stats()

var percentage = 1-(idle2-idle1)/(total2-total1)
echo int(100*percentage), "%" # full_text
echo int(100*percentage), "%" # short_text
echo GreenToRed(percentage) # color
