Puppet::Type.newtype(:libvirt_pool) do
  desc 'manages libvirt pools'

  ensurable
=begin do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
  end
=end

  newparam(:name, :namevar => true) do
    'name of the vhost to add'
     newvalues(/^\S+$/)
  end

  newparam(:type) do
    'type of the pool'
    newvalues(:dir, :netfs, :logical, :disk, :iscsi, :mpath, :rbd, :sheepdog)
  end

  newparam(:target) do
    'target of the pool'
    newvalues(/(\/)?(\w)/)
  end

  newparam(:autostart) do
    'whether the pool should be autostarted'
    newvalues(:true)
    newvalues(:false)
  end

end
