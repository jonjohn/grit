    attr_reader :a_mode, :b_mode
    def initialize(repo, a_path, b_path, a_commit, b_commit, a_mode, b_mode, new_file, deleted_file, diff)
      @a_mode = a_mode
      @b_mode = b_mode
        m, a_path, b_path = *lines.shift.match(%r{^diff --git a/(.+?) b/(.+)$})
        
        if lines.first =~ /^old mode/
          m, a_mode = *lines.shift.match(/^old mode (\d+)/)
          m, b_mode = *lines.shift.match(/^new mode (\d+)/)
        end
        
        if lines.first =~ /^diff --git/
          diffs << Diff.new(repo, a_path, b_path, nil, nil, a_mode, b_mode, false, false, nil)
          next
        end
          m, b_mode = lines.shift.match(/^new file mode (.+)$/)
          a_mode = nil
          m, a_mode = lines.shift.match(/^deleted file mode (.+)$/)
          b_mode = nil
        m, a_commit, b_commit, b_mode = *lines.shift.match(%r{^index ([0-9A-Fa-f]+)\.\.([0-9A-Fa-f]+) ?(.+)?$})
        b_mode.strip! if b_mode
        diffs << Diff.new(repo, a_path, b_path, a_commit, b_commit, a_mode, b_mode, new_file, deleted_file, diff)