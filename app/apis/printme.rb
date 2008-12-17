class PrintmeAPI < SoapsBase
  def add_methods
    # Connection Testing
    add_method("ping")
    # Version Checking
    add_method("version_compat", "client_version")
    add_method("version")
    add_method("bad_client_error")
    add_method("bad_server_error")
    # Lists
    add_method("actions")
    add_method("types")
    add_method("contracts")
  end

  ######################
  # Connection Testing #
  ######################

  def ping
#    return error("BOO")
    "pong"
  end

  ####################
  # Version Checking #
  ####################

  public
  def version_compat(client_version)
    server_hash[version].include?(client_version)
  end
  def version
    9
  end
  def bad_client_error
    "You need to update your version of printme\nTo do that, go to System, then Administration, then Update Manager. When update manager comes up, click Check and then click Install Updates.\nAfter that finishes, run printme again."
  end
  def bad_server_error
    "The server is incompatible. exiting."
  end

  private
  def server_hash
    server_versions = Hash.new([])
    server_versions[1] = [1]      # I don't remember...but I know that it wouldn't have gotten to this point :)
    server_versions[2] = [2,3,4]  # really 2-4 are all compatible with all versions
    server_versions[3] = [3,4]    # force client upgrade. so of course old ones aren't compatible. (field renames)
    server_versions[4] = [4]      # yet another force client upgrade. (server version checking)
    server_versions[5] = [5]      # force upgrade. printme no longer fixes the xml.
    server_versions[6] = [6]      # forced. add contracts support.
    server_versions[7] = [7]      # forced. fix contracts support. (bad builder problem)
    server_versions[8] = [8]      # forced. fix contracts support. (my bugs)
    server_versions[9] = [9]      # rewrite with soap...FORCED!!! :)
    server_versions
  end

  #########
  # Lists #
  #########

  ActionStruct = Struct.new( :name, :description, :thing_id )
  TypeStruct = Struct.new( :name, :description, :thing_id )
  ContractStruct = Struct.new( :name, :label, :thing_id )

  public
  def actions
    Action.usable.map{|x| ActionStruct.new(x.name, x.description, x.id)}
  end
  def types
    Type.usable.map{|x| TypeStruct.new(x.name, x.description, x.id)}
  end
  def contracts
    Contract.usable.map{|x| ContractStruct.new(x.name, x.label, x.id)}
  end

  #####
  #####
  public
end
