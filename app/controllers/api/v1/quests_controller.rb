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

  def finish
    # TODO: 任务结束
    # step 1: 通过任务id查找到Quest，通过count判断任务是否完成
    # 如果count == 0，判定为任务失败，调用destroy；
    # 如果count ！= 0，判定为任务完成，调用complete。

  end

  def complete
    # TODO: 任务完成
    # step 1: 通过任务id查找到Quest，修改status为solved
    #
    # step 2: 在Seeker_Profile中修改 solved + 1
    #
    # step 3: 找到Quest相关的solution，修改status为solved
    #
    # step 4: 在Solver_Profile的prefer中修改 solved + 1
    #
    # step 5: Seeker的Credit_Profile中 credit - = quest中的 credit * count ；
    #         Solver中Credit_Profile中 credit + = solution中的 credit；
    #         Seeker_Profile中 credit + = quest中的 credit * count；
    #         Solver_Profile中 credit + = solution中的 credit
    #
    # step 6: 向Seeker和Solver推送结果
  end

  def destroy
    # TODO: 任务删除
    # step 1: 通过任务id查找到Quest，修改status为failed
    #
    # step 2: 在Seeker_Profile的prefer中删除这个quest，failed + 1
    #
    # step 3: 找到Quest相关的solution，修改status为failed
    #
    # step 4: 在Solver_Profile的prefer中删除这个solution，failed + 1

    respond_with 'api_v1', @quest
  end

  def update
    # TODO: 用户反馈，借用update的路径（由于任务只能取消/重发，不能更改）
    # step 1: 通过任务id查找到Quest，修改status为commented，修改feedback为上传的feedback
    #
    # step 2: 在Seeker_Profile的prefer中修改相应的accepted或denied + 1
    #
    # step 3: 找到Quest相关的solution，修改status为commented
    # 如果该用户答案与最终答案一致且用户accept，修改feedback为 accepted，Solver_Profile中 accepted + 1
    # 如果该用户答案与最终答案一致且用户denied，修改feedback为 denied，Solver_Profile中 denied + 1
    # 如果该用户答案与最终答案不一致且用户accept，修改feedback为 denied，Solver_Profile中 denied + 1
  end

  def check_finish
    # TODO: 检查任务是否完成，被timer周期性调用
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
