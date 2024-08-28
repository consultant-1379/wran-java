#!/usr/bin/perl

use warnings;


sub spawn {
    $pid = fork;
    unless ($pid) {
        exec "@_";
    }
    $pid
}

#my $cmd="ls -l";


@pids = ();
for $i (1..20) {
    $cmd = "sleep $i; echo \$\$";
    $pid = spawn $cmd;
    print "$pid: '$cmd'\n";
    push @pids, $pid;
    if ($i > 10) {
        $pid = shift @pids;
        waitpid $pid, 0;
        printf "Process $pid ended\n";
    }
}



while (@pids) {
    $pid = shift @pids;
    waitpid $pid, 0;
    printf "Process $pid ended\n";
}
