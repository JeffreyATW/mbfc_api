Rails.application.routes.draw do
  resources :sources do
    collection do
      get 'crawl'
      get 'domain/:domain', action: 'domain', constraints: { domain: /[0-z\.]+/ }
    end
  end

  resources :biases do
    collection do
      get 'crawl'
      get 'slug/:slug', action: 'slug'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
