class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def cyan
    self.class.colorize(self, 36)
  end

  def green
    self.class.colorize(self, 32)
  end
end

desc 'Setup private files so it will compile'
task :setup do
  puts 'Updating submodules...'.cyan
  # Update and initialize the submodules in case they forget
  `git submodule update --init --recursive`
  puts 'Done! You\'re ready to get started!'.green
end

# Run setup by default
task :default => :setup
