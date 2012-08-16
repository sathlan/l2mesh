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
Puppet::Parser::Functions::newfunction(:tinc_keygen, :type => :rvalue, :doc =>
  "Returns an array containing the tinc private and public (in this order) key.") do |args|
  private_key_path = "/tmp/rsa_key.priv"
  public_key_path = "/tmp/rsa_key.pub"
  ::FileUtils.rm_f([private_key_path, public_key_path])
  output = Puppet::Util.execute(['/usr/sbin/tincd', '--config', '/tmp', '--generate-keys'])
  raise Puppet::ParseError, "/usr/sbin/tincd --config /tmp --generate-keys output does not match the 'Generating .* bits keys' regular expression. #{output}" unless output =~ /Generating .* bits keys/
  [File.read(private_key_path),File.read(public_key_path)]
end
