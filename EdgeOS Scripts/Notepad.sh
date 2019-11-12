#EdgeOS Commands Notepad 

#Cmd
stannes-it@243HPR-GW01# show port-forward rule 1
#Output
 description Local_RTP
 forward-to {
     address 192.168.10.20
     port 14000-14019
 }
 original-port 14000-14019
 protocol tcp_udp
[edit]
#Cmd
stannes-it@243HPR-GW01# show port-forward rule 2
#Output
 description Local_SIP
 forward-to {
     address 192.168.10.20
 }
 original-port 5060,5065
 protocol tcp_udp
[edit]

#Cmd's to create VOIP port fowarding rules 
set port-forward rule 1 description Local_RTP
set port-forward rule 1 forward-to address 192.168.10.20
set port-forward rule 1 forward-to port 14000-14019
set port-forward rule 1 original-port 14000-14019
set port-forward rule 1 protocol tcp_udp

set port-forward rule 2 description Local_SIP
set port-forward rule 2 forward-to address 192.168.10.20
set port-forward rule 2 original-port 5060,5065
set port-forward rule 2 protocol tcp_udp

#How to enable Link Layer Discovery Protocol (LLDP) for specific interface 
set service lldp interface eth1
set service lldp interface eth2

#How to enable for all interfaces 
set service lldp interface all

#Cmds to enable VLAN access. PVID = untagged traffic (access port). VID = tagged traffice (trunk port)
set interfaces switch switch0 switch-port interface eth4 vlan pvid 10
set interfaces switch switch0 switch-port interface eth4 vlan vid 20

#Ethernet running configuration
bridge br0 {
     address 10.10.48.254/24
     aging 300
     bridged-conntrack disable
     description "Local Bridge"
     hello-time 2
     max-age 20
     priority 32768
     promiscuous enable
     stp false
 }
 ethernet eth0 {
     description "Internet (PPPoE)"
     duplex auto
     poe {
         output off
     }
     pppoe 0 {
         default-route auto
         firewall {
             in {
                 name WAN_IN
             }
             local {
                 name WAN_LOCAL
             }
         }
         mtu 1492
         name-server auto
         password 6zcx6MvMHK
         user-id 01132789291@b2bdsl
     }
     speed auto
 }
 ethernet eth1 {
     bridge-group {
         bridge br0
     }
     description "Local Bridge"
     duplex auto
     poe {
         output 48v
     }
     speed auto
 }
 ethernet eth2 {
     description "Local Bridge"
     duplex auto
     poe {
         output off
     }
     speed auto
 }
 ethernet eth3 {
     description "Local Bridge"
     duplex auto
     poe {
         output off
     }
     speed auto
 }
 ethernet eth4 {
     description "Local Bridge"
     duplex auto
     poe {
         output 24v
     }
     speed auto
 }
 loopback lo {
 }
 switch switch0 {
     bridge-group {
         bridge br0
     }
     description "Local Bridge"
     mtu 1500
     switch-port {
         interface eth2 {
         }
         interface eth3 {
         }
         interface eth4 {
         }
         vlan-aware disable
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