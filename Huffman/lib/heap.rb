# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'tree.rb'

class Heap
	attr_accessor :keko

	def initialize
    @keko = Array.new
	end

	def tyonna! lehti
		if @keko.empty?
			@keko.push(lehti)
		elsif @keko.size<2
			if lehti.freq>freq(viimeinen(@keko),@keko)
				@keko.push(lehti)
			else
				@keko.unshift(lehti)
			end
		else
			@keko.push(lehti)
			i = viimeinen(@keko)
			parent=isanta(i)
			while i>0 and lehti.freq<freq(parent,@keko)
				vaihda(i,parent,@keko)
				i=isanta(i)
				parent=isanta(i)
			end
		end
	end

  def heapify i
		return if @keko.nil? or @keko.empty?
		heap_a=@keko
		left = vasen(i)
    right = oikea(i)
		if left<=viimeinen(heap_a) and freq(left,heap_a) < freq(i,heap_a)
			smallest = left
    else
			smallest = i
    end
		if  right<=viimeinen(heap_a) and freq(right,heap_a) < freq(smallest,heap_a)
			smallest = right
		end
		unless smallest==i
			self.vaihda(i,smallest,heap_a)
			self.heapify(smallest)
    end
		@keko=heap_a
  end

	def vaihda vaihda_tama, tahan,keko
	  help = keko[vaihda_tama]
    keko[vaihda_tama]=keko[tahan]
    keko[tahan]=help
		keko
	end

  def pop #niin hyvä etten viitsi suomentaa
		if @keko.nil?||@keko.size==0
			return nil
		elsif @keko.size<3
			min=@keko.first
			@keko.delete_at(0)
			return min
		else
			min = @keko.first
			self.vaihda(0,self.viimeinen(@keko),@keko)
			@keko.delete_at(self.viimeinen(@keko))
			@keko=self.heapify(0)	unless @keko.size<=1
		return min
		end
  end
  
  def isanta i
		if i<=2
			return 0
		else
			return i/2-1
		end
  end
  
  def vasen i
			2*i+1
  end

  def oikea i
		2*i+2
  end

  def viimeinen keko
    unless keko.size==0
			return keko.size-1
		else
			return 0
		end
  end

	def freq(index,keko)
		if index<keko.length
			freq=keko.fetch(index)
			return freq.freq
		else
				raise "vaara indeksi!"
		end
	end

	def koko
		@keko.size
	end

end