class Admin::CommentsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions_for :film, [:create]

end
