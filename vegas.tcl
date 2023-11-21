set ns [new Simulator]

set namfile [open vegas.nam w]
$ns namtrace-all $namfile
set tracefile [open vegas.tr w]
$ns trace-all $tracefile

proc finish {} {
    global ns namfile tracefile
    $ns flush-trace
    close $namfile
    close $tracefile
    exit 0
}

set A [$ns node]
set R [$ns node]
set B [$ns node]

$ns duplex-link $A $R 10Mb 10ms DropTail
$ns duplex-link $R $B 800Kb 50ms DropTail

$ns queue-limit $R $B 7

$ns color 0 Blue
$ns duplex-link-op $A $R orient right-up
$ns duplex-link-op $R $B orient right-down
$ns duplex-link-op $R $B queuePos 0.5

set tcpVegas [new Agent/TCP/Vegas]
$tcpVegas set class_ 0
$tcpVegas set window_ 100
$tcpVegas set packetSize_ 960
$ns attach-agent $A $tcpVegas

$tcpVegas attach $tracefile
$tcpVegas tracevar cwnd_
$tcpVegas tracevar ssthresh_
$tcpVegas tracevar ack_
$tcpVegas tracevar maxseq_
$tcpVegas set fid_ 0

set end0 [new Agent/TCPSink]
$ns attach-agent $B $end0

$ns connect $tcpVegas $end0

set myftp [new Application/FTP]
$myftp attach-agent $tcpVegas
$ns at 0.0 "$myftp start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource outfile} {
    global ns
    set now [$ns now]
    set cwnd [$tcpSource set cwnd_]

   
    puts $outfile "$now $cwnd"
    $ns at [expr $now+0.1] "plotWindow $tcpSource $outfile"
}

set outfileVegas [open "vegas.xg" w]
$ns at 0.0 "plotWindow $tcpVegas $outfileVegas"
$ns at 10.1 "exec xgraph -lw 2 -geometry 800x400 -x1 'RTT (seconds)' -y1 'Congestion Window Size(MSS)' vegas.xg"

after 1000 {
    exec nam vegas.nam
}

$ns run