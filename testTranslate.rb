#!/usr/bin/env ruby
require "./translate"
require "test/unit"

class TestTranslate < Test::Unit::TestCase
	def test_parse_parameters
		testCases = [
			[Hash["sl"=>"zh-CN", "tls"=>["en"], "texts"=>[]], ["{zh-CN=en}"]],
			[Hash["sl"=>"zh-CN", "tls"=>["en", "eo", "jp"], "texts"=>["hello", "what is this"]], ["{zh-CN=en+eo+jp}", "hello", "what is this"]],
			[Hash["sl"=>"auto", "tls"=>["en"], "texts"=>[]], ["{=en}"]],
			[Hash["sl"=>"en", "tls"=>["en"], "texts"=>[]], ["{en=}"]],
			[Hash["sl"=>"auto", "tls"=>["en"], "texts"=>["how are you", "fine"]], ["how are you", "fine"]]
		]

		for result, parameters in testCases
			assert_equal(result, parse_parameters(parameters))
		end
	end
end
