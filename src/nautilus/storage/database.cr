module Nautilus
  module Storage
    class Database
      property db : DB::Database

      def initialize(config)
        Dir.mkdir_p("storage") unless File.exists? "storage"
        @db = DB.open "sqlite3:./storage/data.db"
        InitHelper.new(@db)
      end

      def current_blocksize() : Int32
        blocksize : Int32 = 0
        rs = db.query "SELECT COUNT(*) FROM block;"
        rs.each do
          blocksize = rs.read(Int32);
        end
        blocksize
      end
    end
  end
end
