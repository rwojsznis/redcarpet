# encoding: utf-8
module Redcarpet
  module Render
    class ChatMarkdown < CustomBase

      def initialize(options={})
        super options.merge(hard_wrap: true,
                            safe_links_only: true,
                            link_attributes: {
                              rel: :nofollow, target: '_blank'
                            })
      end

      def hrule()
        nil
      end

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