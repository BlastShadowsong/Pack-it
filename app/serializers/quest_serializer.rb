class QuestSerializer < ActiveModel::Serializer
  attributes :id, :kind, :rank, :credit, :amount, :figure, :duration, :status, :message, :result, :feedback, :startup, :deadline
end
