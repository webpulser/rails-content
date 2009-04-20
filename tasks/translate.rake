#require 'active_record'
#require 'I18n'
#require 'app/models/Block'

namespace :rails_content do 
  desc "Move the original field from table to translation table"
  task (:translate => :environment) do
    I18n.locale = ENV['locale']
    
    models = ENV['model'].split(',')
    models.each do |model|
      table = Class.class_eval model
      table_translation = Class.class_eval (model+"Translation")
      table.all.each do |entry|
        translations=[]
        table_translation.columns.each do |column|
          if column.name != "id" && column.name != "locale" && column.name != table.table_name.singularize+"_id"
            translations<<column.name
          end
        end
        params_translation = table.find_by_sql("SELECT * FROM #{table.table_name} WHERE id='#{entry.id.to_s}'").first

        object_table_translation = table_translation.new("#{table.table_name.singularize}_id" => entry.id)
        object_table_translation.locale=I18n.locale
        columns = {} 
        table_translation.columns.reject{ |column| ['id','locale',table.table_name.singularize+"_id"].include?(column.name) }.each do |column|
          columns[column.name.to_sym] = params_translation[column.name]
        end
        object_table_translation.update_attributes(columns)
      end
    end
    puts "translations are in translation tables"
  end
  
  desc "Move the translation table to the original table"
  task (:untranslate => :environment) do
    I18n.locale = ENV['locale']
    
    models = ENV['model'].split(',')
    models.each do |model|
      table = Class.class_eval model
      
      table_translation = Class.new(super_class=ActiveRecord::Base) do
        name = "#{table.name}Translation"
        self.table_name = "#{table.table_name.singularize}_translations"
      end
      
      table_translation.find_all_by_locale(ENV['locale']).each do |entry|      
      
#        puts entry.methods.sort
#        puts entry.attributes
        object_table = table.find_by_id entry.attributes["#{table.table_name.singularize}_id"]
        columns = {} 
        puts object_table.id
        table_translation.columns.reject{ |column| ['id','locale',table.table_name.singularize+"_id"].include?(column.name) }.each do |column| 
          columns[column.name.to_sym] = entry.attributes[column.name]
        end
        object_table.update_attributes(columns)
      end
    end
    puts "translations are in original tables"
  end
  
  desc "Import a yml file into the database"
  task (:import_yml => :environment) do
    I18n.valid_locales.each do |locale|
      YAML.parse_file "config/locales/#{locale}.yml" do |ydoc|
        recurs_import_yml ydoc.children(locale)[0]
      end
    end
  end
  
  def recurs_import_yml (ydoc)
    translation = GlobalizeTranslation.new ydoc.value
    ydoc.children.each do |ydoc_child|
      translation_child = recurs_import_yml ydoc_child
      translation_child.parent = translation
    end
    translation.save
    return translation
  end
end