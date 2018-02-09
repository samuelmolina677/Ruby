require 'selenium-webdriver'
class SiteElement

  def initialize(url, browser)
    case browser  
    when "FF"
      @driver=Selenium::WebDriver.for :firefox
    when "IE"
      @driver=Selenium::WebDriver.for :ie
    when "GC"
     current_path =File.expand_path(File.dirname(__FILE__))
      @driver=Selenium::WebDriver::Chrome.driver_path="#{current_path}/chromedriver.exe"
      @driver=Selenium::WebDriver.for :chrome
    end
    @driver.navigate.to url
    @driver.manage.delete_all_cookies
    @driver.manage.timeouts.implicit_wait = 30
    @driver.manage.window.maximize
  end
  
  def search_input()
    return findEmentVisibleById('q',10)
  end
  
  def search_icon()
    return findEmentVisibleByXpath("//*[@class='glyphicon air-icon-search']",15) 
  end
  
  def search_option_with_text(text)
    return findEmentVisibleByXpath("//*[@data-qa='search_field_dropdown']//a[contains(text(),'#{text}')]",10)
  end
  
  def freelancer_nameInList(number)
    return @driver.find_element(:xpath,"(//a[@class='freelancer-tile-name'])[#{number}]")
  end
  
  def search_results()
    x=0
    sections = Array.new
    @driver.find_elements(:xpath,"//section[@id='oContractorResults']//section[@data-qa]").each do |itemFound| 
    items = Hash.new 
      x+=1 
      print ". "
      items.store("id", x )
      @driver.find_elements(:xpath,"(//section[@id='oContractorResults']//section[@data-qa])[#{x}]//*[@data-qa]").each do |data_qa| 
        keyqa = data_qa.attribute('data-qa')
        items.store("#{keyqa}", data_qa.text )
      end
       items.store("fulldata", itemFound.text )
        sections.push(items)
    end
    puts "Done" 
    return sections
  end
  
  def findEmentVisibleByXpath(path,timeoutvar=15)
    begin 
      @wait = Selenium::WebDriver::Wait.new(:timeout => timeoutvar) # Time less than implicit
      return @wait.until {@driver.find_element(:xpath => path)}
    rescue SystemCallError
      puts "Timeout #{path} sec: element at '#{path}' not found"
      return nil
    end
  end
  
  def findEmentVisibleById(path,timeoutvar=15)
    @wait = Selenium::WebDriver::Wait.new(:timeout => timeoutvar) # Time less than implicit
    return @wait.until {@driver.find_element(:id => path)}
  end
  
  def freelancer_name()
    return findEmentVisibleByXpath(:"//div[@id='optimizely-header-container-default']//span[@itemprop='name']")
  end
  
  def freelancer_job()
    return findEmentVisibleByXpath("//div[@class='overlay-container']//h3/span")
  end
  
  def freelancer_description()
    return findEmentVisibleByXpath("//div[@class='overlay-container']//p[@itemprop='description']")
  end
  
  def close_browser()
    @driver.quit
  end
end