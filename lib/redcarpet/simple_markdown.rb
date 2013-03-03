# encoding: utf-8

module Redcarpet
  module Render
    class SimpleMarkdown < CustomMarkdown

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
        text
      end

    end
  end
end