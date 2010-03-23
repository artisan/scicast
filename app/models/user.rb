class User < ActiveRecord::Base
  
  WhereFrom = HoboFields::EnumString.for(:planet_science,
                                         :institute_of_physics,
                                         :local_authority,
                                         :gratnells,
                                         :exhibition,
                                         :recommendation,
                                         :other,
                                         :dont_know)

  hobo_user_model # Don't put anything above this

  fields do
    name  :string, :required, :unique
    email :email_address, :login => true
    
    postcode    :string, :required
    institution :string, :required

    how_did_you_hear_about_us WhereFrom
    
    first_time enum_string(:yes, :no)
    feedback :text
    
    administrator :boolean, :default => false
    timestamps
  end

  # This gives admin rights to the first sign-up.
  # Just remove it if you don't want that
  before_create { |user| user.administrator = true if !Rails.env.test? && count == 0 }
  
  attr_accessor :film_title, :team_name, :type => :string
  attr_accessor :film_description, :team_info, :type => :text
  attr_accessor :production_date, :type => :date
  attr_accessor :file
  attr_accessor :license, :type => HoboFields::EnumString.for(:cc_by, :cc_by_nc_sa)
  
  attr_accessor :post_film, :type => :boolean
  
  validates_presence_of :film_title, :film_description,
                        :team_name, :team_info, :production_date, :license, :on => :update
                        
  has_many :films
  
  after_create :create_film
  
  include Geocode
  
  # --- Signup lifecycle --- #

  lifecycle do

    state :inactive, :default => true
    state :active

    create :signup, :available_to => "Guest",
           :params => [:name, :email, :postcode, :institution,
                       :first_time, :how_did_you_hear_about_us, :feedback,
                       :password, :password_confirmation],
           :new_key => true,
           :become => :inactive do
      UserMailer.deliver_activation(self, lifecycle.key) 
    end
    
    transition :activate, { :inactive => :active }, :available_to => :key_holder,
               :params => [ :post_film, :film_title, :film_description, :production_date, :license, :team_name, :team_info] do
      film = films.first
      film.update_attributes :title => film_title, :description => film_description, :movie => file,
                             :team_name => team_name, :team_info => team_info,
                             :production_date => production_date,
                             :license => license, :submit_by_post => post_film
      film.save!                           
    end
         
    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.deliver_forgot_password(self, lifecycle.key)
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end

  def create_film
    films.create!
  end
  

  # --- Permissions --- #

  def create_permitted?
    false
  end

  def update_permitted?
    acting_user.administrator? or
      (acting_user == self || lifecycle.valid_key?) && 
      only_changed?(:email, :post_film, :film_title, :film_description, :production_date, :license, :team_name, :team_info,
                    :crypted_password, :current_password, :password, :password_confirmation)
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    new_record? or
     acting_user.administrator? or
     acting_user == self or
     lifecycle.valid_key? && (
       field.in?([:film_title, :film_description, :production_date, :license, :team_name, :team_info]) or
       !(films.first && films.first.movie.file?) && field == :post_film
     )
  end

end
