class CrawlersController < ApplicationController

  # def create
  #   # STARTER CODE FOR SIDEKIQ
  #   # @crawler = Crawler.new
  #   # CrawlerWorker.perform_in(4.hour@crawler.id)

  #   # VARIABLES WE NEED TO PASS INTO THE URI, WILL COME FROM SELECTORS ON QUEUE VIEWS
  #   restaurants = ["bourbon-steak-san-francisco"]
  #   dates = ["2015-04-04"]
  #   times = ["2122"]
  #   covers = ["2"]

  #   # URI WE ARE USING TO HIT OPEN TABLE
  #   url = "http://www.opentable.com/#{restaurants}?DateTime=#{dates}%#{times}&Covers=#{covers}"

  #   # NOKOGIRI METHOD; WILL RETURN AVAILABLE TIMES AT THE SPECIFIED RESTAURANT AS A STRING
  #   doc = Nokogiri::HTML(open(url))
  #   times = doc.css("a.dtp-button.button").text.split(" PM")
  #   times.each do |time|
  #     puts time.delete(" ").to_s
  #   end

  #   # REMAINING WORK
  #   # 1 – Merge times and dates into a hash
  #   # 2 - Run validations of available resturant times against user's requests (should this be in this controller or should we do it in another controller?)
  # end

  def run
    Crawler.crawler_check
    redirect_to login_path
  end


end
