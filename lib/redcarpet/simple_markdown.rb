# encoding: utf-8
module Redcarpet
  module Render
    class SimpleMarkdown < CustomMarkdown
      include SimpleBase

      def header(text, header_level)
        text
      end

    end
  end
end