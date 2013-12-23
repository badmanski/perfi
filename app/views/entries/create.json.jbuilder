json.(@entry, :id, :name, :type_name, :amount, :created_at)
json.created_at I18n.l(@entry.created_at)