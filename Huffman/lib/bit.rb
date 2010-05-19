# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'Main.rb'
require 'tree.rb'
class Bit
	def initialize tree,kirjoita_tahan_tiedostoon
		@bits=Array.new
		@tree =tree
		@puskuri =Array.new
	end
	
	def write_bit(file,byte)
		if @bits.size<=7
			@bits.push byte
		else
			puts "kirjoittaa nama"
			puts @bits
			bit=bin2dec(@bits.to_s)
			file.putc(bit)
			@bits.clear
			@bits.push byte
		end
	end

	def read_bits(lue_tasta_tiedostosta)
		bits = dec2bin(lue_tasta_tiedostosta.getc).split(//)
		while bits.size<8
			bits.unshift("0")
		end
		puts "lukee nama"
		puts bits
		bits
	end

	def write_char char,file,eof
		puts "saa nama"
		puts char
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
			@bits.push('0') while @bits.size<=7
			puts "loppu"
			puts @bits
			bit=bin2dec(@bits.to_s)
			file.putc(bit)
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
