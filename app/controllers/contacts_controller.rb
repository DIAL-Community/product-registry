class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    if params[:without_paging]
      @locations = Location
          .starts_with(params[:search])
          .order(:name)
      return
    end

    if params[:search]
      @contacts = Contact
          .where(nil)
          .starts_with(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @contacts = Contact
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @contact.organizations.push(@organization)
    end
  end

  # GET /contacts/1/edit
  def edit
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @contact.organizations.push(organization)
      end
    end

    can_be_saved = @contact.can_be_saved?
    if (!params[:confirmation].nil?)
      size = Contact.slug_contains(@contact.slug).size
      @contact.slug = @contact.slug + '_' + size.to_s
      can_be_saved = true
    end

    respond_to do |format|
      if can_be_saved && @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    if (params[:selected_organizations])
      organizations = Set.new
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
      @contact.organizations = organizations.to_a
    end

    can_be_saved = @contact.can_be_saved?
    if (!params[:confirmation].nil?)
      size = Contact.slug_contains(@contact.slug).size
      @contact.slug = @contact.slug + '_' + size.to_s
      can_be_saved = true
    end

    respond_to do |format|
      if can_be_saved && @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params
        .require(:contact)
        .permit(:name, :email, :title, :selected_organizations, :confirmation)
        .tap do |attr|
          if (attr[:name].present?)
            attr[:slug] = slug_em(attr[:name])
          end
        end
    end
end
