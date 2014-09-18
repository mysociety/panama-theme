# Here you can override or add to the pages in the core website

Rails.application.routes.draw do
    scope '/profile' do
        match '/change_phone_number' => 'user#signchangephone', :as => :signchangephone
        match '/change_address' => 'user#signchangeaddress', :as => :signchangeaddress
        match '/change_national_id' => 'user#signchangenationalid', :as => :signchangenationalid
        match '/change_company_name' => 'user#signchangecompanyname', :as => :signchangecompanyname
        match '/change_company_number' => 'user#signchangecompanynumber', :as => :signchangecompanynumber
        match '/change_incorporation_date' => 'user#signchangecompanyincdate', :as => :signchangeincdate
    end

    match '/help/transparency' => 'help#transparency', :as => :help_transparency
    match '/help/legal_support' => 'help#legal_support', :as => :help_legal_support
    match '/help/faq' => 'help#faq', :as => :help_faq

    scope '/admin' do
        match '/stats/monthly_transactions_csv' => 'admin_general#stats_monthly_transactions_csv', :as => :admin_stats_monthly_transactions_csv
    end
end
