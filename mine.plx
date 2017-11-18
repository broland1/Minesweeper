package mine;

require "./board.pl";

use List::Util qw[min max];
use Tk;
use Tk::DialogBox;
use strict;
use warnings;


my $numberofmines = 0;
my $firstclick = 0;
my $board;
my @flagboard;
my @button;

my $mainWindow = MainWindow->new(-title => 'Minesweeper');
$mainWindow->configure(-background => '#e3e3e3', -cursor => 'left_ptr');
$mainWindow->geometry('1024x768');

my $menu = $mainWindow->Menu;
$menu->cascade(
  -label => '~Setting', -tearoff => 0,
  -menuitems => [
    [command => 'New Easy Game', -command => [\&new_game, 9, 9, 10]],
    [command => 'New Intermediate Game', -command => [\&new_game, 16, 16, 40]],
    [command => 'New Hard Game', -command => [\&new_game, 16, 30, 99]],
    [command => '~Quit', -command => sub{ exit }]
  ]
);
$mainWindow->configure(-menu => $menu);

config();

MainLoop;

##Subroutines

sub config{
  $length = shift;
  $height = shift;
  $numberofmines = shift; 
  new_game($length, $height, $numberofmines);  
}

sub new_game{
  $length = shift;
  $height = shift;
  $numberofmines = shift;
  $board = new board($length, $height, $numberofmines);
  createUI($length, $height);
}

sub createUI{
  $length = shift;
  $height = shift;

  for(my $z = 0; $z < $height; $z = $z + 1) {
	for(my $a = 0; $a < $length; $a = $a + 1) {
		$button[$z][$a] = Button(-command => [\&dig, $z, $a])->grid(-column => $z, -row => $a);
		$button[$z][$a] -> bind (Button3 => [\&flag, $z, $a]);
	}
  }
}

sub dig{
  $x = shift;
  $y = shift;
  my $returnvalue = $board->get($x, $y);
  
  if($returnvalue == 9) {
	my $gameover = $mainWindow->messagebox(-title => 'Game Over', -massage => "You have lost");
	#new_game();
  } elsif($returnvalue > 0) {
	show($x, $y, $returnvalue);
  } else {
	uncover($x, $y);
  }
}


=pod
sub init_board{

  for(my $z = 0; $z < $width; $z = $z + 1) {
	my @array;
	$array[$length - 1] = 0;
	@board[$z] = \@array;
  }

  ## push @board, [(0)*$width] for (0..$length);
  ## push @flagboard, [(0)*$width] for (0..$length);  

  my $setnumberofmines = $numberofmines; 
  
  while($setnumberofmines > 0) {
	my $xplace = int(rand($length - 1));
	my $yplace = int(rand($width - 1));
	
	if($board[$xplace][$yplace] == 0) {
		$board[$xplace][$yplace]  = 9;
		$setnumberofmines = $setnumberofmines - 1;
		setAdjacentNumber($xplace, $yplace);
	}	
  }
}
=pod
sub setAdjacentNumber{
  my $x = shift;
  my $y = shift;

  for(my $z = max($x-1,0); $x < min($x+1,$width); $z = $z + 1) {
	for(my $a = max($y-1,0); $y < min($y+1,$length); $a = $a + 1) {
		print('\$z: $z \n');
		print('\$y: $y \n');
		#print("Board: " + @board + "\n");
		
		if($z == $x && $a == $y) {
			next;
		}
		if($board[$z][$a] == 9) {
			next;
		}
		$board[$z][$a] = $board[$z][$a] + 1;
	}
  }
}

sub createUI{

  for(my $z = 0; $z < $width; $z = $z + 1) {
	for(my $a = 0; $a < $length; $a = $a + 1) {
		$button[$z][$a] = Button(-command => [\&dig, $z, $a])->grid(-column => $z, -row => $a);
		$button[$z][$a] -> bind (Button3 => [\&flag, $z, $a]);
	}
  }
}
=pod
sub dig{
  my $x = shift;
  my $y = shift;

  my $returnvalue = $board[$x][$y];

  if($returnvalue == 9) {
	my $gameover = $mainWindow->messagebox(-title => 'Game Over', -massage => "You have lost");
	new_game();
  } elsif($returnvalue > 0) {
	show($x, $y, $returnvalue);
  } else {
	uncover($x, $y);
  }
}

sub show{
  my $x = shift;
  my $y = shift;
  my $number = shift;

  $button[$x][$y] -> destroy if TK::Exists($button[$x][$y]);

  $mainWindow -> Label(-text $number) -> grid(-column $x, -row $y);

}
=pod
sub flag{
  my $x = shift;
  my $y = shift;

  if($flagboard[$x][$y] == 1) {	
        $button[$x][$y] -> configure(-text => "k", -state => 'disabled');	
  } else {
  	$button[$x][$y] -> configure(-text => "", -state => 'normal');
  }
}
=pod
sub uncover{
  my $x = shift;
  my $y = shift;

  show($x, $y, 0);

  my $returnvalue = $board[$x][$y];

  if($returnvalue == 0){
  	for(my $z = max($x-1,0); $x < min($x+1,$width); $z = $z + 1) {
		for(my $a = max($y-1,0); $y < min($y+1,$length); $a = $a + 1) {
			uncover($z, $a);
		}
 	}
  }
}

