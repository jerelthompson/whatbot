###########################################################################
# whatbot/Command/Awareness.pm
###########################################################################
# This is basic, just responds to a name.
###########################################################################
# the whatbot project - http://www.whatbot.org
###########################################################################

package whatbot::Command::Awareness;
use Moose;
BEGIN { extends 'whatbot::Command' }
use namespace::autoclean;

sub register {
	my ($self) = @_;

	$self->command_priority('Primary');
	$self->require_direct(0);
}

sub message : Monitor {
    my ( $self, $message_ref ) = @_;

	# Self-awareness
	my $me = $message_ref->me;
	return 'what' if ( $message_ref->content =~ /^$me[\?\!\.]?$/i );

	# Greeting
	my @greetings = (
		'hey',
		'sup',
		"what's up",
		'yo',
		'word',
		'hi',
		'hello',
	);
	if (
	    $message_ref->is_direct
	    and $message_ref->content =~ /^(hey|hi|hello|word|sup|morning|good morning)[\?\!\. ]*?$/
	) {
		return $greetings[rand @greetings] . ', ' . $message_ref->from . '.';
	}

	return;
}

sub last_message : GlobalRegEx('^show last message$') {
    my ( $self ) = @_;

    return $self->parent->last_message;
}

__PACKAGE__->meta->make_immutable;

1;
