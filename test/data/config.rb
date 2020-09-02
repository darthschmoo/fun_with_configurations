# An example configuration file.
servers do
  hopeful_host do
    ip "192.168.0.25"
    services :mysql, :memcached, :email, :backup
    uptime `uptime`.strip
    config_script "/var/configurations/hopeful.conf"
  end

  squishy_host do
    fwc_comment "my favorite ip address of all time"
    fwc_comment "in fact, it makes me wonder why anyone bothers with other ip addresses, this one is so great"
    fwc_comment "never in my life have I met such an ip address"
    fwc_comment "comments are going to change my life"
    ip "192.168.0.27"
    services :postresql, :couchdb
    uptime `uptime`.strip
    config_script "/var/configurations/squishy.conf"
    deeper do
      salivate( {} )
      cuticle  :rostenfeffer
    end
  end
end

workstations do
  betty do
    ip "192.168.0.14"
    os "Ubuntu Linux 13.04"
  end

  veronica do
    ip "192.168.0.15"
    os "Solaris 10"
  end
end