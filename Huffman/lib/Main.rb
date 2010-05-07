# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'tree.rb'
require 'heap.rb'
require 'bit.rb'
class Main

  attr_reader :data_array,:file_name,:heap,:tree,:array_size
	attr_accessor :heap_size

  def initialize file_name
    @data_array = Array.new 256,0
    @file_name = file_name
    @heap = Heap.new
		@heap_size=0
		@eof=255
		$table=0
  end


  def read_file! 
		help_array= Array.new(256,0)
		File.open(@file_name,'r')do|file|
			file.each_byte { |byte|help_array[byte]+=1 }
			help_array[@eof]+=1 #eof
			@data_array=help_array
    end
  end
    
  def make_tree()
		heap=Heap.new
		@data_array.each_with_index do |item,index|
			heap.push!(Tree::Leaf.new(index,item)) unless item==0
		end
		@heap_size	=heap.size
		heap
  end
    
  def merge_tree(heap)
		if heap.size==1
			return heap.pop
		else
			while heap.size > 1
				a = heap.pop
				b = heap.pop
				heap.push! Tree::Node.new(a,b)
			end
				return heap.pop
			end
		end
#muista tehdä table main ohjelmaan
		def make_table_helper tree, prefix, table
			if tree.is_a? Tree::Leaf
				table[tree.charechter] =prefix
			else
				make_table_helper tree.get_left, prefix + "0", table
				make_table_helper tree.get_right, prefix + "1", table
			end
			table
		end

		def write_encoding  table,tree
			encode_file_name=@file_name+".encd"
			encoded_file=File.new(encode_file_name, "w+")
			File.open(encode_file_name,"w")do|file|
				#tallennetaan taulukon koko
				file.puts @heap_size
				self.encode_node(file,self.data_array)
				File.open(@file_name,"r")  do |a_file|
					bit=Bit.new(a_file)
					until a_file.eof?
						byte=a_file.getc
						char=table[byte]
						bit.write_char(char, file,false)
					end
						bit.write_char(table[@eof],file,true)
				end
			end
			encode_file_name
		end
		
		def encode_node(file,data_array)
			data_array.each_with_index { |item,index|
				file.puts("#{index} #{item}") unless item==0
			}
		end

	
	def decode_tree file_name
		file_n=file_name.chomp(".encd")
		File.new(file_n,"w")
		File.open(file_name,"r") do |file|
			tree=self.make_decode_tree(file)
			File.open(file_n,"w")do|write_this_file|
				self.write_undecoded_file(write_this_file,file,tree)
			end
		end
	end

	def make_decode_tree file
		freqs=Array.new 256,0
		line=[]
		@array_size=file.gets.to_i
		@array_size.times do
			line<<file.gets
		end
		for item in line
			item=item.split(" ")
			index=item.shift.to_i
			freqs[index]=item.shift.to_i
		end
		@data_array=freqs
		heap=self.make_tree
		$table=self.merge_tree(heap)
		$table
	end

	def write_undecoded_file write_this_file,file,tree
			bit=Bit.new(tree)
			$byte=[]
			node=tree
			until file.eof?
				node=tree
				until node.instance_of?(Tree::Leaf)	
					bits=file.getc
					node,bits=bit.read_bit(bits,node)
					puts(bits)
					until bits.empty?
							if node.instance_of?(Tree::Leaf)
								puts(node.charechter)
								write_this_file.putc(node.charechter) if node.instance_of?(Tree::Leaf)
								node=tree
							end
							node,bits=bit.which_char(bits, node)
							puts(bits)
					end
						return if node.charechter==@eof
						write_this_file.putc(node.charechter) if node.instance_of?(Tree::Leaf)
						bits=0
				end
			
			end
	end
end
def test_script
	actual_string = "abccccccccccccccc"
	actual_file=File.new(actual_string,"w+")
	File.open(actual_string,"w") do |file|
		actual_string.each_char {|cstr|file.putc(cstr)  }
	end
	$m=Main.new(actual_string)
	$m.read_file!
	heap=$m.make_tree
	$a=$m.merge_tree(heap)
	$u=$m.make_table_helper($a, "", Array.new($m.heap_size))
	s=$m.write_encoding($u,$a)
	t=$m.decode_tree(s)
end
