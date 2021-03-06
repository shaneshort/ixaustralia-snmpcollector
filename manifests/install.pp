class snmpcollector::install (
	String $version = 'latest'
)
{

	$_packages = [
		'build-essential',
		'bison',
		'openssl',
		'curl',
		'zlib1g',
		'zlib1g-dev',
		'libssl-dev',
		'libyaml-dev',
		'libxml2-dev',
		'autoconf',
		'libc6-dev',
		'automake',
		'libtool'
	]


  if $facts['os']['distro']['codename'] == 'bionic' {
		$packages = concat($_packages, ['libreadline7', 'libreadline-dev', 'git', 'libncurses5-dev'])
	} else {
		$packages = concat($_packages, ['libreadline6', 'libreadline6-dev', 'ncurses-dev', 'git-core'])
	}

	$puppet_gems = [
		'rest-client',
		'json'
	]

  if $facts['ruby']['sitedir'] =~ /opt/ {
    $gem_provider = 'puppet_gem'
  } else {
    $gem_provider = 'gem'
  }


	$package_name = "snmpcollector_${version}_amd64"

	# Dependency for Package install
	package{ $packages :
		ensure => latest,
	} ->

	# Gem requirements
	package { $puppet_gems:
    	ensure   => 'installed',
    	provider => $gem_provider,
  	} ->

	# Pull down the required version deb and install.
	snmpcollector::remote_package { $package_name :
		url => "http://snmpcollector-rel.s3.amazonaws.com/builds/snmpcollector_${version}_amd64.deb",
		creates => "/usr/sbin/snmpcollector",
	}

}
