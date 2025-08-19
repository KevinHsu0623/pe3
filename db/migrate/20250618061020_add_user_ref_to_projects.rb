class AddUserRefToProjects < ActiveRecord::Migration[8.0]
  def change
    # 先加可為 null 的 user_id foreign key
    add_reference :projects, :user, foreign_key: true, null: true

    reversible do |dir|
      dir.up do
        # 找出一個預設使用者（例如第一位 admin 或第一筆 user）
        default_user = User.find_by(role: 'admin') || User.first

        # 把所有舊專案的 user_id 填上這個預設使用者
        execute <<~SQL
          UPDATE projects
          SET user_id = #{default_user.id}
          WHERE user_id IS NULL;
        SQL

        # 現在沒有 null 了，可以加上 NOT NULL 限制
        change_column_null :projects, :user_id, false
      end

      dir.down do
        # 回復時就把這個欄位移掉
        remove_reference :projects, :user, foreign_key: true
      end
    end
  end
end
