# -*- encoding: utf-8 -*-
require 'mechanize'
require 'pp'

num = 738
per = 30

page = num / per + 1

first_url = "http://job.mynavi.jp/14/pc/corpinfo/searchCorpListByIs/index?actionMode=entry"

a = Mechanize.new

p = nil
companies = []
(1..page).each do |i|
  if (i == 1)
    p = a.get(first_url)
  else
    p = p.form_with(:name => 'corpinfo_searchCorpListByIsActionForm') do |f|
      f.pageNo = i
    end.submit
  end
  companies += p.search(".boxSearchresultEach h3 a")
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
  text.gsub!(/\[.*?\]/, "")
  text.gsub!(/<.*?>/, "")
  text.gsub!(/＜.*?＞/, "")
  text.gsub!(/[(（].*?[)）]/, "")
  text.gsub!(/［.*?］/, "")
  text.gsub!(/※.*/, "")
  text.delete!(" 　")
  puts "- [#{text}](http://job.mynavi.jp#{company[:href]})"
end
