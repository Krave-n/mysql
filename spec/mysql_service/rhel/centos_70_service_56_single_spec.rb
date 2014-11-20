require 'spec_helper'

describe 'mysql_service::single on centos-7.0' do
  let(:centos_70_service_56_single) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '7.0',
      :step_into => 'mysql_service'
      ) do |node|
        node.set['mysql']['version'] = '5.6'
      end.converge('mysql_service::single')
  end

  before do
    stub_command('/usr/bin/test -f /var/lib/mysql-default/mysql/user.frm').and_return(true)
  end

  # Resource in mysql_service::single
  context 'compiling the test recipe' do
    it 'creates mysql_service[default]' do
      expect(centos_70_service_56_single).to create_mysql_service('default')
    end
  end

  # mysql_service resource internal implementation
  context 'stepping into mysql_service[default] resource' do
    it 'installs package[default :create mysql-community-server]' do
      expect(centos_70_service_56_single).to install_package('default :create mysql-community-server')
        .with(:package_name => 'mysql-community-server', :version => nil)
    end

    it 'creates group[default :create mysql]' do
      expect(centos_70_service_56_single).to create_group('default :create mysql')
        .with(:group_name => 'mysql')
    end

    it 'creates user[default :create mysql]' do
      expect(centos_70_service_56_single).to create_user('default :create mysql')
        .with(:username => 'mysql')
    end

    it 'deletes file[default :create /etc/mysql/my.cnf]' do
      expect(centos_70_service_56_single).to delete_file('default :create /etc/mysql/my.cnf')
        .with(:path => '/etc/mysql/my.cnf')
    end

    it 'deletes file[default :create /etc/my.cnf]' do
      expect(centos_70_service_56_single).to delete_file('default :create /etc/my.cnf')
        .with(:path => '/etc/my.cnf')
    end

    it 'creates directory[default :create /etc/mysql-default]' do
      expect(centos_70_service_56_single).to create_directory('default :create /etc/mysql-default')
        .with(
        :path => '/etc/mysql-default',
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'creates directory[default :create /etc/mysql-default/conf.d]' do
      expect(centos_70_service_56_single).to create_directory('default :create /etc/mysql-default/conf.d')
        .with(
        :path => '/etc/mysql-default/conf.d',
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'creates directory[default :create /var/run/mysql-default]' do
      expect(centos_70_service_56_single).to create_directory('default :create /var/run/mysql-default')
        .with(
        :path => '/var/run/mysql-default',
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'creates directory[default :create /var/log/mysql-default]' do
      expect(centos_70_service_56_single).to create_directory('default :create /var/log/mysql-default')
        .with(
        :path => '/var/log/mysql-default',
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'creates directory[default :create /var/lib/mysql-default]' do
      expect(centos_70_service_56_single).to create_directory('default :create /var/lib/mysql-default')
        .with(
        :path => '/var/lib/mysql-default',
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'creates template[default :create /etc/mysql-default/my.cnf]' do
      expect(centos_70_service_56_single).to create_template('default :create /etc/mysql-default/my.cnf')
        .with(
        :path => '/etc/mysql-default/my.cnf',
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0600'
        )
    end

    it 'runs bash[default :create initialize mysql database]' do
      expect(centos_70_service_56_single).to_not run_bash('default :create initialize mysql database')
        .with(
        :cwd => '/var/lib/mysql-default'
        )
    end

    it 'runs bash[default :create initial records]' do
      expect(centos_70_service_56_single).to_not run_bash('default :create initial records')
    end

    it 'create template[default :start /etc/init.d/mysql-default]' do
      expect(centos_70_service_56_single).to create_template('default :start /etc/init.d/mysql-default')
        .with(
        :path => '/etc/init.d/mysql-default',
        :source => 'sysvinit/rhel/sysvinit.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0755',
        :cookbook => 'mysql'
        )
    end

    it 'starts service[default :start mysql-default]' do
      expect(centos_70_service_56_single).to start_service('default :start mysql-default')
        .with(
        :service_name => 'mysql-default',
        :provider => Chef::Provider::Service::Init
        )
    end
  end
end
