#
# Author: Alejandra Estanislao
# Based on the Internet Chuck Norris Data Base API (www.icndb.com)
#
# Example usage: {% chucknorris %}
#

require 'json'

module Jekyll
  class ChuckNorris < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      count = JSON.parse(Net::HTTP.get(URI.parse("http://api.icndb.com/jokes/count")))["value"]
      @jokes = Net::HTTP.get(URI.parse("http://api.icndb.com/jokes/random/#{count}")).to_json
      # Other possible requests:
      # Get only some categories
      # @jokes = Net::HTTP.get(URI.parse("http://api.icndb.com/jokes/random/#{count}?limitTo=[nerdy]")).to_json
      # Get all categories except some
      # @jokes = Net::HTTP.get(URI.parse("http://api.icndb.com/jokes/random/#{count}?exclude=[explicit]")).to_json
      # For more information, visit http://www.icndb.com/api/
    end

    def render(context)
      if @jokes.length > 0
        "<p id=\"chuck_norris\"></p>
        <script text=\"javascript\">
          jokes = JSON.parse(#{@jokes})[\"value\"]
          joke = jokes[Math.floor(Math.random()*jokes.length)][\"joke\"]
          document.getElementById(\"chuck_norris\").innerHTML = joke
        </script>"
      else
        "Error getting Chuck Norris joke."
      end
    end
  end
end

Liquid::Template.register_tag('chucknorris', Jekyll::ChuckNorris)
