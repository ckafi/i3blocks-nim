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

import re, strutils, ospaths
import colorscale

const threshold = 0.40

var
    mem_total:  int
    mem_free:   int
    swap_total: int
    swap_free:  int

for line in lines("/proc/meminfo"):
    var matches: array[2, string]
    if line.match(re"MemTotal:\s*(\d+)", matches):
        mem_total = parseInt(matches[0])
    elif line.match(re"(MemFree|Buffers|Cached):\s*(\d+)", matches):
        mem_free += parseInt(matches[1])
    elif line.match(re"SwapTotal:\s*(\d+)", matches):
        swap_total += parseInt(matches[0])
    elif line.match(re"SwapFree:\s*(\d+)", matches):
        swap_free += parseInt(matches[0])

var percentage: float
if getEnv("BLOCK_INSTANCE") == "swap":
    percentage = 1-swap_free/swap_total
else:
    percentage = 1-mem_free/mem_total

echo int(100*percentage), "%" # full_text
echo int(100*percentage), "%" # short_text
if percentage >= threshold:
    echo GreenToRed(percentage) # color
