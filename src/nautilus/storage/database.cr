module Nautilus
  module Storage
    class Database
      property db : DB::Database

      def initialize(config)
        Dir.mkdir_p("storage") unless File.exists? "storage"
        @db = DB.open "sqlite3:./storage/data.db"
        InitHelper.new(@db)
      end

      def current_blocksize
        rs = db.query "SELECT COUNT(*) FROM block;"
        @current_blocksize = 0
        rs.each do
          @current_blocksize = rs.read(Int32);
        end
        @current_blocksize
      end
    end
  end
end
