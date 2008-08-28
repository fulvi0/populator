require 'spec/rake/spectask'

spec_files = Rake::FileList["spec/**/*_spec.rb"]

ADAPTERS = %w[sqlite3 mysql]

desc "Run specs under all supported databases"
task :spec => ADAPTERS.map { |a| "spec:#{a}" }

namespace :spec do
  ADAPTERS.each do |adapter|
    namespace :prepare do
      task adapter do
        ENV["POPULATOR_ADAPTER"] = adapter
      end
    end
    
    desc "Run specs under #{adapter}"
    Spec::Rake::SpecTask.new(adapter => "spec:prepare:#{adapter}") do |t|
      t.spec_files = spec_files
      t.spec_opts = ["-c"]
    end
  end
end
