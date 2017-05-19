class FavoritePlace < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  validates :user_id, :place_id, presence: true

  def self.is_favorite_place?(user_id, place_id)
    find_by(user_id: user_id, place_id: place_id).present?
  end

  def self.favorite(user_id, place_id, value)
    return {type: :error, text: :favorite_place_invalid} unless value == true || value == false

    if value == true
      r = find_or_create_by(user_id: user_id, place_id: place_id)
      if r.new_record?
        return {type: :error, text: :favorite_place_already_true}
      else
        return {type: :success, text: :favorite_place_true_succeed}
      end
    elsif value == false
      p = Place.find(place_id)
      r = p.favorites.find(id: user_id)
      if r.nil?
        return {type: :error, text: :favorite_place_already_false}
      else
        r.destroy
        return {type: :success, text: :favorite_place_false_succeed}
      # query = 'DELETE FROM "favorite_places" WHERE "favorite_places"."user_id" = $1 AND "favorite_places"."place_id" = $2'
#       query = ActiveRecord::Base.send :sanitize_sql_array, [query, arr]
# ActiveRecord::Base.connection.execute(query)


#         results = ActiveRecord::Base.connection.execute('', user_id, place_id)
#         if results.present?
#             return results
#         else
#             return nil
#         end


#         r.destroy
      end
    end
  end
end


