class snmpcollector::install (
	String $version = 'latest'
)
{

	$_packages = [
		'build-essential',
		'bison',
		'openssl',
		'curl',
		'git-core',
		'zlib1g',
		'zlib1g-dev',
		'libssl-dev',
		'libyaml-dev',
		'libxml2-dev',
		'autoconf',
		'libc6-dev',
		'ncurses-dev',
		'automake',
		'libtool'
	]


  if $facts['os']['distro']['codename'] == 'bionic' {
		$packages = concat($_packages, ['libreadline7', 'libreadline-dev'])
	} else {
		$packages = concat($_packages, ['libreadline6', 'libreadline6-dev'])
	}

	$puppet_gems = [
		'rest-client',
		'json'
	]

	$package_name = "snmpcollector_${version}_amd64"

	# Dependency for Package install
	package{ $packages :
		ensure => latest,
	} ->

	# Gem requirements
	package { $puppet_gems:
    	ensure   => 'installed',
    	provider => 'puppet_gem',
  	} ->

	# Pull down the required version deb and install.
	snmpcollector::remote_package { $package_name :
		url => "http://snmpcollector-rel.s3.amazonaws.com/builds/snmpcollector_${version}_amd64.deb",
		creates => "/usr/sbin/snmpcollector",
	}

}