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

import os, cpuinfo, strutils, strformat
import colorscale

let
    time = getEnv("time")
    time_index = if time == "1": 0
                 elif time == "5": 1
                 elif time == "15": 2
                 else: 0
    avgs = readFile("/proc/loadavg").split()
    load = avgs[time_index].parseFloat()
    nproc = countProcessors()
    load_per_proc = load/float(nproc)

echo fmt"{load:.2f}" # full_text
echo fmt"{load:.2f}" # short_text
if load_per_proc >= 1.0:
    echo red_hex # color
