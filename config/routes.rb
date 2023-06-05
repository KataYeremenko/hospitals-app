Rails.application.routes.draw do
  get '/', to: 'mainpage#index'

  get 'hospitals/search', to: 'hospitals#search', as: 'hospitals_search'
  get 'hospitals/download_csv', to: 'hospitals#download_csv', as: 'hospitals_download_csv'
  get 'hospitals/download_pdf', to: 'hospitals#download_pdf', as: 'hospitals_download_pdf'
  get 'hospitals/:id/download_pdf/', to: 'hospitals#download_pdf_with_id', as: 'hospitals_download_pdf_with_id'
  get 'users/download_pdf/', to: 'mainpage#download_pdf', as: 'users_download_pdf'
  get 'hospitals/:id/searchshow', to: 'hospitals#searchshow', as: 'hospitals_search_show'
  get 'departments/search', to: 'departments#search', as: 'departments_search'
  get 'doctors/search', to: 'doctors#search', as: 'doctors_search'
  get 'specialties/search', to: 'specialties#search', as: 'specialties_search'
  get 'patient_cards/search', to: 'patient_cards#search', as: 'patient_cards_search'
  get 'patients/search', to: 'patients#search', as: 'patients_search'

  root 'mainpage#index'

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :hospitals do
    resources :departments
  end

  resources :departments do
    resources :doctors
  end

  resources :departments do
    resources :patient_cards
  end

  resources :patient_cards

  resources :patients

  resources :doctors do
    resources :specialties
  end

  resources :specialties
end