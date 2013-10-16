class java{
   package { 'openjdk-7-jre':
     ensure => installed,
   }

   package { 'openjdk-7-jdk':
     ensure => installed,
   }
}
