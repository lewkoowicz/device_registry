module ReturnError
  class Unauthorized < StandardError; end
  class NotAssigned < StandardError; end
end