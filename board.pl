use strict;
use warnings;

#Class fields
my $safe = -99;
my $mine = -1;
my $flag = 10;
my $uncov = 20;
my $invalid = -9000;
my $map = {-1 => '*', 
        0 => 'b', 1 => 'b', 2=> 'b', 3=>'b', 4=>'b', 5=>'b', 6=>'b', 7=>'b', 8=>'b',
        10 => 'f', 11 => 'f', 12=> 'f', 13=>'f', 14=>'f', 15=>'f', 16=>'f', 17=>'f', 18=>'f',
        20 => ' ', 21 => '1', 22=> '2', 23=>'2', 24=>'4', 25=>'5', 26=>'6', 27=>'7', 28=>'8',
        };

sub valid {
  my ($self, $x, $y) = @_;
  return $self->{row} > $x and $self->{col} > $y and $x > 0 and $y > 0;
}

sub typed {
  my ($self, $x, $y) = @_;
  if ($self->valid($x,$y)){
    return ($self->{board}[$x][$y] < 0 or $self->{board}[$x][$y] >= $flag); 
  }
  return 0;
}

sub getSpace {
  my ($self, $x, $y) = @_;
  return $map->{$self->get($x,$y)};
}

sub get {
  my ($self, $x, $y) = @_;
  die unless $self->valid($x,$y);
  return $self->{board}[$x][$y];
}

sub set {
  my ($self, $x, $y, $n) = @_;
  die unless $self->valid($x,$y);
  $self->{board}[$x][$y] = $n;
}

sub toggleFlag{
  my ($self, $x, $y) = @_;
  my $val = $self->get($x,$y);
  return if ($val >= $uncov);
  if ($val >= $flag){
    $self->set($x, $y, $val % $flag);
    $self->{flags}++;
  } else {
    $self->set($x, $y, $val + $flag);
    $self->{flags}--;
  }
}

sub generate{
  my ($self, $x, $y) = @_;
}

sub uncover{
  my ($self, $x, $y) = @_;
  my $val = $self->get($x,$y);
  return 0 if ($val == $mine);
  $self->set($x,$y, ($self->get($x,$y) % $flag) + $uncov);
  if ($val == 0){
    foreach my $_x (-1..1){
      foreach my $_y (-1..1){
        $self->uncover($x + $_x, $y + $_y) if $self->valid($x + $_x, $y + $_y);
      }
    }

  }
  return 1;
}

sub _uncover{
  my ($self, $x, $y) = @_;
}

sub new {
  my $class = shift;
  my $self = {};
  $self->{col} = shift;
  $self->{row} = shift;
  $self->{mines} = shift;
  $self->{flags} = $self->{mines};

  foreach my $x (0..($self->{col}-1)){
    foreach my $y (0..($self->{row}-1)){
      $self->{board}[$x][$y] = 0; 
    }
  } 

  return bless $self, $class;
}