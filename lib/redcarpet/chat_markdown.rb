# encoding: utf-8
module Redcarpet
  module Render
    class ChatMarkdown < CustomBase
      include SimpleBase

      def header(text, header_level)
        "<p>#{text}</p>"
      end

      def block_code(code, language)
        "<p>#{code}</p>"
      end

      def list(contents, list_type)
        "<p>#{contents}</p>"
      end

      def  list_item(text, list_type)
        text
      end

      def block_quote(quote)
        quote
      end

      def preprocess(full_document)
        emojify(full_document)
      end

    end
  end
end