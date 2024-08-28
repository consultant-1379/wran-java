#!/usr/bin/perl

use POSIX ":sys_wait_h";

%pids = ();
$npids = 0;
$MAX_CHILDREN = 10;

$SIG{CHLD} = \&REAPER;

sub REAPER {
    my $child;
    while (($child = waitpid(-1, WNOHANG)) > 0) {
        # print "$child ($pids{$child}) died!!!\n";
        delete $pids{$child};
        $npids--;
        # print "Child died ($npids still running)\n";
    }
    $SIG{CHLD} = \&REAPER;
}

sub launch {
    my ($cmd) = @_;
    if ($npids >= $MAX_CHILDREN) {
        # print "Zzzz...\n";
        sleep;
    }
    my $pid = fork;
    unless ($pid) {
        exec $cmd;
    }
    $pids{$pid} = $cmd;
    $npids++;
}

sub waitall {
    while ($npids) {
        sleep;
    }
}

#for $i (<*.gz>) {
#    $cmd = "gzip -d \"$i\"";

for $i (1..20) {
    $cmd = "sleep $i; echo \$\$";
    print "Launching $cmd\n";
    launch $cmd;
}

waitall;
