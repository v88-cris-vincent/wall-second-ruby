module ApplicationHelper
    
    # DOCU: This global function is used to validate required fields if they are present
    # Triggered by: All Controllers
    def validate_fields(params, required_params)
        response_data = { :status => false, :result => {}, :error => nil }
        missing_fields = []
        begin
            required_params.each do |required_param|
                if params[required_param].empty?
                    missing_fields.push(required_param)
                end
            end
            response_data[:status]= missing_fields.empty?
            
            response_data[:error]  = "Please fill the following fields (#{missing_fields})" if !response_data[:status]
            
        rescue => exception
            response_data[:error]  = "All fields#{missing_fields} are required!"
        end
        
        return response_data
    end
end
