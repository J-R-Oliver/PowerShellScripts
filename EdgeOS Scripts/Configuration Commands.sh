set interfaces ethernet eth0 description pppoe
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 poe output off
set interfaces ethernet eth0 pppoe 0 default-route auto
set interfaces ethernet eth0 pppoe 0 mtu 1492
set interfaces ethernet eth0 pppoe 0 name-server auto
set interfaces ethernet eth0 pppoe 0 password ubnt
set interfaces ethernet eth0 pppoe 0 user-id ubnt
set interfaces ethernet eth0 speed auto
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 speed auto
set interfaces ethernet eth2 duplex auto
set interfaces ethernet eth2 speed auto
set interfaces ethernet eth3 duplex auto
set interfaces ethernet eth3 speed auto
set interfaces ethernet eth4 duplex auto
set interfaces ethernet eth4 speed auto
set interfaces ethernet eth5 duplex auto
set interfaces ethernet eth5 speed auto
set interfaces loopback lo
set interfaces switch switch0 address 10.10.48.254/24
set interfaces switch switch0 mtu 1500
set interfaces switch switch0 switch-port interface eth1
set interfaces switch switch0 switch-port interface eth2
set interfaces switch switch0 switch-port interface eth3
set interfaces switch switch0 switch-port interface eth4
set interfaces switch switch0 vif 10 address 192.168.10.254/24
set interfaces switch switch0 vif 10 description STA-VOIP
set interfaces switch switch0 vif 10 mtu 1500
set interfaces switch switch0 vif 20 address 192.168.20.254/24
set interfaces switch switch0 vif 20 description STA-IoT
set interfaces switch switch0 vif 20 mtu 1500
set interfaces switch switch0 vif 30 address 192.168.30.254/24
set interfaces switch switch0 vif 30 description STA-GUEST
set interfaces switch switch0 vif 30 mtu 1500
set service dhcp-server disabled false
set service dhcp-server hostfile-update disable
set service dhcp-server shared-network-name STA-STAFF authoritative disable
set service dhcp-server shared-network-name STA-STAFF subnet 10.10.48.0/24 default-router 10.10.48.254
set service dhcp-server shared-network-name STA-STAFF subnet 10.10.48.0/24 dns-server 8.8.8.8
set service dhcp-server shared-network-name STA-STAFF subnet 10.10.48.0/24 dns-server 8.8.4.4
set service dhcp-server shared-network-name STA-STAFF subnet 10.10.48.0/24 lease 86400
set service dhcp-server shared-network-name STA-STAFF subnet 10.10.48.0/24 start 10.10.48.10 stop 10.10.48.240
set service gui https-port 443
set service ssh port 22
set service ssh protocol-version v2
set system host-name ubnt
set system login user ubnt authentication encrypted-password '$1$zKNoUbAo$gomzUbYvgyUMcD436Wo66.'
set system login user ubnt level admin
set system ntp server 0.ubnt.pool.ntp.org
set system ntp server 1.ubnt.pool.ntp.org
set system ntp server 2.ubnt.pool.ntp.org
set system ntp server 3.ubnt.pool.ntp.org
set system syslog global facility all level notice
set system syslog global facility protocols level debug
set system time-zone UTC

: <<'END_COMMENT'
interfaces {
    ethernet eth0 {
        description pppoe
        poe {
            output off
        }
        pppoe 0 {
            mtu 1492
            password ****************
            user-id ubnt
        }
    }
    ethernet eth1 {
    }
    ethernet eth2 {
    }
    ethernet eth3 {
    }
    ethernet eth4 {
    }
    ethernet eth5 {
    }
    loopback lo {
    }
    switch switch0 {
        address 10.10.48.254/24
        switch-port {
            interface eth1
            interface eth2
            interface eth3
            interface eth4
        }
        vif 10 {
            address 192.168.10.254/24
            description STA-VOIP
            mtu 1500
        }
        vif 20 {
            address 192.168.20.254/24
            description STA-IoT
            mtu 1500
        }
        vif 30 {
            address 192.168.30.254/24
            description STA-GUEST
            mtu 1500
        }
    }
}
service {
    dhcp-server {
        shared-network-name STA-STAFF {
            subnet 10.10.48.0/24 {
                default-router 10.10.48.254
                dns-server 8.8.8.8
                dns-server 8.8.4.4
                start 10.10.48.10 {
                    stop 10.10.48.240
                }
            }
        }
    }
    gui {
    }
    ssh {
    }
}
system {
    login {
        user ubnt {
            authentication {
                encrypted-password ****************
            }
            level admin
        }
    }
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
}
END_COMMENT