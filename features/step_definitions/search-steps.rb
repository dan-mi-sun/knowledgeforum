Given(/^a post about "(.*?)"$/) do |title|
  @post = Post.create!(:title => title)
end

Given(/^assuming the Sphinx index is up to date$/) do
  ThinkingSphinx::Test.start_with_autostop
end

Given(/^I am on the homepage$/) do
  visit posts_path
end

When(/^I search for "(.*?)"$/) do |title|
  fill_in('Search', :with => title)
end

Then(/^I should see a post about "(.*?)"$/) do |title|
  expect(has_content?("title")).to be_true
end

