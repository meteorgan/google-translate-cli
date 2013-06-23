#!/usr/bin/env ruby

require "open-uri"
require "json"

def translate(args)
	parameters = parse_parameters(args)
	sl = parameters["sl"]
	tls = parameters["tls"]
	texts = parameters["texts"]

	tls.each do |tl|
		texts.each do |text|
			if File.exist?(text)
				File.open(text, "r") do |f|
					f.each do |line|
						translate_sentence(sl, tl, line)
					end
				end
			else
				translate_sentence(sl, tl, text)
			end
		end
	end
end

def parse_parameters(args)
	if args[0] =~ /{.*=.*}/
		matches = args[0].match(/{(.*)=(.*)}/)
		sl = matches[1]
		tls = matches[2].split("+")
		if sl == ""
			sl = "auto"
		end
		if tls.length == 0
			tls = ["en"]
		end
		texts = args[1..-1]
	else
		sl = "auto"
		tls = ["en"]
		texts = args
	end

	return Hash["sl"=>sl, "tls"=>tls, "texts"=>texts]
end

def translate_sentence(sl, tl, text)
	target = ""
	if text =~ /^\s+$/
		target << text
	else
		encode_text = URI::encode(text)
		query = "http://translate.google.cn/translate_a/t?client=p&hl=en&sl=#{sl}&tl=#{tl}&ie=UTF-8&oe=UTF-8&q=#{encode_text}"
		request = URI(query)
		response = request.read
		result = JSON.parse response
		sentences = result["sentences"]
		for sentence in sentences
			target << sentence["trans"]
		end
	end
	puts target
end

def help
	puts "Usage: translate {[SL]=[TL]} TEXT|TEXT_FILENAME"
	puts "       translate {[SL]=[TL1+TL2+TL3...]} TEXT|TEXT_FILENAME"
	puts "       translate TEXT1 TEXT2 TEXT3"
	puts "TEXT: source text(the text to be translated)"
	puts "      also can be the filename of a plain text file"
	puts "  SL: source language(the language of source text), the default SL is auto-detected."
	puts "  TL: target language(the language to translate the source text to), the default TL is English"
end


if $0 == __FILE__
	if ARGV.length < 1
		help
	else
		translate(ARGV)
	end
end
