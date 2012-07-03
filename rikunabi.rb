# -*- encoding: utf-8 -*-
require 'mechanize'
require 'pp'

num = 668
per = 30

page = num / per + 1

a = Mechanize.new

companies = []
(1..page).each do |i|
  p = a.get('http://job.rikunabi.com/2014/search/pre/internship/result/?modulecd=100&kdb=T&pn=' + i.to_s)
  companies += p.search(".g_txt_M").map{|l| l.text }
end

companies.delete("")

companies.map do |i|
  i.sub!(/株式会社/, "")
  i.sub!(/有限会社/, "")
  i.gsub!(/【.*?】/, "")
  i.gsub!(/\(.*?\)/, "")
  i.gsub!(/（.*?）/, "")
  i.gsub!(/※.*/, "")
  i.delete!(" 　")
end

print companies.join("\n")
