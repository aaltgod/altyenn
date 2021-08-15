module Tool
    extend self

    include Constant

    def field_exists?(field : String)
        FIELDS.each do |f|
            if f == field
                return true
            end
        end

        return false
    end

    def order_exists?(order : String)
        ORDERS.each do |o|
            if o == order
                return true
            end
        end

        return false
    end

    def filter_exists?(filter : String)
        FILTERS.each do |f|
            if f == filter
                return true
            end
        end

        return false
    end
end