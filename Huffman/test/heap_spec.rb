# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'heap.rb'
require 'spec'
require 'tree.rb'
describe "new heap" do
  before(:each) do
    @heap = Heap.new
		@array=[Tree::Leaf.new(1,2),Tree::Leaf.new(0,0),Tree::Leaf.new(0,0),Tree::Leaf.new(1,2),Tree::Leaf.new(1,2)]
	end

  it "heap should should_not_be_nil" do
		@heap.should_not be_nil
  end

	it "0 should be firs after heapify" do
		@heap.heapify(0, @array)
		zero=@array.shift
		zero.freq.should==0
	end
	#heapify testi
	it "should heapify"do
		@heap.push!(@array.shift) until @array.empty?
		zero=@heap.heap.shift
		zero.freq.should==0
	end

	it "should pop" do
		@heap.heap=@array
		@heap.heap=@heap.heapify(0, @heap.heap)
		zero=@heap.pop
		zero.freq.should==0
		end
end

