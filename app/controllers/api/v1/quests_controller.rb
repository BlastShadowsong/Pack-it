class Api::V1::QuestsController < Api::V1::ApiController
  before_action :set_quest, only: [:show, :update]

  def index
    # TODO: @sy.li, need paged list for @quests
    # dynamic query for where(), e.g. /quests?quest[status]=unsolved
    @quests = params[:quest].present? ? Quest.where(quest_params) : Quest.all
    respond_with @quests
  end

  def show
    respond_with @quest
  end

  def create
    @quest = Quest.create!(quest_params)
    respond_with 'api_v1', @quest
  end

  def update
    @quest.update!(quest_params)
    # TODO: @sy.li, need fire a event for quest solved, then profile would be updated by event handler, OR simply by callback
    respond_with 'api_v1', @quest
  end

  private
  def quest_params
    params.require(:quest).permit!
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end
end
