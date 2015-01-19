module ApplicationHelper
  ## query object
  # see: http://martinfowler.com/eaaCatalog/queryObject.html
  # e.g.
  #   criteria[field]=value
  #   criteria[field][operator]=value
  #   criteria={"field":value"}
  #   criteria={"field":{"operator":"value"}}
  #   criteria={"and|or":[{"field":{"operator":"value"}},{"field":{"operator":"value"}}]}
  #   criteria={"and|or":[{"field":value"},{"field":value"}]}
  #   sort[field]=asc|desc
  #   sort={field:"asc|desc"}
  def query(queryable, criteria = params[:criteria], sort = params[:sort])
    if criteria
      criteria = JSON.parse(criteria) if criteria.is_a?(String)
      queryable = queryable.where(criteria)
    end

    if sort
      sort = JSON.parse(sort) if sort.is_a?(String)
      queryable = queryable.order_by(sort)
    end

    queryable
  end
end
