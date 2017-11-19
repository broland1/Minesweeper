use strict;
use warnings;

#Class fields
my $mine = -1;
my $flag = 10;
my $uncov = 20;
my $invalid = -9000;

#Mapping of display values
my $map = {$flag => '*', 
        0 => 'b', 1 => 'b', 2=> 'b', 3=>'b', 4=>'b', 5=>'b', 6=>'b', 7=>'b', 8=>'b',
        10 => 'f', 11 => 'f', 12=> 'f', 13=>'f', 14=>'f', 15=>'f', 16=>'f', 17=>'f', 18=>'f',
        20 => ' ', 21 => '1', 22=> '2', 23=>'2', 24=>'4', 25=>'5', 26=>'6', 27=>'7', 28=>'8',
        };

#Checks to see if the space is in range (valid)
sub valid {
  my ($self, $x, $y) = @_;
  return $self->{row} > $x and $self->{col} > $y and $x > 0 and $y > 0;
}

#Checks to see if the space is type (Depreciated)
sub typed {
  my ($self, $x, $y) = @_;
  if ($self->valid($x,$y)){
    return ($self->{board}[$x][$y] < 0 or $self->{board}[$x][$y] >= $flag); 
  }
  return 0;
}

#Gets what needs to be displayed on the space, see $map (Throws exception if out of bounds)
sub getSpace {
  my ($self, $x, $y) = @_;
  return $map->{$self->get($x,$y)};
}

#Gets the raw space value (Throws exception if out of bounds)
sub get {
  my ($self, $x, $y) = @_;
  die unless $self->valid($x,$y);
  return $self->{board}[$x][$y];
}

#Sets the raw space value (Throws exception if out of bounds)
sub set {
  my ($self, $x, $y, $n) = @_;
  die unless $self->valid($x,$y);
  $self->{board}[$x][$y] = $n;
}

#Toggles the flag flag (Throws exception if out of bounds)
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

#Generates the board, has a safe space around the x and y coordinate (Throws exception if out of bounds)
sub generate{
  my ($self, $x, $y) = @_;
  my $needMines = $self->{mines};

  die unless $self->valid($x,$y);

  my $xR;
  my $yR;
  while ($needMines > 0){
    $xR = rand($self->{col});
    $yR = rand($self->{row});
    if ($xR !~ [($x-1)..($x+1)] and $yR !~ [($y-1)..($y+1)]){
      $needMines-- if addMine($xR,$yR);
    }
  }
}

#Adds a mine at the given location, the increments the surrounding blocks
sub addMine{
  my ($self, $x, $y) = @_;
  if ($self->get($x, $y) == $mine){
    return 0;
  }
  foreach my $_x (-1..1){
    foreach my $_y (-1..1){
      $self->set($x + $_x, $y + $_y, $self->get($x + $_x, $y + $_y) + 1) if $self->valid($x + $_x, $y + $_y) and $self->get($x + $_x, $y + $_y) ~~ [0..8];
    }
  }
  return 1;
}

#Used to uncover a space and the surrounding area (Throws exception if the initial space is out of bounds)
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

#Constructor (Columns, Rows, Mines)
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