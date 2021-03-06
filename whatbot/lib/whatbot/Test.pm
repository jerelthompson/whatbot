use MooseX::Declare;
use Method::Signatures::Modifiers;

class whatbot::Test {
	use whatbot;
	use whatbot::Log;
	use whatbot::Component::Base;
	use whatbot::Config;
	use whatbot::Database::SQLite;

	has config_hash => ( is => 'rw', isa => 'HashRef' );

	method get_default_config() {
		my $db = '/tmp/.whatbot.test.db';
		if ( -e $db ) {
			unlink($db);
		}
		return whatbot::Config->new(
			'config_hash' => ( $self->config_hash or {
				 'io' => [],
				 'database' => {
					 'handler'  => 'SQLite',
					 'database' => $db,
				}
			} )
		);
	}

	method get_base_component() {
		# Build base component
		my $base_component = whatbot::Component::Base->new(
			'log'    => whatbot::Log->new(),
			'config' => $self->get_default_config()
		);
		$base_component->log->log_enabled(0);
		$base_component->parent( whatbot->new({ 'base_component' => $base_component }) );
		my $database = whatbot::Database::SQLite->new(
		    'base_component' => $base_component
		);
		$database->connect();
		$base_component->database($database);
		$base_component->log->log_enabled(1);

		return $base_component;
	}

	method initialize_models( $base_component ) {
		my $whatbot = $base_component->parent;
		$base_component->log->log_enabled(0);
		$whatbot->_initialize_models($base_component);
		$whatbot->_initialize_models($base_component);
		$base_component->log->log_enabled(1);
		return;
	}
}