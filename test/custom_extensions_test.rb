require 'test_helper'
require 'mocha/setup'

unless defined? Picture
  class Picture; end
end

I18n.backend.store_translations(:pl, :countries => { :pl => "Polska", :se => "Szwecja" },
                                     :editor    => { :pictures => { :not_found => "Brak obrazka" }})
I18n.locale = :pl

class SugarMarkdownRenderTest < Redcarpet::TestCase

  def sugar_markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::SugarMarkdown, tables: true, autolink: true, strikethrough: true).render(text)
  end

  def test_flag_tag
    markdown = sugar_markdown("Titta :se: pa mig!")
    html_equal "<p>Titta <img src='/img/flags/se.gif' title='Szwecja' /> pa mig!</p>\n", markdown
  end

  def test_flip_tag
    markdown = sugar_markdown("~~~ Flip title\nAnd a _content_ inside\n~~~")
    assert_match /<a class='flip' data-id='.{7,8}' href='#'>Flip title<\/a><div class='flip' id='.{7,8}'>And a <em>content<\/em> inside<br\/>\n<\/div>/, markdown
  end

  def test_multiple_flip_tags
    text = %Q{
~~~ Flip title
And a _content_ inside
~~~
~~~ Another Flip
Just below
~~~}
    markdown = sugar_markdown(text)
    assert_match /<a class='flip' data-id='.{7,8}' href='#'>Flip title<\/a><div class='flip' id='.{7,8}'>And a <em>content<\/em> inside<br\/>\n<\/div><br\/>\n<a class='flip' data-id='.{7,8}' href='#'>Another Flip<\/a><div class='flip' id='.{7,8}'>Just below<br\/>\n<\/div>/, markdown
  end

  def test_emoji_tags
    markdown = sugar_markdown("Howdy! How :cool: are you today?")
    html_equal "<p>Howdy! How <img src='/img/emoji/cool.png' class='emoji' /> are you today?</p>\n", markdown
  end

  def test_unsupported_emoji_tags
    markdown = sugar_markdown("How simple :could: it be?")
    html_equal "<p>How simple :could: it be?</p>\n", markdown
  end

  def test_youtube_video_tags
    markdown = sugar_markdown("Check this out httpv://www.youtube.com/watch?v=MnUxJyg6MCg dude")
    assert_match /<p>Check this out <iframe width='\d+' height='\d+' src='https:\/\/www.youtube.com\/embed\/MnUxJyg6MCg\?rel=0' frameborder='0' allowfullscreen><\/iframe> dude<\/p>/i, markdown
  end

  def test_generating_toc_tags
   markdown = sugar_markdown("### Entry one\n### Entry two")
   html_equal "<h3 id=\"entry-one\">Entry one</h3>\n\n<h3 id=\"entry-two\">Entry two</h3>\n", markdown
  end

  def test_centered_text
    markdown = sugar_markdown(":center:Howdy!")
    html_equal "<p class='center'>Howdy!</p>\n\n", markdown
  end

  def test_centered_images
    markdown = sugar_markdown(":center:![](www.image.com/img.jpg)")
    html_equal "<p class='center'><img src=\"www.image.com/img.jpg\" alt=\"\"/></p>\n\n", markdown
  end

  def test_centered_youtube_videos
    markdown = sugar_markdown(":center:httpv://www.youtube.com/watch?v=MnUxJyg6MCg")
    assert_match /<p class='center'><iframe width='\d+' height='\d+' src='https:\/\/www.youtube.com\/embed\/MnUxJyg6MCg\?rel=0' frameborder='0' allowfullscreen><\/iframe><\/p>/, markdown
  end

  def test_centered_markdown
    markdown = sugar_markdown(":center: :pl: **Poland!**")
    html_equal "<p class='center'> <img src='/img/flags/pl.gif' title='Polska' /> <strong>Poland!</strong></p>\n\n", markdown
  end

  def test_floated_images
    markdown = sugar_markdown(":left:![](www.image.com/img.jpg)")
    html_equal "<p class='left'><img src=\"www.image.com\/img.jpg\" alt=\"\"/></p>\n\n", markdown
  end

  def test_rendering_approved_pictures
    picture = stub('picture', approved: true,
                              name: 'Image Title',
                              attachment: stub(url: 'assets/image.png'))
    Picture.expects(:find_by_id).with(1).returns(picture)
    markdown = sugar_markdown("Image picture:1 test")
    html_equal "<p>Image <img src='assets/image.png' alt='Image Title' /> test</p>\n", markdown
  end

  def test_rendering_missing_pictures
    Picture.expects(:find_by_id).with(1).returns(nil)
    markdown = sugar_markdown("Image picture:1 test")
    html_equal "<p>Image Brak obrazka test</p>\n", markdown
  end

  def test_rendering_unapproved_pictures
    picture = stub('picture', approved: false)
    Picture.expects(:find_by_id).with(1).returns(picture)
    markdown = sugar_markdown("Image picture:1 test")
    html_equal "<p>Image <img src='/img/pending.png' /> test</p>\n", markdown
  end

  def test_multiple_mixed_tags
    text = %Q{
Welcome *to* __Americana__
Please :se: have a ~~seat~~
+++Don't be+++ alarmed
You'll be :cool:
~~~ This is secret
httpv://www.youtube.com/watch?v=MnUxJyg6MCg
~~~
}
    markdown = sugar_markdown(text)
    assert_match /<p>Welcome <em>to<\/em> <strong>Americana<\/strong><br\/>
