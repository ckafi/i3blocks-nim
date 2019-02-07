require 'rake/clean'

nim_files = Rake::FileList.new("*.nim")

task :default => :nim
task :nim => nim_files.ext("")

nim_files.each do |f|
    output = File.basename(f,".nim")
    file output => f do
        sh "nim compile -d:release --opt:size #{f}"
        sh "strip -s #{output}"
    end
end

CLEAN << nim_files.ext("")
