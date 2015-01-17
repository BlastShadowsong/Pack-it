module ApplicationHelper
  ## query object
  # criteria[field][operator]=value
  # sort[field]=asc|desc
  # see: http://martinfowler.com/eaaCatalog/queryObject.html
  def query(queryable, criteria = params[:criteria], sort = params[:sort])
    queryable = queryable.where(criteria) if criteria
    queryable = queryable.order_by(sort) if sort
    queryable
  end
end
