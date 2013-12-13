# An example configuration file.
servers do
  hopeful_host do
    ip "192.168.0.25"
    services :mysql, :memcached, :email, :backup
    uptime `uptime`.strip
    config_script "/var/configurations/hopeful.conf"
  end

  squishy_host do
    ip "192.168.0.27"
    services :postresql, :couchdb
    uptime `uptime`.strip
    config_script "/var/configurations/squishy.conf"
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