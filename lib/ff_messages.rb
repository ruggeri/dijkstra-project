class Message
  attr_reader :name, :result, :fringe

  def initialize(name, result, fringe)
    @name, @result, @fringe = name, result, fringe
  end

  def ==(msg)
    ((name == msg.name) &&
     (result == msg.result) &&
     (fringe == msg.fringe))
  end
end

class InitializationMessage < Message
  def initialize(result, fringe)
    super(:initialization, result, fringe)
  end
end

class ExtractionMessage < Message
  attr_reader :best_entry

  def initialize(result, fringe, best_entry)
    super(:extraction, result, fringe)
    @best_entry = best_entry
  end

  def ==(msg)
    super(msg) && (best_entry == msg.best_entry)
  end
end

class EdgeConsiderationMessage < Message
  attr_reader :new_entry, :action
  def initialize(result, fringe, new_entry, action)
    super(:edge_consideration, result, fringe)
    @new_entry, @action = new_entry, action
  end

  def ==(msg)
    super(msg) && (new_entry == msg.new_entry) && (action == msg.action)
  end
end

class UpdateCompletionMessage < Message
  attr_reader :best_entry

  def initialize(result, fringe, best_entry)
    super(:update_completion, result, fringe)
    @best_entry = best_entry
  end

  def ==(msg)
    super(msg) && best_entry == msg.best_entry
  end
end
