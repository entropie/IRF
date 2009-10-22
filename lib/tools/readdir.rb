#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#


module IRF


  module ReadDir
    
    def read_dir(dir, &blk)
      Dir.chdir(dir){
        Dir["*"].each do |folder|
          unless File.directory?(folder)
            yield File.expand_path(folder)
          else
            read_dir(folder, &blk)
          end
        end
      }
    end

  end


end


=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
