module QueryHelper
    extend ActiveSupport::Concern
    module ClassMethods
        
        # DOCU: Query single SELECT records to the database
        def query_select_one(query_statement)
            return ActiveRecord::Base.connection.select_one(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        # DOCU: Query multiple SELECT records to the database
        def query_select_all(query_statement)
            return ActiveRecord::Base.connection.exec_query(ActiveRecord::Base.send(:sanitize_sql_array, query_statement)).to_a
        end

        # DOCU: Query edit records to the database
        def query_update(query_statement)
            return ActiveRecord::Base.connection.update(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        # DOCU: Query delete records to the database
        def query_delete(query_statement)
            return ActiveRecord::Base.connection.delete(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end

        # DOCU: Query insert records to the database
        def query_insert(query_statement)
            return ActiveRecord::Base.connection.insert(ActiveRecord::Base.send(:sanitize_sql_array, query_statement))
        end
    end
end