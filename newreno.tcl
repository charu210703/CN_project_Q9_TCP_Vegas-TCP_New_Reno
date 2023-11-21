set ns [new Simulator]

set namfile [open newreno.nam w]
$ns namtrace-all $namfile
set tracefile [open newreno.tr w]
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


set tcpNewReno [new Agent/TCP/Newreno]
$tcpNewReno set class_ 1
$tcpNewReno set window_ 100
$tcpNewReno set packetSize_ 960
$ns attach-agent $A $tcpNewReno

$tcpNewReno attach $tracefile
$tcpNewReno tracevar cwnd_
$tcpNewReno tracevar ssthresh_
$tcpNewReno tracevar ack_
$tcpNewReno tracevar maxseq_
$tcpNewReno set fid_ 0

set end1 [new Agent/TCPSink]
$ns attach-agent $B $end1

$ns connect $tcpNewReno $end1

set myftp1 [new Application/FTP]
$myftp1 attach-agent $tcpNewReno
$ns at 0.0 "$myftp1 start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource outfile} {
    global ns
    set now [$ns now]
    set cwnd [$tcpSource set cwnd_]

    
    puts $outfile "$now $cwnd"
    $ns at [expr $now+0.1] "plotWindow $tcpSource $outfile"
}

set outfileNewReno [open "newreno.xg" w]
$ns at 0.0 "plotWindow $tcpNewReno $outfileNewReno"
$ns at 10.1 "exec xgraph -lw 2 -geometry 800x400 -x1 'RTT (seconds)' -y1 'Congestion Window Size(MSS)' newreno.xg"

after 1000 {
    exec nam newreno.nam
}

$ns run