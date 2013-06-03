module RunTest

  def self.command(target)
    files, test_case = if File.exist? target
      [Array(target)]
    elsif target =~ /^[A-Z]/
      clazz = target
      clazz = "#{clazz}Test" unless clazz.end_with? "Test"
      [grep("^class #{clazz}")]
    else
      expression = target.gsub(/[ _]/, "[ _]")
      [grep(expression), expression]
    end
    file = files.sort_by!{ |f| File.basename(f).size }.first
    die("could not find tests for #{target}") unless file
    test_cases = test_case ? " -n \"#{test_case}\"" : ""
    "ruby -Itest #{file}#{test_cases}"
  end

  private

  def self.die(message, code = 1)
    puts "error: #{message}"
    exit(code)
  end

  def self.grep(expression)
    `grep -R "#{expression}" -l test`.split("\n")
  end

end