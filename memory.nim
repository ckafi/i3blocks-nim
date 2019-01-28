import re, strutils, ospaths
import colorscale

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
    elif line.match(re"SwapFree:\s(\d+)", matches):
        swap_free += parseInt(matches[0])

var percentage: int
if getEnv("BLOCK_INSTANCE") == "swap":
    percentage = int(100*(1-swap_free/swap_total))
else:
    percentage = int(100*(1-mem_free/mem_total))

echo percentage, "%" # full_text
echo percentage, "%" # short_text
echo GreenToRed(percentage/100) # color
