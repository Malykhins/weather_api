Rails.application.routes.draw do
  mount V1::Weather, at: '/'
end
