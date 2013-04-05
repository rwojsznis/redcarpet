module Redcarpet
  module Render
    class CustomMarkdown < CustomBase

      # custom tags post processing
      def preprocess(full_document)
        text = spoiler_tag(full_document)
        text = flagify(text)
        text = flipify(text)
        text = emojify(text)
        text = youtubify(text)
        text
      end

    end
  end
end
