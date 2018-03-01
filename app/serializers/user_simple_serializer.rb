class UserSimpleSerializer < ActiveModel::Serializer
  attributes :id, :status, :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone

end
