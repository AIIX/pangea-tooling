# frozen_string_literal: true
#
# Copyright (C) 2017 Harald Sitter <sitter@kde.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) version 3, or any
# later version accepted by the membership of KDE e.V. (or its
# successor approved by the membership of KDE e.V.), which shall
# act as a proxy defined in Section 6 of version 3 of the license.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.

require_relative '../ci-tooling/test/lib/testcase'

require 'mocha/test_unit'

module NCI
  class CMakePackagesTest < TestCase
    def setup
      FileUtils.cp_r("#{data}/.", Dir.pwd, verbose: true)
    end

    def test_run
      pid = fork do
        # Needed so we can properly mock before loading the binary.
        require_relative '../nci/lint/cmake_packages'
        require_relative '../ci-tooling/nci/lib/setup_repo'

        ENV['TYPE'] = 'release'
        ENV['DIST'] = 'xenial'
        NCI.expects(:add_repo_key!).returns(true)
        Apt::Key.expects(:add).returns(true)
        Apt::Repository.any_instance.expects(:add).returns(true)
        Apt::Repository.any_instance.expects(:remove).returns(true)
        Aptly::Repository.expects(:get).returns(mock('aptly_repo'))
        Apt::Abstrapt.stubs(:run_internal).returns(true)
        DPKG.expects(:list).with('libkf5coreaddons-dev').returns(%w(
          /usr/lib/x86_64-linux-gnu/cmake/KF5CoreAddons/KF5CoreAddonsTargets.cmake
          /usr/lib/x86_64-linux-gnu/cmake/KF5CoreAddons/KF5CoreAddonsMacros.cmake
          /usr/lib/x86_64-linux-gnu/cmake/KF5CoreAddons/KF5CoreAddonsTargets-debian.cmake
          /usr/lib/x86_64-linux-gnu/cmake/KF5CoreAddons/KF5CoreAddonsConfigVersion.cmake
          /usr/lib/x86_64-linux-gnu/cmake/KF5CoreAddons/KF5CoreAddonsConfig.cmake)
        )
        CMakeDepVerify::Package.any_instance.expects(:run_cmake_in).returns(true)
        DPKG.stubs(:list).with { |x| x != 'libkf5coreaddons-dev' }.returns([])

        load "#{__dir__}/../nci/lint_cmake_packages.rb"
        puts 'all good, fork ending!'
        exit 0
      end
      assert_equal(pid, Process.waitpid(pid))
      assert($?.success?)
    end
  end
end