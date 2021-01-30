module Nautilus
  module Storage
    class Database
      def initialize(config)
        Dir.mkdir_p("storage") unless File.exists? "storage"
        @db = DB.open "sqlite3://.storage/data.db"
      end
    end
  end
end