Please <img src='\/img\/flags\/se.gif' title='Szwecja' \/> have a <del>seat<\/del><br\/>
<span class="spoiler">Don&#39;t be<\/span> alarmed<br\/>
You&#39;ll be <img src='\/img\/emoji\/cool.png' class='emoji' \/><br\/>
<a class='flip' data-id='.{7,8}' href='#'>This is secret<\/a><div class='flip' id='.{7,8}'><iframe width='\d+' height='\d+' src='https:\/\/www.youtube.com\/embed\/MnUxJyg6MCg\?rel=0' frameborder='0' allowfullscreen><\/iframe><br\/>
<\/div><\/p>/i, markdown
  end

end

class SimpleMarkdownRenderTest < Redcarpet::TestCase

  def simple_markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::SimpleMarkdown, autolink: true, strikethrough: true).render(text)
  end

  def test_rendering_code_blocks
    markdown = simple_markdown("This is some `awesome code`")
    html_equal "<p>This is some <code>awesome code</code></p>\n", markdown
  end

  def test_rendering_flag_tags
    markdown = simple_markdown("This is :pl: SPARTA!")
    html_equal "<p>This is <img src='/img/flags/pl.gif' title='Polska' /> SPARTA!</p>\n", markdown
  end

  def test_ignoring_unknown_flags
    markdown = simple_markdown("This is :qe: TEST!")
    html_equal "<p>This is :qe: TEST!</p>\n", markdown
  end

  def test_rendering_flip_tag
    markdown = simple_markdown( "This is\n~~~ Flip title\nAnd Flip Content~~~\nno go")
    assert_match /<a class='flip' data-id='.{7,8}' href='#'>Flip title<\/a><div class='flip' id='.{7,8}'>And Flip Content<\/div>/, markdown
  end

  def test_genering_proper_autolinks
    markdown = simple_markdown("Take a look at www.example.com")
    html_equal "<p>Take a look at <a href=\"http://www.example.com\" rel=\"nofollow\" target=\"_blank\">www.example.com</a></p>\n", markdown
  end

  def test_genereting_proper_links
    markdown = simple_markdown("[link](http://example.net)")
    html_equal "<p><a href=\"http://example.net\" rel=\"nofollow\" target=\"_blank\">link</a></p>\n", markdown
  end

end
