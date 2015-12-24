# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 1000                         ;# max packet in ifq
set val(nn)     11                         ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1129                      ;# X dimension of topography
set val(y)      665                      ;# Y dimension of topography
set val(stop)   10.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 11 nodes
set n0 [$ns node]
$n0 set X_ 178
$n0 set Y_ 565
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
$n0 shape "rectangular" 
$ns at 0.2 "$n0 add-mark m1 blue square"
$ns at 0.3 "$n0 add-mark m2 red square"
$ns at 0.4 "$n0 add-mark m3 green square"
$ns at 0.5 "$n0 add-mark m4 yellow square"
$ns at 0.6 "$n0 add-mark m5 purple square"
$ns at 0.0 "$n0 label SENDER"

set n1 [$ns node]
$n1 set X_ 402
$n1 set Y_ 500
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
$ns at 0.9 "$n1 add-mark m2 red square"
$ns at 0.9 "$n1 add-mark m3 green square"
$ns at 0.9 "$n1 add-mark m4 yellow square"
$ns at 0.9 "$n1 add-mark m5 purple square"
$ns at 0.0 "$n1 label ENTRY_GUARD"

set n2 [$ns node]
$n2 set X_ 604
$n2 set Y_ 499
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
$ns at 1.0 "$n2 add-mark m3 green square"
$ns at 1.0 "$n2 add-mark m4 yellow square"
$ns at 1.0 "$n2 add-mark m5 purple square"

set n3 [$ns node]
$n3 set X_ 801
$n3 set Y_ 498
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
$ns at 1.1 "$n3 add-mark m4 yellow square"
$ns at 1.1 "$n3 add-mark m5 purple square"

set n4 [$ns node]
$n4 set X_ 401
$n4 set Y_ 297
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
$ns at 1.0 "$n4 add-mark m3 green square"
$ns at 1.0 "$n4 add-mark m4 yellow square"
$ns at 1.0 "$n4 add-mark m5 purple square"

set n5 [$ns node]
$n5 set X_ 603
$n5 set Y_ 297
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
$ns at 1.1 "$n5 add-mark m4 yellow square"
$ns at 1.1 "$n5 add-mark m5 purple square"
$ns at 0.0 "$n5 label TOR__ROUTERS "

set n6 [$ns node]
$n6 set X_ 800
$n6 set Y_ 297
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
$ns at 1.2 "$n6 add-mark m5 purple square"

set n7 [$ns node]
$n7 set X_ 399
$n7 set Y_ 98
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
$ns at 1.1 "$n7 add-mark m4 yellow square"
$ns at 1.1 "$n7 add-mark m5 purple square"

set n8 [$ns node]
$n8 set X_ 601
$n8 set Y_ 99
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
$ns at 1.2 "$n8 add-mark m5 purple square"

set n9 [$ns node]
$n9 set X_ 798
$n9 set Y_ 98
$n9 set Z_ 0.0
$ns initial_node_pos $n9 20
$ns at 0.0 "$n9 label EXIT_RELAY"

set n10 [$ns node]
$n10 set X_ 1029
$n10 set Y_ 43
$n10 set Z_ 0.0
$ns initial_node_pos $n10 20
$n10 shape "rectangular" 
$ns at 0.0 "$n10 label RECEIVER"

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n10 $sink1
$ns connect $tcp0 $sink1
$tcp0 set packetSize_ 1000


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.5 "$ftp0 start"
$ns at 10.0 "$ftp0 stop"


#=================================
#             Record Procedure
#=================================

proc record {} {
global sink1 f0
set ns [Simulator instance]
set time 1.5
set bw0 [$sink1 set bytes_]

set now [$ns now]
puts $f0 "$now [expr $bw0/$time*8/1000]"

$sink1 set bytes_ 0

$ns at [expr $now+$time] "record"
}


set f0 [open graph.tr w]

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    #global ns tracefile namfile
    #$ns flush-trace
    #close $tracefile
    #close $namfile
    exec nam out.nam &
    global f0
    close $f0

    exec xgraph graph.tr -geometry 800x400 &
    exit 0
}

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns at 0.3 "$ns trace-annotate \"Sender is Performing Multiple Encryption. Multiple Layes of encrypted data are created and to intended receiver through TOR Routers.\""
$ns at 1.0 "$ns trace-annotate \"At each TOR Router Decryption performed. i.e one layer of encrypted data is removed.\""
$ns at 1.2 "$ns trace-annotate \"Router-9(Exit Relay) removes the last layer of encrypted data and send original msg to Receiver.\""
$ns at 0.0 "record"
$ns run
