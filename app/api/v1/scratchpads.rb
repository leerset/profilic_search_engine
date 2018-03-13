module V1
  class Scratchpads < Grape::API
    version 'v1'
    format :json

    resource :scratchpads do

      desc "create scratchpad"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        optional :content, type: String, desc: "content (65535)"
      end
      post :create do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        return data_not_found(EXIST_INV_SCRATCHPAD) if invention.scratchpad.present?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        invention.create_scratchpad(content: params[:content])
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update scratchpad"
      params do
        requires :id, type: Integer, desc: "scratchpad id"
        optional :content, type: String, desc: "content (65535)"
      end
      put :update do
        authenticate!
        scratchpad = Scratchpad.find_by(id: params[:id])
        return data_not_found(MISSING_SCRATCHPAD) if scratchpad.nil?
        invention = scratchpad.invention
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        scratchpad.update_attributes(content: params[:content])
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "delete scratchpad"
      params do
        requires :id, type: Integer, desc: "scratchpad id"
      end
      delete :delete do
        authenticate!
        scratchpad = Scratchpad.find_by(id: params[:id])
        return data_not_found(MISSING_SCRATCHPAD) if scratchpad.nil?
        invention = scratchpad.invention
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        scratchpad.destroy
        resp_ok("invention" => InventionSerializer.new(invention))
      end

    end
  end
end
