#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require "rubygems"
require "haml"
require "haml/exec"

require File.join(File.dirname(File.expand_path(__FILE__)), 'irf.rb')

module IRF

  class Hamlizer

    include ReadDir

    attr_reader :spool

    def spool
      @spool ||= []
    end

    def initialize(argv = [], opts = {}, &blk)
      @opts = opts
      @argv = argv
      instance_eval(&blk)
    end

    
    def hamlize(path)
      read_dir(path) do |file|
        spool << file if File.extname(file) =~ /\.(haml|sass)$/
      end
    end


    def filename_for(file)
      ret = file.dup.gsub(/\.haml$/, ".html")
      ret.gsub!(/\.css$/, ".css")
      ret
    end


    def class_for(file)
      cmd = @argv.dup << file
      cmd << filename_for(file)
      clz =
        case File.extname(file)
        when ".sass":  Haml::Exec::Sass
        when ".haml":  Haml::Exec::Haml
        end
      ret = clz.new(cmd)
      ret
    end


    def start
      spool.each do |file|
        puts " #{File.basename(file)} -> #{filename_for(file)}"
        class_for(file).parse!
      end
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
