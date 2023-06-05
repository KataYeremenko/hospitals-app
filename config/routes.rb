Rails.application.routes.draw do
  resources :hospitals
  
  resources :departments

  resources :doctors

  resources :patients

  resources :patient_cards

  resources :specialties
end