# XHTML Renderer
module Redcarpet
  module Render
    class XHTML < HTML
      def initialize(extensions={})
        super(extensions.merge(:xhtml => true))
      end
    end
  end
end