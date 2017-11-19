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
    [command => 'New Easy Game', -command => [\&config, 9, 9, 10]],
    [command => 'New Intermediate Game', -command => [\&config, 16, 16, 40]],
    [command => 'New Hard Game', -command => [\&config, 16, 30, 99]],
    [command => '~Quit', -command => sub{ exit }]
  ]
);
$mainWindow->configure(-menu => $menu);

config();

MainLoop;

##Subroutines

sub config{
  my $length = shift;
  my $height = shift;
  my $numberofmines = shift; 
  deleteboard($length, $height);
  new_game($length, $height, $numberofmines);  
}

sub deleteboard{
  my $length = shift;
  my $height = shift;

  for(my $z = 0; $z < 30; $z = $z + 1) {
	for(my $a = 0; $a < 30; $a = $a + 1) {
		$button[$z][$a]->destroy if(exists $button[$z][$a] && defined $button[$z][$a]);
	}
  }
}

sub new_game{
  my $length = shift;
  my $height = shift;
  my $numberofmines = shift;
  $board = new board($length, $height, $numberofmines);
  createUI($length, $height);
}

sub createUI{
  my $length = shift;
  my $height = shift;

  for(my $z = 0; $z < $height; $z = $z + 1) {
	for(my $a = 0; $a < $length; $a = $a + 1) {
		$button[$z][$a] = $mainWindow->Button(-width => 2, -height => 1, -command => [\&dig, $z, $a])->grid(-column => $z, -row => $a);
		$button[$z][$a]->bind( '<3>', [\&flag, $z, $a]);
	}
  }
}


sub flag{
  shift;
  my $x = shift;
  print "$x + n";
  my $y = shift;

  my $returnvalue = 0;##$board->get($x, $y);

  if($returnvalue == 10) {
	$button[$x][$y]->configure(-text => " ", -state => 'normal');
  } else {
	$button[$x][$y]->configure(-text => "k", -state => 'normal');
	print "Hello";
  }

  $board->toggleFlag($x, $y);
}

sub update{

  for(my $z = 0; $z < 30; $z = $z + 1) {
	for(my $a = 0; $a < 30; $a = $a + 1) {
		my $returnvalue = $board->get($z, $a);
		if(1) {
		
		} elsif (1) {

		}
	}
  }
}

sub dig{
  my $x = shift;
  my $y = shift;
  my $returnvalue = $board->get($x, $y);
  
  if($returnvalue == -1) {
	my $gameover = $mainWindow->messageBox(-title => 'Game Over', -message => "You have lost\n Do you wish to play again?", -type => "yesno");
	if($gameover eq 'Yes') {
		config(16,16,40);
	} else {
		$mainWindow->destroy;
		sub{ exit };	
	}
  } elsif($returnvalue > 0) {
	show($x, $y, $returnvalue);
  } else {
	uncover($x, $y);
  }
}

