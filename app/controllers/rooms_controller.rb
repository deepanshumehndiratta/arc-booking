class RoomsController < InheritedResources::Base
  skip_before_filter :check_auth
  before_filter :check_superadmin, :except => [:index, :show]
end
