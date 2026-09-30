module Error
  module Http
    class InvalidRequest < StandardError
    end
    class InvalidResponse < StandardError
    end
  end
end
