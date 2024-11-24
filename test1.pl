#!/usr/bin/perl
use strict;
use warnings;

use feature qw/say/;
use Data::Dumper;

use HiPi qw( :epaper :rpi );

# Just trying to dump board info
use HiPi::RaspberryPi;
print STDERR HiPi::RaspberryPi::dump_board_info();

use HiPi::Interface::EPaper;
my $epd = HiPi::Interface::EPaper->new(
    type     => EPD_PIMORONI_INKY_PHAT_V2,
    device_width => 122,
    device_height => 250,
);
    
$epd->clear_buffer;

my $ctx = $epd->create_context;

my( $w, $h) = $ctx->draw_text(0,0,'Raspberry Pi', 'SansEPD28');

# say Dumper({ctx=>$ctx,w=>$w,h=>$h});

# Draw all raspberrys & perls in centre

# centre of text
my $cx = int( 0.5 + $w / 2);
my $cy = int( 0.5 + $h / 2);

# draw top line centered
{
    my $x = int(0.5 + ($epd->logical_width - $w) / 2);
    my $y = 0;
    $epd->draw_context( $x, $y, $ctx->rotated_context( 0, 0, 0) );
}

# draw bottom line rotated through 180 about its centre
{
    my $x = int(0.5 + ($epd->logical_width - $w) / 2);
    my $y = $epd->logical_height - $h -1;
    $epd->draw_context( $x, $y, $ctx->rotated_context( 180, $cx, $cy) );
}

$ctx->clear_context;

( $w, $h) = $ctx->draw_text(0,0,'Perl', 'SansEPD28');
$cx = int( 0.5 + $w / 2);
$cy = int( 0.5 + $h / 2);

# Perl in red , if available, otherwise will be black
$epd->set_pen( EPD_RED_PEN );
# Perl right
{
    my $x = $epd->logical_width -1;
    my $y = int( 0.5 + ($epd->logical_height - $w) / 2);
    $epd->draw_context( $x, $y, $ctx->rotated_context( 90, 0, 0 ) );
}

# Perl left
{
    my $x = 0;
    my $y = int( 0.5 + ($w + $epd->logical_height) / 2);
    $epd->draw_context( $x, $y, $ctx->rotated_context( -90, 0, 0 ) );
}
$epd->display_update;
$epd->display_sleep;
1;
