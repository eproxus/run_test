module RunTest

  def self.command(args)
    expression = args.first
    if File.exist? expression
      opts = expression
    elsif expression =~ /^[A-Z]/
      clazz = expression
      clazz = "#{clazz}Test" unless clazz.end_with? "Test"
      opts = `grep -R "^class #{clazz}" -l test`
    else
      expression = expression.dup
      expression.gsub!(/_/, "[ _]") unless expression =~ /^".*"$/
      files = `grep -R "#{expression}" -l test`.split("\n")
      file = files.sort_by!{ |f| File.basename(f).size }.first
      opts = "#{file}"
    end
    die("could not find tests for #{expression}") if opts.nil? || opts == ""
    "ruby -Itest #{opts}"
  end

  def self.die(message, code = 1)
    puts "error: #{message}"
    exit(code)
  end

end