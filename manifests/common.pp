stage { 'first': 
 before => Stage['main'],
}
 
 
case $lsbdistcodename {
  'squeeze' :{
    class {
      'apt::testing':
       stage => first
    }
  }
  'wheezy':{
    class {
      'apt': 
       stage => first
    }
  }
}

