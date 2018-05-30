class AddNewEconomicsToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :economics_estimatedincrementalcost, :text
    add_column :container_sections, :economics_feasiblyeconomical, :text
    add_column :container_sections, :economics_whomake, :text
    add_column :container_sections, :economics_howmakemoney, :text
    add_column :container_sections, :economics_howdelivered, :text
    add_column :container_sections, :economics_economicburden, :text
    add_column :container_sections, :economics_currentsolutioncosts, :text
    add_column :container_sections, :economics_consumercosts, :text

    add_column :container_sections, :economics_estimatedincrementalcost_completion, :boolean, default: false
    add_column :container_sections, :economics_feasiblyeconomical_completion, :boolean, default: false
    add_column :container_sections, :economics_whomake_completion, :boolean, default: false
    add_column :container_sections, :economics_howmakemoney_completion, :boolean, default: false
    add_column :container_sections, :economics_howdelivered_completion, :boolean, default: false
    add_column :container_sections, :economics_economicburden_completion, :boolean, default: false
    add_column :container_sections, :economics_currentsolutioncosts_completion, :boolean, default: false
    add_column :container_sections, :economics_consumercosts_completion, :boolean, default: false
  end
end
