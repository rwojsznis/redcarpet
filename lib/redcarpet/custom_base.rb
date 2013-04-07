# encoding: utf-8
module Redcarpet
  module Render
    class CustomBase < XHTML
      extend CustomContent

      # Spoiler tag for movies subforum
      # Usage:
      # This is some text +++ and here's my spoiler +++ that is inline
      # Also I can write something
      # +++
      # Like that, inside a block!
      # +++
      def spoiler_tag(text)
        text.gsub(/\+{3}\n?(.+?(?=\+{3}))\+{3}/im, '<span class="spoiler">\1</span>')
      end

      # Display flag
      # :en: England
      # :se: Sweden
      def flagify(text)
        codes = self.class.flags.keys.map { |k| ":#{k.to_s}:"}. join("|")
        text.gsub(/(#{codes}\s)/) do |m|
          flag = $1.gsub(":","")
          filename = "/img/flags/#{flag}.gif"
          "<img src='#{filename}' title='#{self.class.flags.fetch(flag.to_sym)}' />"
        end
      end

      # Javascript powered flip tags
      #
      # ~~~ This is idea for *flip*
      # This is flip content
      #
      # That can have _some_ various formatting
      # ~~~
      #
      # Flip just ended
      def flipify(text)
        text.gsub(/~{3}\s?([^\n]+)\n(.+?(?=~{3}))~{3}/mi) do
          id = rand(36**8).to_s(36)
          content = $2 # stripping last new line breaks youtube frame
          "<a class='flip' data-id='#{id}' href='#'>#{$1.strip}</a><div class='flip' id='#{id}'>#{content}</div>"
        end
      end

      # Put emoji icon
      def emojify(text)
        text.gsub(/:([a-z0-9\+\-_]+):/) do |match|
          if self.class.emoji.include?($1)
            "<img src='/img/emoji/#{$1}.png' class='emoji' />"
          else
            match
          end
        end
      end

      # Make embedded youtube videos using httpv:// link
      # In the future we should probably customize it a little bit
      # And add support for various video sites
      def youtubify(text)
        text.gsub(/(httpv:\/\/[\w\d.\/?=&-]+)/) do |match|
          video = $1.gsub('httpv', 'http').gsub('watch?v=', 'embed/').strip
          "<iframe width='480' height='360' src='#{video}?rel=0' frameborder='0' allowfullscreen></iframe>"
        end
      end

    end
  end
end
