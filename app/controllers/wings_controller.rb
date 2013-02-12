class WingsController < InheritedResources::Base
  before_filter :check_auth, :except => [:index, :show]
end
