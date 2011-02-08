require "test/unit"
require "rubygems"

# gem install contest or github.com/citrusbyte/contest
require "contest"
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

require "wicz"

class DocumentTest < Test::Unit::TestCase

  context "initialize" do

    test "start blank" do
      @doc = TextEditor::Document.new
      assert_equal("", @doc.contents)
    end

    test "start from arguments" do
      @doc = TextEditor::Document.new("Hello RMU!")
      assert_equal("Hello RMU!", @doc.contents)
    end

  end

  context "#add_text" do

    context "new file" do

      setup do
        @doc = TextEditor::Document.new
      end

      test "add single contents" do
        @doc.add_text("Hello RMU!")
        assert_equal("Hello RMU!", @doc.contents)
      end

      test "add multiple contents" do
        @doc.add_text("Hello ")
        @doc.add_text("RMU!")
        assert_equal("Hello RMU!", @doc.contents)
      end

      test "add contents to position" do
        @doc.add_text("Hello")
        @doc.add_text("RMU! ", 0)
        assert_equal("RMU! Hello", @doc.contents)
      end

    end

    context "existing file with contents" do

      setup do
        @doc = TextEditor::Document.new("Hello")
      end

      test "add single contents" do
        @doc.add_text(" RMU!")
        assert_equal("Hello RMU!", @doc.contents)
      end

    end

  end

  context "#remove_text" do

    setup do
      @doc = TextEditor::Document.new("Hello RMU!")
    end

    test "remove first character" do
      @doc.remove_text(0, 1)
      assert_equal("ello RMU!", @doc.contents)
    end

    test "remove second character" do
      @doc.remove_text(1, 2)
      assert_equal("Hllo RMU!", @doc.contents)
    end

    test "remove first three chars" do
      @doc.remove_text(0, 3)
      assert_equal("lo RMU!", @doc.contents)
    end

    test "remove all chars" do
      @doc.remove_text
      assert_equal("", @doc.contents)
    end

  end

  context "undo and redo" do

    setup do
      @doc = TextEditor::Document.new
    end

    test "undo" do
      @doc.add_text("Hello RMU!")
      @doc.undo
      assert_equal("", @doc.contents)
    end

    test "undo, redo" do
      @doc.add_text("Hello RMU!")
      @doc.undo
      @doc.redo
      assert_equal("Hello RMU!", @doc.contents)
    end

    test "undo without contents" do
      @doc.undo
      assert_equal("", @doc.contents)
    end

    test "redo without undo" do
      @doc.redo
      assert_equal("", @doc.contents)
    end

    test "add, add, undo, add" do
      @doc.add_text("Hello")
      @doc.add_text(" RMU!")
      @doc.undo
      @doc.add_text(" World!")
      assert_equal("Hello World!", @doc.contents)
    end

    test "add, add, undo, remove" do
      @doc.add_text("Hello")
      @doc.add_text(" RMU!")
      @doc.undo
      @doc.remove_text(4, 5)
      assert_equal("Hell", @doc.contents)
    end

    test "add, add, redo, redo, undo" do
      @doc.add_text("Hello")
      @doc.add_text(" RMU!")
      @doc.redo
      @doc.redo
      @doc.undo
      assert_equal("Hello", @doc.contents)
    end

  end

end
