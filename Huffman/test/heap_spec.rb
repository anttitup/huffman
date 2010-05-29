# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'heap.rb'
require 'spec'
require 'tree.rb'
describe "new heap" do
  before(:each) do
    @heap = Heap.new
		@array=[Tree::Leaf.new(1,3),Tree::Leaf.new(0,0),Tree::Leaf.new(0,1),Tree::Leaf.new(1,4),Tree::Leaf.new(1,2)]
	end

  it "taulukko ei saisi olla tyhjä" do
		@heap.keko.should_not be_nil
  end

	it "työnnetään arrayn alkiot kekoon arrayn pienin alkio pitiäisi olla ensimmäisenä" do
		apu=@array.clone
		while !apu.empty?
			lehti=apu.shift
			@heap.tyonna!(lehti)
		end
		pienin_lehti=@heap.keko.shift
		pitaisi_olla_pienin=@array.min_by{|lehti|lehti.freq}
		pienin_lehti.freq.should == pitaisi_olla_pienin.freq
	end
	
	#heapify testi
	it "pitäisi heapifoida"do
		alkuperainen = @array.clone
		@heap.tyonna!(@array.shift) until @array.empty?
		keko = @heap.clone
		apu=[]
		until(@heap.size==0)
			keko.heapify(0)
			lehti = keko.keko.shift
			apu.push(lehti)
		end
		apu.should == alkuperainen.sort_by{|lehti|lehti.freq}
		@array = alkuperainen
	end

	it "pitäisi pystyä poppaamaan" do
		array = []
		@heap.keko = @array.clone
		@heap.heapify(0)
		array.push(@heap.pop) until @heap.size==0
		array.should == @array.sort_by{|lehti|lehti.freq}
		end
end

