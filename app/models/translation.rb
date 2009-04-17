class Translation < ActiveRecord::Base
  self.table_name = "globalize_translations"
#  acts_as_tree
  
  
  
#  has_many :globalize_translations, :finder_sql => "SELECT * " +
#                                                   "FROM globalize_translations t " +
#                                                   "INNER JOIN globalize_translations_map m" +
#                                                   "ON t.key = m.key " +
#                                                   "WHERE m.key = t.key"
#  belongs_to :globalize_translation, :finder_sql => "SELECT * " +
#                                                    "FROM globalize_translations t " +
#                                                    "INNER JOIN globalize_translations_map m " +
#                                                    "ON t.key = m.key " +
#                                                    "WHERE m.translation_id = t.id" +
#                                                    "LIMIT 1"
  
#  def by_locale( locale )
#    return GlobalizeTranslation.first :conditions => ["key = ? AND locale = ?", key, locale]
#  end
end
