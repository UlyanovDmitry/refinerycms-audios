class CreateAudiosAudios < ActiveRecord::Migration

  def up
    create_table :refinery_audios do |t|
      t.text :file_name
      t.text :file_mime_type
      t.text :file_url_name
      t.integer :file_size
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end
    add_index :refinery_audios, :id

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-audios"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/audios/audios"})
    end

    drop_table :refinery_audios

  end

end
