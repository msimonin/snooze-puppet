require 'rexml/document'
require 'tempfile'

include REXML

Puppet::Type.type(:libvirt_pool).provide(:virsh) do

  commands :virsh => 'virsh' 

  def self.instances
    list = virsh '-q', 'pool-list', '--all'
    list.split(/\n/)[0..-1].map do |line|
      fields = line.split(/ +/)
      name = fields[0] 
      new(:name => name)
    end
  end

  def create
    self.createPool
  end

  def build 
    self.createPool
    self.buildPool
  end

  def activate
    self.createPool
    self.buildPool
    self.activatePool
  end

  def destroy
    self.destroyPool
  end

  def createPool
    begin
      xml = buildPoolXML resource
      tmpFile = Tempfile.new("pool.#{resource[:name]}")
      tmpFile.write(xml)
      tmpFile.rewind
      virsh 'pool-define', tmpFile.path
    rescue
      notice("Unable to define the pool")
    end
  end

  def buildPool
    begin
      virsh 'pool-build', '--pool', resource[:name]
    rescue
      notice("Unable to build the pool")
    end
  end

  def activatePool
    begin
      virsh 'pool-start', '--pool', resource[:name]
    rescue
      notice("Unable to activate the pool")
    end

    if (resource[:autostarted])
      begin
        virsh 'pool-autostart', '--pool', resource[:name]
      rescue
        notice("Unable to autostart the pool")
      end
    end
  end

  def destroyPool
    begin
      virsh 'pool-destroy', resource[:name]
    rescue 
      notice("Unable to deactivate pool #{resource["name"]}, I will try to undefine it")
    end
    virsh 'pool-undefine', resource[:name]
  end

  def exists?
    list = virsh '-q', 'pool-list', '--all'
    list.split(/\n/)[0..-1].map { |line|
       line.split(/ +/)[0]
    }.detect { |name| name == resource[:name] }
  end

  def buildPoolXML(resource)
    root = Document.new
    # pool
    pool = root.add_element 'pool', {'type' => resource[:type]}
    # name
    name = pool.add_element 'name'
    name.add_text resource[:name]

    # srcs
    srcHost = resource[:sourcehost]
    srcPath = resource[:sourcepath]
    srcDev = resource[:sourcedev]
    srcName = resource[:sourcename]
    srcFormat = resource[:sourceformat]

    if (srcHost || srcPath || srcDev || srcName || srcFormat)
      source = pool.add_element 'source'

      if (srcHost)
        source.add_element 'host', {'name' => srcHost}  
      end

      if (srcPath)
        source.add_element 'dir', {'path' => srcPath}  
      end

      if (srcDev)
        if srcDev.respond_to? :each
          srcDevArray = srcDev
        else
          srcDevArray = [srcDev]
        end
        srcDevArray.each do |dev|
          source.add_element 'device', {'path' => dev} 
        end
      end

      if (srcFormat)
        source.add_element 'format', {'type' => srcFormat}  
      end

      if (srcName)
        srcNameEl = source.add_element 'name'  
        srcNameEl.add_text srcName
      end
    end

    # target
    target = resource[:target]
    if target
      targetEl = pool.add_element 'target'
      targetPathEl = targetEl.add_element 'path'
      targetPathEl.add_text target
    end

    return root.to_s

  end # buildPoolXML

end
