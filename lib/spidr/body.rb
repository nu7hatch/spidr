require 'nokogiri'

module Spidr
  module Body
    #
    # The body of the response.
    #
    # @return [String]
    #   The body of the response.
    #
    def body
      (response.body || '')
    end

    #
    # Returns a parsed document object for HTML, XML, RSS and Atom pages.
    #
    # @return [Nokogiri::HTML::Document, Nokogiri::XML::Document, nil]
    #   The document that represents HTML or XML pages.
    #   Returns `nil` if the page is neither HTML, XML, RSS, Atom or if
    #   the page could not be parsed properly.
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Document.html
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/HTML/Document.html
    #
    def doc
      return nil if body.empty?

      begin
        if html?
          return @doc ||= Nokogiri::HTML(body)
        elsif (xml? || xsl? || rss? || atom?)
          return @doc ||= Nokogiri::XML(body)
        end
      rescue
        return nil
      end
    end

    #
    # Searches the document for XPath or CSS Path paths.
    #
    # @param [Array<String>] paths
    #   CSS or XPath expressions to search the document with.
    #
    # @return [Array]
    #   The matched nodes from the document.
    #   Returns an empty Array if no nodes were matched, or if the page
    #   is not an HTML or XML document.
    #
    # @example
    #   page.search('//a[@href]')
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Node.html#M000239
    #
    def search(*paths)
      if doc
        doc.search(*paths)
      else
        []
      end
    end

    #
    # Searches for the first occurrence an XPath or CSS Path expression.
    #
    # @return [Nokogiri::HTML::Node, Nokogiri::XML::Node, nil]
    #   The first matched node. Returns `nil` if no nodes could be matched,
    #   or if the page is not a HTML or XML document.
    #
    # @example
    #   page.at('//title')
    #
    # @see http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Node.html#M000251
    #
    def at(*arguments)
      if doc
        doc.at(*arguments)
      end
    end

    alias / search
    alias % at

    #
    # The title of the HTML page.
    #
    # @return [String]
    #   The inner-text of the title element of the page.
    #
    def title
      if (node = at('//title'))
        node.inner_text
      end
    end
  end
end
