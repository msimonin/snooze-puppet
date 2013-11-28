snooze-puppet
=============

If you intend to use puppet to install Snooze, you will find here the recipes to install the snoozenode system service. 
You will be able to install a bootstrap, a localcontroller or a groupmanager quiet easily.

## Example


This instanciation will produce a local controller on your node. You can check the defaut parameters in the `manifest/init.pp` of the snoozenode module

```puppet
class { 
  'snoozenode':
    type => "localcontroller",
}

```

This will install kadeploy3 on your node : 

```puppet
include 'kadeploy3'
```


