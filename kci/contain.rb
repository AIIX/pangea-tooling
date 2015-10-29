#!/usr/bin/env ruby

require_relative '../lib/ci/containment'

Docker.options[:read_timeout] = 4 * 60 * 60 # 4 hours.

DIST = ENV.fetch('DIST')
JOB_NAME = ENV.fetch('JOB_NAME')

c = CI::Containment.new(JOB_NAME, image: CI::PangeaImage.new(:ubuntu, DIST))
status_code = c.run(Cmd: ARGV)
exit status_code
