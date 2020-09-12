class User
  def roles(session: nil)
    session.nil? ? ['roles'] : ['session roles']
  end
end

