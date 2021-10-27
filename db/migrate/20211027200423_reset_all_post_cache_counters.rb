class ResetAllPostCacheCounters < ActiveRecord::Migration[6.1]
  def up
    Post.all.each do |p|
      p.reset_counters(p.id, :likes)
    end
  end
  def down
    # no rollback needed
  end
end
