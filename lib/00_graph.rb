# This is entirely written for you.

class UndirectedVertex
  attr_reader :name

  def initialize(name)
    @name = name
    @edges = []
  end

  def add_edge(edge)
    @edges << edge
  end

  def edges
    # Woe to those who try to mutate this list!
    @edges.sort_by { |e| e.name }.freeze
  end

  def ==(other_vertex)
    self.equal?(other_vertex)
  end

  def to_hash
    { name: name, edges: edges.map(&:name) }
  end
end

class UndirectedEdge
  attr_reader :name, :vertices, :cost

  def initialize(name, vertex1, vertex2, cost = 1)
    @name = name
    @vertices = [vertex1, vertex2]
    @cost = cost

    vertex1.add_edge(self)
    vertex2.add_edge(self)
  end

  def destroy!
    vertices[0].edges.delete(self)
    vertices[1].edges.delete(self)

    @vertices = nil
  end

  def other_vertex(vertex)
    return vertices[1] if vertices[0] == vertex
    return vertices[0] if vertices[1] == vertex
    raise "vertex is at neither end"
  end

  def ==(other_edge)
    self.equal?(other_edge)
  end

  def to_hash
    { name: name, vertices: vertices.map(&:name), cost: cost }
  end
end
