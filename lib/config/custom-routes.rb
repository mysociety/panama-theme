# Here you can override or add to the pages in the core website

Rails.application.routes.draw do
    # Requests stats page
    match '/request_statistics' => 'general#request_statistics'
end
