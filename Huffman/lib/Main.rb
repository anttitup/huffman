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

	def avaa_tiedosto tiedoston_nimi
		File.open(tiedoston_nimi,'r')
	end

  def lue_tiedosto tiedosto_kahva
		apu=Array.new(256,0)
		tiedosto_kahva.each_byte{ |tavu|apu[tavu]+=1 }
		apu[@eof]+=1 #eof
		@merkkien_maara=apu
    tiedosto_kahva.close
  end
    
  def tee_puu(merkkien_maara)
		help=Heap.new
		merkkien_maara.each_with_index do |merkki,indeksi|
			help.tyonna!(Tree::Leaf.new(indeksi,merkki)) unless merkki==0
		end
		@keon_koko=help.koko
		help
  end
    
  def yhdista_puut(keko)
		if keko.koko==1
			return keko.pop
		else
			while keko.koko > 1
				a = keko.pop
				b = keko.pop
				keko.tyonna! Tree::Node.new(a,b)
			end
				return keko.pop
			end
		end

		def tee_koodit puu, prefix, taulu
			if puu.is_a? Tree::Leaf
				taulu[puu.charechter] =prefix
			else
				tee_koodit puu.vasen, prefix + "0", taulu
				tee_koodit puu.oikea, prefix + "1", taulu
			end
			taulu
		end

		def kirjoita_enkoodaus  taulu,tree
			enkoodatun_tiedoston_nimi=@tiedoston_nimi+".encd"
			encoded_file=File.new(enkoodatun_tiedoston_nimi, "w+")
			File.open(enkoodatun_tiedoston_nimi,"w")do|kirjoitettava_tiedosto|
				#tallennetaan taulukon koko
				kirjoitettava_tiedosto.puts @keon_koko
				self.merkkien_taajuus(kirjoitettava_tiedosto,self.merkkien_maara)
				File.open(@tiedoston_nimi,"r")  do |luettava_tiedsto|
					bitti=Bit.new(tree)
					until luettava_tiedsto.eof?
						byte=luettava_tiedsto.getc
						char=taulu[byte]
						bitti.kirjoita_charechter(char, kirjoitettava_tiedosto,false)
					end
						bitti.kirjoita_charechter(taulu[@eof],kirjoitettava_tiedosto,true)
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
		bit=Bit.new(puu)
			bits=[]
			$puu = puu
			until kirjoita_tasta_tiedostosta.eof? and bits.empty?
				node=puu
				until node.instance_of?(Tree::Leaf)
					bits=bit.lue_bitteja(kirjoita_tasta_tiedostosta) if bits.empty?
					bitti=bits.shift
					if bitti=='0'
						node=node.vasen
					elsif bitti == '1'
						node=node.oikea
					end
				end
				if !(node.charechter==@eof)
					kirjoita_tahan_tiedostoon.putc(node.charechter)
				else
					return
				end
			end
	end
end

	tiedosto = ARGV[0]
	argumentit = ARGV[1]

if File.exist?(tiedosto)
		m=Main.new(tiedosto)
	if argumentit == "enkoodaa"
		m.lue_tiedosto(m.avaa_tiedosto(m.tiedoston_nimi))
		keko=m.tee_puu(m.merkkien_maara)
		puu = m.yhdista_puut(keko)
		koodit=m.tee_koodit(puu,"",Array.new(m.keon_koko))
		m.kirjoita_enkoodaus(koodit,puu)
	elsif argumentit == "dekoodaa"
		if tiedosto.end_with?("encd")
		  m.pura_puu(tiedosto)
		else
			puts "kannattaako tätä tiedostoa nyt ihan varmana purkaa? "
		end
	else
		puts "väärä argumentti"
	end
else
	puts "tiedostoa ei löydy"
end