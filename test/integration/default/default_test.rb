# # encoding: utf-8

control 'ubuntu' do
  describe package('docker-ce') do
    it { should be_installed }
  end

  describe package('docker-ce-cli') do
    it { should be_installed }
  end

  describe package('containerd.io') do
    it { should be_installed }
  end

  describe file('/usr/local/bin/docker-compose') do
    it { should exist }
    it { should be_executable }
  end

  describe user('kitchen') do
    it { should exist }
    its('groups') { should eq ['kitchen', 'docker']}
  end
end