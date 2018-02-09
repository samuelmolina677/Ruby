require_relative 'upwork_elements.rb'
keyword = "Selenium"
puts "Step 1: Given I open browser with the URL https://www.upwork.com/"
browser=SiteElement.new("https://www.upwork.com/", "FF")
unless browser.search_icon.nil?
  puts "Passed" 
else 
  puts "Failed"
end

puts "Step 2: Given a keyword is typed in the search of the header"
browser.search_input.send_keys(keyword)
sleep 1
browser.search_icon.click
puts "Step 3: And search icon is clicked"  
sleep 1
puts "Step 4: And search option with a defined text (freelancer) is selected"
browser.search_option_with_text('freelancer').click

puts "Step 5: And the search process is submitted by pressing Enter Key"
browser.search_input.send_keys :return
sleep 10

puts "Step 6: And the search results are stored"
data_found = browser.search_results

puts "Step 7: And Each search result should contain <keyword>"
for i in 0..data_found.count - 1
  if data_found[i]["fulldata"].include? keyword
    puts "Keyword found in the freelancer data #{i+1}" 
  else 
    puts "Keyword not found in the freelancer data #{i+1}" 
  end
end
FrelancerNumberToBeTested = (0..data_found.count - 1).to_a.sample
puts FrelancerNumberToBeTested
puts "Step 8: And a random freelancer(#{(FrelancerNumberToBeTested)+1}) name is clicked"
browser.freelancer_nameInList((FrelancerNumberToBeTested)+1).click

puts "Step 9: The I Verify that each attribute value is equal to one of those stored"

unless browser.freelancer_description.nil? && browser.freelancer_name.nil? && browser.freelancer_job.nil?
  if browser.freelancer_name.text == data_found[FrelancerNumberToBeTested]["tile_name"] && browser.freelancer_job.text == data_found[FrelancerNumberToBeTested]["tile_title"] 
    puts "Passed" 
    if browser.freelancer_description.text.include? data_found[FrelancerNumberToBeTested]["tile_description"]
      puts "Passed" 
    else
      puts "Failed"
    end
    
  else
    puts "Failed"
  end
else 
  puts "Failed. This is not normal freelancer"
end

browser.close_browser 