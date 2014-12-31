class Api::V1::QuestsController < Api::V1::ApiController
  before_action :set_quest, only: [:show, :destroy]

  def index
    # dynamic query for where(), e.g. /quests?quest[status]=unsolved
    @quests = params[:quest].present? ? Quest.where(quest_params) : Quest.all
    # pagination, 25 per page by default, e.g. /quests?page=2
    respond_with @quests.desc(:created_at).page(params[:page])
  end

  def show
    respond_with @quest
  end

  def create
    @quest = Quest.create!(quest_params)
    respond_with 'api_v1', @quest
  end

  def destroy
    # TODO: @sy.li, need fire a event for quest solved or closed, then profile would be updated by event handler, OR simply by callback
    # close the quest
    # @quest.close
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
