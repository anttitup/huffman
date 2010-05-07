# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'Main.rb'
require 'tree.rb'
require 'spec'

describe Main  do
  
  before :all  do
    @actual_string = "lib/hello_world.txt"
		main = File.new(@actual_string, "w+")
    @actual_array = Array.new 256,0
    @actual_string.each_byte{|byte|@actual_array[byte]+=1}
    help=@actual_string
		help.each_char{|char|main.putc(char)}
    @main = Main.new(@actual_string)
  end
   
  it "file should read in string and it shoudl equal to actual_string" do
    @main.read_file!
    @main.data_array.should_not be_empty, 'data string is empty'
    @main.data_array.should == @actual_array
  end

  it "heap shoudt be empty and it shoud be in order" do
		@heap.data_array=@actual_array
		heap=@main.make_tree
		@heap=@main.make_tree
		leaf=heap.pop
		leaf.should be_a(Tree::Leaf)
  end
#skipataan myöhempää ajankohtaa varten
	it do "should return whole tree"
		@tree=@main.merge_tree(@heap)
	end

	it "should make a table" do
		@table=@main.make_table_helper @tree, String.new,Array.new
	end
#jatketaan


	it "should write a encoding" do
		@filu=@main.write_encoding @table
		@filu.should exist
	end

	it "shoud now decode it" do
		@main.decode_tree @filu.basename
	end

	it "should decode it now" do
		file=@main.decode @file, @tree, File.new
		file.should exist
	end


end

