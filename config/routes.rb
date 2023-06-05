Rails.application.routes.draw do
	get '/hospitals/', to: 'hospitals#index'
	get '/hospitals/:id', to: 'hospitals#show'

	get '/departments/', to: 'departments#index'
	get '/departments/:id', to: 'departments#show'

	get '/doctors/', to: 'doctors#index'
	get '/doctors/:id', to: 'doctors#show'

	get '/specialties/', to: 'specialties#index'
	get '/specialties/:id', to: 'specialties#show'

	get '/patients/', to: 'patients#index'
	get '/patients/:id', to: 'patients#show'

	get '/patientcards/', to: 'patientcards#index'
	get '/patientcards/:id', to: 'patientcards#show'
end