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
      attr_accessor :left,:right
			def initialize *args
        case args.size
				when 0
					@left=nil
					@right=nil
					super(0)
				when 1
						@left=args[0]
						@right=nil
						super(@left.freq)
				when 2
						@left = args[0]
						@right = args[1]
						super(@left.freq+@right.freq)
					else
						raise "wrong intializing"
				end

				def left left
					@left=left
				end

				def right right
					@right=@right
				end

				def get_left
					@left
				end

				def get_right
					@right
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
