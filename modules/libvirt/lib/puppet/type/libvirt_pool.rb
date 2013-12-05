Puppet::Type.newtype(:libvirt_pool) do
  desc 'manages libvirt pools'

  ensurable do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
    newvalue(:built) do
      provider.build
    end
    newvalue(:active) do
      provider.activate
    end

    newvalue(:absent) do
      if (provider.exists?)
        provider.destroy
      end
    end
  end

  newparam(:name, :namevar => true) do
    'name of the pool to define'
     newvalues(/^\S+$/)
  end

  newparam(:type) do
    'type of the pool'
    newvalues(:dir, :netfs, :fs, :logical, :disk, :iscsi, :mpath, :rbd, :sheepdog)
  end

  newparam(:sourcehost) do
    'name of the source host'
     newvalues(/^\S+$/)
  end

  newparam(:sourcepath) do
    'name of the source path'
    newvalues(/(\/)?(\w)/)
  end

  newparam(:sourcedev) do
    'name of the source path'
    newvalues(/(\/)?(\w)/)
  end

  newparam(:sourcename) do
    'name of the source path'
     newvalues(/^\S+$/)
  end

  newparam(:sourceformat) do
    'name of the source format'
     newvalues(:auto, :nfs, :glusterfs, :cifs)
  end
  
  newparam(:target) do
    'target of the pool'
    newvalues(/(\/)?(\w)/)
  end

  newparam(:autostarted) do
    'whether the pool should be autostarted'
    newvalues(:true)
    newvalues(:false)
  end
end
