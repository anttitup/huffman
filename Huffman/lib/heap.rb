# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'tree.rb'

class Heap
	attr_accessor :heap
	def initialize
    @heap = Array.new
	end

	def push! leaf
		heap=self.heap
		if heap.empty?
			heap.push(leaf)
		elsif heap.size<3
			if leaf.freq>self.freq(self.last(heap),heap)
				heap.push(leaf)
			else
				heap.unshift(leaf)
			end
		else
			heap.push(leaf)
			i = self.last(heap)
			parent=self.parent(i)
			while i>0 and leaf.freq<self.freq(parent,heap)
				self.swap(i,parent,heap)
				i=self.parent(i)
				parent=self.parent(i)
			end
			@heap=heap
			return @heap
		end
	end

  def heapify i, heap
		heap_a=heap
		left = self.left(i)
    right = self.right(i)
		if left<=self.last(heap_a) and self.freq(left,heap_a) < self.freq(i,heap_a)
			smallest = left
    else
			smallest = i
    end
		if  right<=self.last(heap_a) and self.freq(right,heap_a) < self.freq(smallest,heap_a)
			smallest = right
		end
		unless smallest==i
			self.swap(i,smallest,heap_a)
			self.heapify(smallest,heap_a)
    end
		heap_a
  end

	def swap swap_this, swap_in_this,heap
	  help = heap[swap_this]
    heap[swap_this]=heap[swap_in_this]
    heap[swap_in_this]=help
		heap
	end

  def pop #fi

		if @heap.nil?||@heap.size==0
			return nil
		elsif @heap.size<3
			min=@heap.first
			@heap.delete_at(0)
			return min
		else
			min = @heap.first
			self.swap(0,self.last(@heap),@heap)
			@heap.delete_at(self.last(@heap))
			@heap=self.heapify(0,@heap)	unless @heap.size<=1
		return min
		end
  end
  
  def parent i
		if i<=2
			return 0
		else
			return i/2-1
		end
  end
  
  def left i
			2*i+1
  end

  def right i
		2*i+2
  end

  def last heap
    unless heap.size==0
			return heap.size-1
		else
			return 0
		end
  end

	def freq(i,heap)
		if i<heap.length
			freq=heap.fetch(i)
			return freq.freq
		else
				raise "error!"
		end
	end

	def size
		@heap.size
	end

end