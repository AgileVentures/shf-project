require 'sanitize'

class InputSanitizer

  def self.sanitize_url(url='')
    return '' if url.blank?

    Sanitize.fragment(url.gsub(/javascript/,''), Sanitize::Config::RESTRICTED)
  end

  def self.sanitize_html(html='')
    # "relaxed" setting accomodates all input that the use can create by
    # using the available menu options in our Ckeditor configuration.
    # This also strips out unwanted code the user might enter in "source" mode.
    return '' if html.blank?

    Sanitize.fragment(html, Sanitize::Config::RELAXED)
  end

end
