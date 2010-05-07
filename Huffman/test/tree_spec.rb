# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'tree.rb'
require 'spec'
describe "new tree"  do
  before(:all) do
    @a,@b='a'.unpack('c'),'b'.unpack('c')
		@a_freg,@b_freg =55,2
		@tree = Tree::Tree.new 
		@left = Tree::Leaf.new @a, @a_freg
		@child = Tree::Leaf.new @b,@b_freg
		@right = Tree::Node.new(@child)
  end

	it "all should extist" do
		@tree.should_not be_nil
		@left.should_not be_nil
		@child.should_not be_nil
		@right.should_not be_nil
	end

	it "you can minus two trees" do
			test=@left.minus(@child)
			test.should==(@a_freg-@b_freg)
	end

	it "Leaf should return char" do
		@left.charechter.should== @a
		@child.charechter.should== @b
	end

	it "Leaf should return frequensy" do
		@left.freq.should==@a_freg
		@child.freq.should ==@b_freg
	end
end

