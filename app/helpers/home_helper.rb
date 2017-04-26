module HomeHelper
  def price(number_of_pictures)
    return 100 if number_of_pictures == 3
    return 200 if number_of_pictures == 6
    300
  end
end
