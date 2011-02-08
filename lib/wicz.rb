module TextEditor
  class Document
    def initialize(value = nil)
      @snapshot = 0
      @content = []
      @changes = []
      add_text(value) unless value.nil?
    end

    def contents
      @content = []
      @changes.first(@snapshot).each do |change|
        if change[0] == :add
          @content.insert(change[2], change[1].split('')).flatten!
        else
          @content.slice!(change[1]...change[2])
        end
      end
      @content.join
    end

    def add_text(value, position = -1)
      execute_command { @changes << [:add, value, position] }
    end

    def remove_text(first = 0, last = contents.length)
      execute_command  { @changes << [:remove, first, last] }
    end

    def undo
      return if @snapshot == 0
      @snapshot -= 1
    end

    def redo
      return if @snapshot == @changes.length
      @snapshot += 1
    end

    private

    def execute_command(&block)
      @changes = @changes.first(@snapshot) if @snapshot != @changes.length
      yield
      @snapshot = @changes.length
    end

  end
end