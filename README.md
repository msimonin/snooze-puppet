snooze-puppet
=============

If you intend to use puppet to install Snooze, you will find here the recipes to install the snoozenode system service. 
You will be able to install a bootstrap, a localcontroller or a groupmanager quiet easily. 

Starting with 2.1.0 you will be able to install the ``snoozeimages`` and the ``snoozeec2`` system services aswell.

## Examples


This instanciation will produce a local controller on your node. You can check the defaut parameters in the `manifest/init.pp` of the snoozenode module

```puppet
class { 
  'snoozenode':
    type => "localcontroller",
}

```

This will install ``snoozeec2`` and ``snoozeimages`` on the same node : 

```puppet
class {
  "snoozeimages":
    listenPort => 7654
}

class {
  "snoozeec2":
    listenPort          => 4567,
    imageRepositoryPort => 7654
}

```


