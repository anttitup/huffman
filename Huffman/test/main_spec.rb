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
		@actual_array[255]=1
    help=@actual_string
		help.each_char{|char|main.putc(char)}
		main.close
    @main = Main.new(@actual_string)
  end

  it "pitäisi avata tiedostokahva"do
	apu=@main.avaa_tiedosto(@actual_string)
	apu.should_not be nil?
	apu.should be_a(IO)
	end

  it "tämän testin pitäisi palauttaa samat freqvenssit kuin actual_stringissä" do
		@main.lue_tiedosto(@main.avaa_tiedosto(@actual_string))
    @main.merkkien_maara.should_not be_empty, 'data string is empty'
    @main.merkkien_maara.should == @actual_array
  end

  it "pitäisi luoda keko" do
		@heap=@main.tee_puu(@main.merkkien_maara)
		@heap.should be_a(Heap)
		@main.keon_koko.should == @actual_array.clone.delete_if{|item| item==nil}.size
  end

#skipataan myöhempää ajankohtaa varten
	it do "pitäisi palautta puu"
		@tree=@main.merge_tree(@heap)
		@tree.should be_a(Tree)
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

