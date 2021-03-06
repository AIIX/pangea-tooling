# frozen_string_literal: true
#
# Copyright (C) 2018 Harald Sitter <sitter@kde.org>
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

# downloads and makes available as arrays lists of KDE projects which 
# are part of Plasma, Applications and Frameworks

require 'httparty'

class KDEProjectsComponent
  class << self
    @@projects_to_jobs = {'kirigami'=>'kirigami2', 'discover'=>'plasma-discover'}
    @@projects_without_jobs = ['plasma-tests']

    def frameworks
      @frameworks ||= to_names(projects('frameworks'))
    end

    def frameworks_jobs
      @frameworks_packgaes ||= to_jobs(frameworks)
    end

    def pim
      @pim ||= to_names(projects('kde/pim'))
    end

    def pim_jobs
      @pim_packgaes ||= to_jobs(pim)
    end

    def applications
      @applications ||= begin
        apps = projects('kde').reject {|x| x.start_with?('kde/workspace') }
        to_names(apps)
      end
    end

    def applications_jobs
      @applications_jobs ||= to_jobs(applications)
    end

    def plasma
      @plasma ||= to_names(projects('kde/workspace'))
    end

    def plasma_jobs
      @plasma_jobs ||= to_jobs(plasma).reject {|x| @@projects_without_jobs.include?(x)}
    end

    private

    def to_jobs(projects)
        projects.collect {|x| @@projects_to_jobs[x]? @@projects_to_jobs[x] : x}
    end

    def to_names(projects)
      projects.collect { |project| project.split('/')[-1] }
    end

    def projects(filter)
      url = "https://projects.kde.org/api/v1/projects/#{filter}"
      response = HTTParty.get(url)
      response.parsed_response
    end
  end
end
