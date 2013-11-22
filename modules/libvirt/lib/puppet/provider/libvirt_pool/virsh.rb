Puppet::Type.type(:libvirt_pool).provide(:virsh) do

  commands :virsh => 'virsh'

  def self.instances
    virsh('pool-list --all').split(/\n/)[2..-1].map do |line|
      fields = line.split(/ +/)
      name = fields[0] 
      new(:name => name)     
    end
  end

  def create
    virsh "pool-define-as", "--name", resource[:name], "--type", resource[:type], "--target", resource[:target]
    virsh "pool-start", resource[:name]
    if (resource[:autostart])
      virsh "pool-autostart", resource[:name]
    end
  end

  def destroy
    virsh "pool-destroy", resource[:name]
    virsh "pool-undefine", resource[:name]
  end

  def exists?
    out = virsh('pool-list --all').split(/\n/)[2..-1].detect do |line|
     line.match(/^#{Regexp.escape(resource[:name])}/) 
    end
  end



end
