require 'api_constraints'

Fgdb::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v0, constraints: ApiConstraints.new(version: 0, default: true) do
      resources :drives
    end
  end

  resources :gizmo_type_groups
  resources :users
  resource :session
  match '/' => 'sidebar_links#index'
  match '/:controller(/:action(/:id))'
  match 'barcode/:id.:format' => 'barcode#barcode'
  match 'todo' => 'sidebar_links#todo_moved'
  match 'mail' => 'sidebar_links#mail_moved'
  match 'deadtrees' => 'sidebar_links#deadtrees_moved'
  match 'dead trees' => 'sidebar_links#deadtrees_moved'
  match 'supplies' => 'sidebar_links#supplies_moved'
  match 'recent_crash' => 'sidebar_links#recent_crash'
  match 'staffsched' => 'work_shifts#staffsched'
  match 'schedule' => 'work_shifts#staffsched'
  match 'staff_sched' => 'work_shifts#staffsched'
  match 'staffschedule' => 'work_shifts#staffsched'
  match 'worksched' => 'work_shifts#staffsched'
  match 'build' => 'spec_sheets#index'
end
