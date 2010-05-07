# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'Main.rb'
require 'tree.rb'
class Bit
	def initialize tree
		@bits=Array.new
		@tree =tree
	end
	
	def write_bit(file,byte)
		if @bits.size<=7
			@bits.push byte
		else
			bit=bin2dec(@bits.to_s)
			file.putc(bit)
			@bits.clear
		end
	end

	def read_bits(file)
		bit=file.getc
		bit=dec2bin(bit)
		bit.split(//)until bit.size==8
		bit
	end

	def read_bit(bits,tree)
		bits=dec2bin(bits)
		bits=bits.split(//)unless bits==0
		bits=bits.to_a if bits==0
		bits.unshift("0")until bits.size==8
		node,bits=which_char(bits,tree)
		return node,bits
	end

	def write_char char,file,eof
		unless eof
			bits=char.split(//)
			until bits.empty?
				bits=bits
				bit=bits.shift
				self.write_bit(file, bit)
			end
		else
			bits=char.split(//)
			until bits.empty?||bits.nil?
				bit=bits.shift
				self.write_bit(file, bit)
			end
			self.write_bit(file,"0")	until @bits.empty?
		end
	end

	def which_char(bit,tree)
		node=tree
		bits=bit
		bitti=bits.shift
		if	node.instance_of?(Tree::Leaf)
			return node,bits
		elsif bitti.nil?
			return node
		elsif bitti == '1'
			return which_char(bits,node.get_right)
		else
			return which_char(bits,node.get_left)
		end
	end

	def bin2dec(number)
   ret_dec = 0;
   number.split(//).each{|digit|
      ret_dec = (Integer(digit) + ret_dec) * 2;
   }
   return ret_dec/2;
end

	def dec2bin(number)
   number = Integer(number);
   if(number == 0)
      return 0;
   end
   ret_bin = "";
 
   while(number != 0)
      ret_bin = String(number % 2) + ret_bin;
      number = number / 2;
   end
   return ret_bin;
end

end
