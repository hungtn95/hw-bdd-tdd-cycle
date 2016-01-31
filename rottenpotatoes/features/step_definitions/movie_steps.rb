# Add a declarative step here for populating the DB with movies.
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body).to have_content(/.*#{e1}.*#{e2}/m)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck == "un" then
    for rating in rating_list.split(", ")
      uncheck("ratings[#{rating}]")
    end
  end
  if uncheck == nil then
    for rating in rating_list.split(", ")
      check("ratings[#{rating}]")
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  page.all("#movies tr").count.should == Movie.count + 1
end

When /^I go to (.*?)$/ do |page_name|
  visit path_to(page_name)
end

And /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in(field, :with => value)
end

And /^I press "(.*?)"$/ do |button|
  click_button(button)
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |title, director|
  expect(page.body).to have_content(/Directed by: #{director}/)
end

Given /^I am on (.*?)$/ do |page_name|
  visit path_to(page_name)
end

When /^I follow "(.*?)"$/ do |link|
  click_link(link)
end

Then /^I should be on (.*?)$/ do |page_name|
  visit path_to(page_name)
end

And /^I should see "(.*?)"$/ do |title|
  expect(page).to have_content(title)
end

But /^I should not see "(.*?)"$/ do |title|
  expect(page).to have_no_content(title)
end
