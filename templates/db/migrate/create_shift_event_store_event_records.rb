class CreateShiftEventStoreEventRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :shift_event_store_event_records do |t|
      t.string :aggregate_id, null: false
      t.integer :sequence_id, null: false
      t.string :event_type,   null: false
      t.json :payload,        null: false

      t.timestamps

      t.index :aggregate_id
    end


    # create a trigger to set the sequence_id to what it should be on create
    sql = <<~SQL
      CREATE FUNCTION set_sequence_id() RETURNS TRIGGER AS $set_sequence_id$
      BEGIN
        NEW.sequence_id := 1 + COALESCE(
          (
            SELECT MAX(sequence_id)
            FROM shift_event_store_event_records
            WHERE shift_event_store_event_records.aggregate_id = NEW.aggregate_id
          ),
          0
        );

        RETURN NEW;
      END
      $set_sequence_id$ LANGUAGE plpgsql;

      CREATE TRIGGER set_sequence_id BEFORE INSERT ON shift_event_store_event_records
      FOR EACH ROW EXECUTE PROCEDURE set_sequence_id();
    SQL
    execute sql
  end

  def down
    execute "DROP TRIGGER IF EXISTS set_sequence_id ON shift_event_store_event_records;"
    execute "DROP FUNCTION IF EXISTS set_sequence_id();"
    drop_table :shift_event_store_event_records
  end
end