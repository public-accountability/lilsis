class LinksGroup

  attr_reader :links, :count, :keyword, :heading, :category_id
  
  # input: [ <Link> ] , str, str
  # Assumes that the links all have the same category
  def initialize(links, keyword, heading)
    @keyword = keyword
    @heading = heading
    @category_id = links.empty? ? nil : links[0].category_id 
    @links = group_by_entity(order(links))
    # The count here represents not the total amount of all relationships but the grouped count. 
    # If there are 4 links with the same person (i.e. entity2 is same) then @count will be 1
    @count = @links.count
  end

  def order(links)
    return links.sort { |a, b| b.related.links.count <=> a.related.links.count } if @category_id == 4
    return links.sort { |a, b| a.relationship.amount && b.relationship.amount ? b.relationship.amount <=> a.relationship.amount : -1 } if @category_id == 5
    return links # Default ordering is end date descending, handled in db query

  end


  # input: [ <Link> ] 
  # output: [ [<Link>] [<Link>] ]
  # This groups entities by the 'other' entity so that relationships with the
  # same entity are grouped together
  def group_by_entity(links)
    links.group_by { |l| l.entity2_id }.values
  end
end
