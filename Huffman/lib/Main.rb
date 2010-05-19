# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'tree.rb'
require 'heap.rb'
require 'bit.rb'
class Main

  attr_reader :merkkien_maara,:tiedoston_nimi,:keko,:keon_koko

  def initialize tiedoston_nimi
    @merkkien_maara = Array.new 256,0
    @tiedoston_nimi = tiedoston_nimi
    @keko = Heap.new
		@eof=255
		@keon_koko
  end


  def lue_tiedosto
		apu= Array.new(256,0)
		File.open(@tiedoston_nimi,'r')do|tiedosto|
			tiedosto.each_byte { |tavu|apu[tavu]+=1 }
			apu[@eof]+=1 #eof
			@merkkien_maara=apu
    end
  end
    
  def tee_puu(merkkien_maara)
		help=Heap.new
		merkkien_maara.each_with_index do |merkki,indeksi|
			help.push!(Tree::Leaf.new(indeksi,merkki)) unless merkki==0
		end
		@keon_koko=help.size
		help
  end
    
  def yhdista_puut(keko)
		if keko.size==1
			return keko.pop
		else
			while keko.size > 1
				a = keko.pop
				b = keko.pop
				keko.push! Tree::Node.new(a,b)
			end
				return keko.pop
			end
		end

		def tee_koodit puu, prefix, taulu
			if puu.is_a? Tree::Leaf
				taulu[puu.charechter] =prefix
			else
				tee_koodit puu.get_left, prefix + "0", taulu
				tee_koodit puu.get_right, prefix + "1", taulu
			end
			taulu
		end

		def write_encoding  taulu,tree
			enkoodatun_tiedoston_nimi=@tiedoston_nimi+".encd"
			encoded_file=File.new(enkoodatun_tiedoston_nimi, "w+")
			File.open(enkoodatun_tiedoston_nimi,"w")do|kirjoitettava_tiedosto|
				#tallennetaan taulukon koko
				kirjoitettava_tiedosto.puts @keon_koko
				self.merkkien_taajuus(kirjoitettava_tiedosto,self.merkkien_maara)
				File.open(@tiedoston_nimi,"r")  do |luettava_tiedsto|
					bitti=Bit.new(tree,luettava_tiedsto)
					until luettava_tiedsto.eof?
						byte=luettava_tiedsto.getc
						char=taulu[byte]
						bitti.write_char(char, kirjoitettava_tiedosto,false)
					end
						bitti.write_char(taulu[@eof],kirjoitettava_tiedosto,true)
				end
			end
			enkoodatun_tiedoston_nimi
		end
		
		def merkkien_taajuus(tiedsto,merkkien_maara)
			merkkien_maara.each_with_index { |merkki,indeksi|
				tiedsto.puts("#{indeksi} #{merkki}") unless merkki==0
			}
		end

	
	def pura_puu purettava_tiedosto
		puretun_tiedoston_nimi=purettava_tiedosto.chomp(".encd")
		File.new(puretun_tiedoston_nimi,"w")
		File.open(purettava_tiedosto,"r") do |tiedosto|
			puu=self.tee_dekoodaus_puu(tiedosto)
			File.open(puretun_tiedoston_nimi,"w")do|kirjoita_tahan_tiedostoon|
				self.kirjoita_dekoodattu_tiedosto(kirjoita_tahan_tiedostoon,tiedosto,puu)
			end
		end
	end

	def tee_dekoodaus_puu tiedosto
		freqs=Array.new 256,0
		rivi=[]
		taulukon_koko=tiedosto.gets.to_i
		taulukon_koko.times do
			rivi<<tiedosto.gets
		end
		for merkki in rivi
			merkki=merkki.split(" ")
			index=merkki.shift.to_i
			freqs[index]=merkki.shift.to_i
		end
		heap=tee_puu(freqs)
		puu=yhdista_puut(heap)
		puu
	end

	def kirjoita_dekoodattu_tiedosto kirjoita_tahan_tiedostoon,kirjoita_tasta_tiedostosta,puu
		bit=Bit.new(puu,kirjoita_tasta_tiedostosta)
			bits=[]
			$puu = puu
			until kirjoita_tasta_tiedostosta.eof? and bits.empty?
				node=puu
				until node.instance_of?(Tree::Leaf)
					bits=bit.read_bits(kirjoita_tasta_tiedostosta) if bits.empty?
					bitti=bits.shift
					if bitti=='0'
						node=node.get_left
					elsif bitti == '1'
						node=node.get_right
					end
					puts node
				end
				if !(node.charechter==@eof)
					puts node.charechter
					kirjoita_tahan_tiedostoon.putc(node.charechter)
				else
					return
				end
			end
	end
end
def test_script
	actual_string = "abeeertyujdmfv,gb.hljdhgsftwyeu4"
	actual_file=File.new(actual_string,"w+")
	File.open(actual_string,"w") do |file|
		actual_string.each_char {|cstr|file.putc(cstr)  }
	end
	$m=Main.new(actual_string)
	$m.lue_tiedosto
	heap=$m.tee_puu($m.merkkien_maara)
	$a=$m.yhdista_puut(heap)
	$u=$m.tee_koodit($a, "", Array.new($m.keko.size))
	s=$m.write_encoding($u,$a)
	t=$m.pura_puu(s)
end
