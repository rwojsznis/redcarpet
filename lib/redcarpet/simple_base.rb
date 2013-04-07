module Redcarpet
  module Render
    module SimpleBase

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

    end
  end
end