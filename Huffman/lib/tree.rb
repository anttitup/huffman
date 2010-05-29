# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Tree
    class Tree 
     attr_accessor :freq
      def initialize freq=0
        @freq = freq
      end
      
      def minus(tree)
				@freq -tree.freq
      end
		end

    class Node < Tree
      attr_accessor :vasen,:oikea

			def initialize *args
        case args.size
				when 0
					@vasen=nil
					@oikea=nil
					super(0)
				when 1
						@vasen=args[0]
						@oikea=nil
						super(@vasen.freq)
				when 2
						@vasen = args[0]
						@oikea = args[1]
						super(@vasen.freq+@oikea.freq)
					else
						raise "wrong intializing"
				end
			end

		end

    class Leaf < Tree
      attr_accessor :charechter,:freq

			def initialize char_val,freq
        @charechter = char_val
        super freq
      end

    end
    
end
