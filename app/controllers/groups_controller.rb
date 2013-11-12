class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all
  end

  # GET /groups/1
  def show
    @recent_updates = Entity.includes(last_user: { sf_guard_user: :sf_guard_user_profile })
                            .where(last_user_id: @group.guard_user_ids)
                            .order("updated_at DESC").limit(10)

    if true or user_signed_in?
      @notes = @group.notes.order("updated_at DESC").limit(10)
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find_by_slug(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name, :slug, :tagline, :description, :logo, :cover, :is_private, :findings, :howto, :bootsy_image_gallery_id)
    end
end
