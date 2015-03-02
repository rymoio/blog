#!/usr/bin/env ruby

# Use this script to automatically submit a valid sitemap file to
# the Google Webmaster Tools endpoint.
#
# @params {String}: sitemap_url


require "CGI"
require "net/http"

# COLORS
cClear = "\033[0m"  # base
cFail = "\033[37;41m"  # red;bold
cSuccess = "\033[32;1m"  # green;bold
cWarning = "\033[33m"  # yellow
cInfo = "\033[34m"  # blue
cUrl = "\033[35;4m"  # purple;underline
cMisc = "\033[36;3m"  # cyan;italic

# GET ARGV
if ARGV[0]
  sitemap_url = ARGV[0]
else
  puts "A #{cInfo}sitemap url#{cClear} is a #{cFail}required#{cClear} argument!\n\n"
  exit
end

# URLS
base_url = "http://www.google.com/webmasters/tools/ping?sitemap="
webmaster_url = "https://www.google.com/webmasters/tools"

url = URI(base_url + CGI.escape(sitemap_url))

puts "Updating sitemap on Webmaster Tools...\n\n"

res = Net::HTTP.get_response(url)
code = res.code

case res
when Net::HTTPSuccess
  puts "#{cUrl}#{sitemap_url}#{cClear} was submitted #{cSuccess}successfully#{cClear}!\n\n"
else
  print "#{cUrl}#{sitemap_url}#{cClear} submit #{cFail}failed#{cClear} with code #{cWarning}#{code}#{cClear}.\n\n"

  a = [3, 2, 1]
  a.each {
    |n| puts "\t\tretrying in #{cMisc}" + n.to_s + " second" + (n == 1 ? "" : "s") + "#{cClear}..."
    sleep(1)
  }

  puts "\n"

  res2 = Net::HTTP.get_response(url)
  code2 = res2.code

  case res2
  when Net::HTTPSuccess
    puts "#{cUrl}#{sitemap_url}#{cClear} was re-submitted #{cSuccess}successfully#{cClear}!\n\n"
  else
    puts "#{cUrl}#{sitemap_url}#{cClear} re-submit #{cFail}failed#{cClear} again with code #{cWarning}#{code}#{cClear}.\n\n"
    puts "\nTry re-submitting manually via Webmaster Tools at #{cInfo}#{webmaster_url}#{cClear}.\n"
  end
end