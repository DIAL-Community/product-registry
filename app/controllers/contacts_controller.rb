class ContactsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    if params[:without_paging]
      @contacts = Contact
          .name_contains(params[:search])
          .order(:name)
      authorize @contacts, :view_allowed?
      return
    end

    if params[:search]
      @contacts = Contact
          .where(nil)
          .name_contains(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
      authorize @contacts, :view_allowed?
    else
      @contacts = Contact
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
      authorize @contacts, :view_allowed?
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    authorize @contact, :view_allowed?
  end

  # GET /contacts/new
  def new
    authorize Contact, :mod_allowed?
    @contact = Contact.new
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @contact.organizations.push(@organization)
    end
  end

  # GET /contacts/1/edit
  def edit
    authorize @contact, :mod_allowed?
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    authorize Contact, :mod_allowed?
    @contact = Contact.new(contact_params)
    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @contact.organizations.push(organization)
      end
    end

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, flash: { notice: 'Contact was successfully created.' }}
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
    authorize @contact, :mod_allowed?
    if (params[:selected_organizations])
      organizations = Set.new
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
      @contact.organizations = organizations.to_a
    end

    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, flash: { notice: 'Contact was successfully updated.' }}
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, :locals => { :contact => @contact } }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    authorize @contact, :mod_allowed?
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, flash: { notice: 'Contact was successfully destroyed.' }}
      format.json { head :no_content }
    end
  end

  def duplicates
    @contacts = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @contacts = Contact.where(slug: current_slug).to_a
      end
    end
    authorize @contacts, :view_allowed?
    render json: @contacts, :only => [:name, :title]
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
        .permit(:name, :email, :title, :selected_organizations, :duplicate, :reslug)
        .tap do |attr|
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = Contact.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
