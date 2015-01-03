class Api::V1::QuestsController < Api::V1::ApiController
  before_action :set_quest, only: [:show, :destroy]
  after_create :distribution

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

  def distribution
    # TODO: 任务分发
    # step 1: 获取quest中的business、amount、startup等信息
    #
    # setp 2: 查询business_complex表，获得商家位置，确定分发参数（坐标上下限，人数），支持的最晚timestamp
    #
    # step 3: 查询location_profile中满足以下条件的用户:
        # outdoor_location在经纬度范围之内
        # indoor_location在坐标范围之内
        # timestamp在最晚timestamp之后
        # 排序依据为timestamp降序，取前count个获得相应的用户id
    #
    # step 4: 调用solution的create函数，赋给相应的参数，分别创建对应的solutions
    #
    # step 5: 修改Seeker_Profile中 total + 1，各个solution对应的Solver_Profile中 total + 1
    #
    # step 6: 查询user表获取要分发的用户的推送id，使用腾讯信鸽进行分发
    #
    # step 7: 启动timer，当时间到达时调用quest_finish函数
  end
end
