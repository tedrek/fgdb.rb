class GizmoAttrsController < ApplicationController
  active_scaffold

  before_filter :authorized_only
  def authorized_only
    requires_role('ROLE_ADMIN')
  end
end
