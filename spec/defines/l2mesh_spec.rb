#
#    Copyright (C) 2012 eNovance <licensing@enovance.com>
#	
#    Author: Loic Dachary <loic@dachary.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe 'l2mesh' do

  let :title do
    "TITLE"
  end

  let :params do
    {
      :name => 'NAME'
    }
  end

  describe 'when running on Debian GNU/Linux' do
    let :facts do
      {
        'osfamily' => 'Debian'
      }
    end

    it {
      should contain_package('tinc').with_ensure('present')
    }
  end

  describe 'when running on RedHat' do
    let :facts do
      {
        'osfamily' => 'RedHat'
      }
    end

    # it {
    #   should contain_package('????').with_ensure('present')
    # }
  end
  
  describe 'when running on unknown' do
    let :facts do
      {
        'osfamily' => 'Plan9'
      }
    end

    it do 
      expect {
        should contain_package('tinc')
      }.to raise_error(Puppet::Error, /Unsupported osfamily/)
    end

  end
  
end
