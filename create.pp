ec2_instance { 'Mengo-instance':
  ensure            => present,
  region            => 'us-east-1',
  availability_zone => 'us-east-1b',
  image_id          => 'ami-2d39803a',
  instance_type     => 't1.micro',
  security_groups   => ['default'],
   user_data         => template('/root/setup.sh'),
}