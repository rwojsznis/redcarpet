# encoding: utf-8

module Redcarpet
  module Render
    class SugarMarkdown < CustomMarkdown

      def initialize(options={})
        super options.merge(hard_wrap: true, link_attributes: { target: '_blank' }, with_toc_data: true)
      end

      def preprocess(full_document)
        text = picturify full_document
        super(text)
      end

      def postprocess(full_document)
        customize full_document
      end

      # Link pictures uploaded by users
      # Requires picture class that will store uploaded pictures
      # Note: picture must have approved method/column
      def picturify(text)
        text.gsub(/picture:(\d+)/) do |match|
          picture = Picture.find_by_id($1.to_i)
          if picture && picture.approved
            "<img src='#{picture.attachment.url}' alt='#{picture.name}' />"
          elsif picture
            "<img src='/img/pending.png' />"
          else
            I18n.t('editor.pictures.not_found')
          end
        end
      end

      # Handle custom simple tags (applied per paragraph)
      def customize(text)
        text.gsub(/<p>:center:(.*)<\/p>/) do |match|
          "<p class='center'>#{$1}</p>\n"
        end.gsub(/<p>:right:(.*)<\/p>/) do |match|
          "<p class='right'>#{$1}</p>\n"
        end.gsub(/<p>:left:(.*)<\/p>/) do |match|
          "<p class='left'>#{$1}</p>\n"
        end
      end

    end
  end
end