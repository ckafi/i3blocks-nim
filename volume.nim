# Copyright 2020 Tobias Frilling

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import nre, os, osproc

let
  mixer = getEnv("MIXER")
  scontrol = getEnv("BLOCK_INSTANCE")
  step = "5%"

proc setVol(s: string) =
  discard execProcess("amixer",
    args = ["-D", mixer, "sset", scontrol, s],
    options={poUsePath})

proc getVol(): string =
  let amixer_output = execProcess("amixer",
    args = ["-D", mixer, "get", scontrol],
    options = {poUsePath})
  let rexp = re".*\[(\d+%)\] (\[(-?\d+.\d+dB)\] )?\[(on|off)\]"
  let m = amixer_output.find(rexp)
  return if m.get.captures[3] == "off": "MUTE"
         else: m.get.captures[0]

case getEnv("BLOCK_BUTTON"):
  of "3": setVol("toggle")
  of "4": setVol(step & "+")
  of "5": setVol(step & "-")

echo getVol()
