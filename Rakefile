require 'rake/clean'

nim_files = Rake::FileList.new("memory.nim", "cpu_usage.nim", "battery.nim")

task :default => :nim
task :nim => nim_files.ext("")

nim_files.each do |f|
    output = File.basename(f,".nim")
    file output => [f, "colorscale.nim"] do
        sh "nim compile -d:release --opt:size #{f}"
        sh "strip -s #{output}"
    end
end

CLEAN << nim_files.ext("")
