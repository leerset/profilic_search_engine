class PhoneSerializer < ActiveModel::Serializer
  attributes :id, :phone_type, :phone_number
end
