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

  def distribution
    #TODO: 任务分发
    #step 0: 获取quest中的kind信息，对不同类型的任务做不同的处理

    #对于question:

    #step 1: 获取quest中的business、count、startup等信息

    #setp 2: 查询business_complex表，获得商家位置，确定分发参数（坐标上下限，人数），支持的最晚timestamp

    #step 3: 查询location_profile中满足以下条件的用户:
        # outdoor_location在经纬度范围之内
        # indoor_location在坐标范围之内
        # timestamp在最晚timestamp之后
        # 排序依据为timestamp降序，取前count个获得相应的用户id

    #step 4: 调用solution的create函数，赋给相应的参数，分别创建对应的solutions

    #step 5: 查询user表获取要分发的用户的推送id，使用腾讯信鸽进行分发

    #step 6: 启动timer，当时间到达时调用quest_finish函数
  end
end
