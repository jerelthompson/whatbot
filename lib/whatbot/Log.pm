###########################################################################
# whatbot/Log.pm
###########################################################################
# log handler for whatbot
###########################################################################
# the whatbot project - http://www.whatbot.org
###########################################################################

use MooseX::Declare;

class whatbot::Log {
    use POSIX qw(strftime);

    has 'log_directory' => ( is	=> 'rw', isa => 'Str', required => 1 );
    has 'last_error'    => ( is	=> 'rw', isa => 'Str' );
    has 'name'          => ( is => 'rw', isa => 'Maybe[Str]' );

    method BUILD ( $log_dir ) {
    	binmode( STDOUT, ':utf8' );
    	unless ( -e $self->log_directory ) {
    	    if ( $self->log_directory and length( $self->log_directory ) > 3 ) {
    	        my $result = mkdir( $self->log_directory );
    	        $self->write('Created directory "' . $self->log_directory . '".') if ($result);
    	    }
    	    die 'ERROR: Cannot find log directory "' . $self->log_directory . '", could not create.';
    	}
	
    	$self->write('whatbot::Log loaded successfully.');
    }

    method error ( Str $entry ) {
        $self->last_error($entry);
        $self->write( '*ERROR: ' . $entry );
        warn $entry;
    }

    method write ( Str $entry ) {
        if ( $self->name ) {
            $entry = sprintf( '[%s] ', $self->name ) . $entry;
            $self->name(undef);
        }

    	my $output = '[' . strftime( '%Y-%m-%d %H:%M:%S', localtime(time) ) . '] ' . $entry . "\n";
    	print $output;
        open( LOG, '>>' . $self->log_directory . '/whatbot.log' )
            or die 'Cannot open logfile for writing: ' . $!;
        binmode( LOG, ':utf8' );
        print LOG $output;
        close(LOG);
    }
}

1;

=pod

=head1 NAME

whatbot::Log - Provides logging from within whatbot

=head1 SYNOPSIS

 extends 'whatbot::Component';
 
 $self->log->write('This is a message.');
 $self->log->error('This is an error!');

=head1 DESCRIPTION

whatbot::Log provides basic log functionality from within whatbot. whatbot
loads this class during startup, and is available under the 'log' accessor
in any module subclassed from whatbot::Component and loaded properly,
including Commands.

=head1 METHODS

=over 4

=item write( $line )

Writes message to standard out / log file.

=item error( $line )

Writes message to standard out / log file and 'warn's to STDERR.

=back

=head1 INHERITANCE

=over 4

=item whatbot::Log

=back

=head1 LICENSE/COPYRIGHT

Be excellent to each other and party on, dudes.

=cut