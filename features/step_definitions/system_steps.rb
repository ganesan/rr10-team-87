Given /^it is within the dating hours$/ do
  #TODO
end

Then /^there should be a meetup founded by "([^"]*)" that is "([^"]*)"$/ do |founder_phone, meetup_state|
  user = User.find_by_phone_number(founder_phone)
  user.founded_meetups.detect { |meetup| meetup.state == meetup_state }.should be
end

