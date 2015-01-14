class Api::V1::QuestsController < Api::ApplicationController
  before_action :authorize_resource_owner!, only: [:index, :show, :create, :update, :destroy]
  before_action :set_quest, only: [:show, :update, :destroy]


  def index
    @quests = Quest.all
    @quests = @quests.where(quest_params) if params[:quest].present?
    paginate_with @quests.desc(:created_at)
  end

  def show
    respond_with @quest if stale?(@quest)
  end

  def create
    @quest = Quest.create!(quest_params)
    respond_with @quest
  end

  def update
    if @quest.status.solved?
      @quest.update!(quest_params)
      @quest.comment
    end
    respond_with @quest
  end

  def destroy
    @quest.close
    respond_with @quest
  end


  private
  def quest_params
    params.require(:quest).permit!
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end

end
