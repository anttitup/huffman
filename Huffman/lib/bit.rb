# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'tree.rb'
class Bit
	def initialize(tree)
		@bitteja=Array.new
		@tree =tree
		@puskuri =Array.new
	end
	
	def kirjoita_bitti(tiedosto,tavu)
		if @bitteja.size<=7
			@bitteja.push tavu
		else
			bit=binaarit_integereiksi(@bitteja.to_s)
			tiedosto.putc(bit)
			@bitteja.clear
			@bitteja.push tavu
		end
	end

	def lue_bitteja(lue_tasta_tiedostosta)
		bits = integerit_binaareiksi(lue_tasta_tiedostosta.getc).split(//)
		while bits.size<8
			bits.unshift("0")
		end
		bits
	end

	def kirjoita_charechter char,tiedosto,eof
		unless eof
			bits=char.split(//)
			until bits.empty?
				bits=bits
				bit=bits.shift
				kirjoita_bitti(tiedosto, bit)
			end
		else
			bits=char.split(//)
			until bits.empty?||bits.nil?
				bit=bits.shift
				kirjoita_bitti(tiedosto, bit)
			end
			@bitteja.push('0') while @bitteja.size<=7
			bit=binaarit_integereiksi(@bitteja.to_s)
			tiedosto.putc(bit)
		end
	end

	def binaarit_integereiksi(numero)
   ret_dec = 0
   numero.split(//).each{|digit|
      ret_dec = (Integer(digit) + ret_dec) * 2
   }
   return ret_dec/2
end

	def integerit_binaareiksi(numero)
   numero = Integer(numero);
   if(numero == 0)
      return 0
   end
   ret_bin ="" 
   while(numero != 0)
      ret_bin = String(numero % 2) + ret_bin
      numero = numero / 2
   end
   return ret_bin
	end

end
