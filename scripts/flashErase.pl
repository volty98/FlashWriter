#! /usr/bin/env perl

use Device::SerialPort;

if (scalar(@ARGV) < 1) {
  print "Usage: flashDump.pl /dev/tty.usbserial-XXXX [-dump,-crc]";
  exit;
}

my $port = Device::SerialPort->new($ARGV[0]);
$port->databits(8);
$port->baudrate(19200);
$port->parity("none");
$port->stopbits(1);

# wait for connect
my $received = '';
while (1) {
  $received = $received . $port->read(1);
  if ($received =~ /checksum chip/) {
    last;
  }
}

$port->write("DEL");

my $read;
$received = '';
while (1) {
  $read = $port->read(1);
  print $read;
  $received = $received . $read;
  if ($received =~ /completed!/) {
    last;
  }
}

print "$received\n";
