class Api::V1::QuestsController < Api::V1::ApiController
  before_action :set_quest, only: [:show, :destroy]


  def index
    # dynamic query for where(), e.g. /quests?quest[status]=unsolved
    @quests = Quest.all
    @quests = @quests.where(quest_params) if params[:quest].present?
    # pagination, 25 per page by default, e.g. /quests?page=2&size=25
    respond_with @quests.desc(:created_at).page(params[:page]).per(params[:size])
  end

  def show
    respond_with @quest
  end

  def create
    @quest = Quest.create!(quest_params)
    respond_with 'api_v1', @quest
  end

  def destroy
    # TODO: 调用fail方法
    respond_with 'api_v1', @quest
  end

  def update

  end

  def check_finish
    # TODO: 检查任务是否完成，回答人数到达amount也是任务完成的标志
    # step 1: 通过任务id查找到Quest，通过count和amount判断任务是否完成
    # 如果count ！= amount，判定为任务未完成，等待；
    # 如果count == amount，判定为任务完成，直接调用complete。
  end


  private
  def quest_params
    params.require(:quest).permit!
  end

  def set_quest
    @quest = Quest.find(params[:id])
  end

end
