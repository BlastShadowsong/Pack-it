class QuestSerializer < ActiveModel::Serializer
  attributes :id, :kind, :rank, :credit, :amount, :count, :duration, :status, :message, :result, :feedback, :startup, :deadline
end
