Then("I should see the GeoTrust SSL certificate Image") do
  expect(page).to have_xpath("//img[contains(@src,'RapidSSL_SEAL-90x50')]")
end