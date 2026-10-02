<?php
// Environment-driven Moodle config for the docker-compose deployment.
unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'pgsql';
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('MOODLE_DB_HOST') ?: 'pgbouncer';
$CFG->dbname    = getenv('MOODLE_DB_NAME') ?: 'moodle';
$CFG->dbuser    = getenv('MOODLE_DB_USER') ?: 'moodle';
$CFG->dbpass    = getenv('MOODLE_DB_PASSWORD');
$CFG->prefix    = 'mdl_';
$CFG->dboptions = [
    'dbpersist'      => false,
    'dbport'         => getenv('MOODLE_DB_PORT') ?: '6432',
    'dbsocket'       => '',
    // pgbouncer runs in session mode: Moodle uses server-side cursors, which break
    // under transaction pooling ("cursor does not exist").
    'dbhandlesoptions' => false,
];

$CFG->wwwroot   = getenv('MOODLE_WWWROOT') ?: 'http://localhost:8080';
$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 02777;

if (getenv('MOODLE_SSLPROXY') === 'true') {
    $CFG->sslproxy = true;
}
if (getenv('MOODLE_REVERSEPROXY') === 'true') {
    $CFG->reverseproxy = true;
}

// Postgres advisory locks are session-scoped and break under transaction pooling.
$CFG->lock_factory = '\core\lock\db_record_lock_factory';

// Sessions in Redis.
$CFG->session_handler_class = '\core\session\redis';
$CFG->session_redis_host = getenv('MOODLE_REDIS_HOST') ?: 'redis';
$CFG->session_redis_port = 6379;
$CFG->session_redis_database = 0;
$CFG->session_redis_prefix = 'mdlsess_';
$CFG->session_redis_acquire_lock_timeout = 120;
$CFG->session_redis_lock_expire = 7200;

if (getenv('MOODLE_SMTP_HOST')) {
    $CFG->smtphosts = getenv('MOODLE_SMTP_HOST');
}

// Local PHPUnit (dev only; see docker/README.md).
if (getenv('MOODLE_PHPUNIT') === 'true') {
    $CFG->phpunit_prefix = 'phpu_';
    $CFG->phpunit_dataroot = '/var/www/phpunit_data';
}

require_once(__DIR__ . '/lib/setup.php');
