# -*- encoding: utf-8 -*-
require 'mechanize'
require 'pp'

num = 731
per = 30

page = num / per + 1

a = Mechanize.new

companies = []
(1..page).each do |i|
  p = a.get('http://job.rikunabi.com/2014/search/pre/internship/result/?modulecd=100&kdb=T&pn=' + i.to_s)
  companies += p.search(".g_txt_M")
end

companies.delete_if do |company|
  true if company.text.empty?
end

companies.each do |company|
  text = company.text
  text.gsub!(/株式会社/, "")
  text.gsub!(/有限会社/, "")
  text.gsub!(/【.*?】/, "")
  text.gsub!(/\(.*?\)/, "")
  text.gsub!(/（.*?）/, "")
  text.gsub!(/[.*?]/, "")
  text.gsub!(/※.*/, "")
  text.delete!(" 　")
  puts "- [#{text}](http://job.rikunabi.com/#{company[:href]})"
end
