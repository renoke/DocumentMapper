Given /^I have a couchdb connexion$/ do
  FlatDoc.setup(:adapter => 'couchdb', :database=>"http://127.0.0.1:5984/flatdoc-test")
end

Given /^a Bill mapper$/ do
  class Bill < FlatDoc::Mash
  end
end

Given /^(d+) created bills$/ do |many|
  many.times do |i|
    Bill.create(:type => 'Bill', :number=>i)
  end
end

