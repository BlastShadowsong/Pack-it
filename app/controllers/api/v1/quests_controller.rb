class Api::V1::QuestsController < Api::ApplicationController
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
    if(@quest.status.solved?)
      @quest.update!(quest_params)
      @quest.comment
    end
    respond_with @quest
  end

  def destroy
    @quest.close
    respond_with @quest
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
