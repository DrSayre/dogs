class Message
  def self.send_sms(number, text, dog_pictures)
    pictures = S3_BUCKET.objects.map{ |object| "https://s3.us-east-2.amazonaws.com/drsayre-dog-pictures/#{object.key}" }
    @twilio_client = Twilio::REST::Client.new $twilio_sid, $twilio_token

    foo = @twilio_client.account.messages.create(
      from: $twilio_phone_number,
      to: number,
      body: text,
      media_url: pictures.sample(dog_pictures)
    )
  end
end
