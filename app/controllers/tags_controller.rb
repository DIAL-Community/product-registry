class TagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    if params[:without_paging]
      @tags = Tag.order(:name)
      !params[:search].blank? && @tags = @tags.name_contains(params[:search])
      authorize @tags, :view_allowed?
      return @tags
    end

    current_page = params[:page] || 1

    if params[:search]
      @tags = Tag.name_contains(params[:search])
                 .order(:name)
                 .paginate(page: current_page, per_page: 20)
    else
      @tags = Tag.order(:name)
                 .paginate(page: current_page, per_page: 20)
    end
    authorize @tags, :view_allowed?
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    authorize(@tag, :view_allowed?)
  end

  # GET /tags/new
  def new
    authorize(Tag, :mod_allowed?)
    @tag = Tag.new
    @tag_desc = TagDescription.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    authorize(Tag, :mod_allowed?)
    @tag = Tag.new(tag_params)
    @tag_desc = TagDescription.new

    respond_to do |format|
      if @tag.save
        if tag_params[:tag_desc]
          @tag_desc.tag_id = @tag.id
          @tag_desc.locale = I18n.locale
          @tag_desc.description = tag_params[:tag_desc]
          @tag_desc.save
        end
        format.html { redirect_to tags_path, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    authorize(@tag, :mod_allowed?)
    if tag_params[:tag_desc]
      @tag_desc.tag_id = @tag.id
      @tag_desc.locale = I18n.locale
      @tag_desc.description = tag_params[:tag_desc]
      @tag_desc.save
    end
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_path, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    authorize(@tag, :mod_allowed?)
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @tags = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @tags = Tag.where(slug: current_slug).to_a
      end
    end
    @tags = authorize(Tag, :view_allowed?)
    render(json: @tags, only: [:name])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find_by(slug: params[:id])
    if @tag.nil? && params[:id].scan(/\D/).empty?
      @tag = Tag.find(params[:id])
    end
    @tag_desc = TagDescription.where(tag_id: @tag.id, locale: I18n.locale).first
    if !@tag_desc
      @tag_desc = TagDescription.new
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:name, :slug, :tag_desc)
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = Tag.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
