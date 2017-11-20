package mine;

require "./board.pl";

use List::Util qw[min max];
use Tk;
use Tk::DialogBox;
use strict;
use warnings;


my $numberofmines = 0;
my $firstclick = 0;
my $number = 0;
my $frame1;
my $frame2;
my $counter;
my $board;
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

##config();

MainLoop;

##Subroutines

sub config{
  my $length = shift;
  my $height = shift;
  my $numberofmines = shift; 
  deleteboard($length, $height);
  $firstclick = 0;
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
  $frame2->destroy() if Tk::Exists($frame2);
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

  my $frame1 = $mainWindow->Frame(-borderwidth => 2, -relief => 'groove');
  $counter = $frame1->Label(-text=>$number)->pack(-side=>'top', -anchor=>'e');
  $frame1->pack(-side=>'top');
  
  my $frame2 = $mainWindow->Frame(-borderwidth => 2, -relief => 'groove');
  for(my $z = 0; $z < $height; $z = $z + 1) {
	for(my $a = 0; $a < $length; $a = $a + 1) {
		$button[$z][$a] = $frame2->Button(-width => 2, -height => 1, -command => [\&dig, $z, $a])->grid(-column => $z, -row => $a);
		$button[$z][$a]->bind( '<3>', [\&flag, $z, $a]);
	}
  }
  $frame2->pack;
}

sub counter{
  my $add = shift;
  $number = $number + $add;
  print $number;
  $counter->configure(-text=>$number);
}

sub flag{
  shift;
  my $x = shift;
  print "$x + n";
  my $y = shift;

  if($firstclick == 0) {
	return;
  }
  my $returnvalue = $board->get($x, $y);
  
  if($returnvalue >= 10) {
	$button[$x][$y]->configure(-text => " ", -state => 'normal');
	counter(-1);
  } else {
	$button[$x][$y]->configure(-text => "k", -state => 'normal');
  	counter(1);
  }

  $board->toggleFlag($x, $y);
  
}

sub update{

  for(my $z = 0; $z < 30; $z = $z + 1) {
	for(my $a = 0; $a < 30; $a = $a + 1) {
		my $returnvalue = $board->get($z, $a);
		if($returnvalue == 20) {
			
		} elsif (1) {

		}
	}
  }
}

sub dig{
  my $x = shift;
  my $y = shift;

  if($firstclick == 0) {
	$firstclick = 1;
	$board->generate($x, $y);
	$board->uncover($x, $y);
	showgroup($x,$y);
	print "board generated";
	return;
  }

  my $returnvalue = $board->get($x, $y);
  
  if($returnvalue == -1) {
	my $gameover = $mainWindow->messageBox(-title => 'Game Over', -message => "You have lost\n Do you wish to play again?", -type => "yesno");
	if($gameover eq 'Yes') {
		config(16,16,40);
	} else {
		$mainWindow->destroy;
		sub{ exit };	
	}
  } elsif($returnvalue == 0) {
	showgroup($x, $y);
  } else {
	show($x, $y, $returnvalue);
  }
}

sub show{
  my $x = shift;
  my $y = shift;
  my $returnvalue = shift;

  $board->uncover($x, $y);

  $button[$x][$y]->configure(-text=>$returnvalue,-relief=>'flat',-background=>'white',-state=>'disable');
  $button[$x][$y]->bind("<3>", undef);
  #$button[$x][$y]->destroy;
  #$button[$x][$y] = $frame2->Label(-text => $returnvalue, -width => 2, -height => 1,)->grid(-column => $x, -row => $y);
}

sub showgroup{
  my $x = shift;
  my $y = shift;

  my $text = " ";

  $board->uncover($x, $y);

  my $returnvalue = $board->get($x,$y);
  
  $returnvalue = $returnvalue % 20;
  if($returnvalue == 0) {
  	$returnvalue = " ";
  } 

  $button[$x][$y]->configure(-text=>$returnvalue,-relief=>'flat',-background=>'white',-state=>'disable');
  $button[$x][$y]->bind("<3>", undef);

  for(my $z = 0; $z < $board->{col}; $z = $z + 1) {
	for(my $a = 0; $a < $board->{row}; $a = $a + 1) {
		if($board->get($z, $a) >= 20) {
			$returnvalue = $board->get($z,$a);
  
  			$returnvalue = $returnvalue % 20;
 			if($returnvalue == 0) {
  				$returnvalue = " ";
			} 
		
 			$button[$z][$a]->configure(-text=>$returnvalue,-relief=>'flat',-background=>'white',-state=>'disable');
  			$button[$z][$a]->bind("<3>", undef);
		}		
	}
  }
}
