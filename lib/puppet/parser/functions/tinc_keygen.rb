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
  "Returns an array containing the tinc private and public (in this order) key
  for a certain private key path.
  It will generate the keypair if both do not exist. It will also generate
  the directory hierarchy if required.
  It accepts only fully qualified paths, everything else will fail.") do |args|
    raise Puppet::ParseError, "Wrong number of arguments" if args.to_a.length < 1 || args.to_a.length > 2
    name = args.to_a[0]
    if args.to_a.length > 1
      dir = args.to_a[1]
      raise Puppet::ParseError, "Only fully qualified paths are accepted (#{dir})" unless dir =~ /^\/.+/
    else
      dir = File.join('/etc/tinc',name)
    end
    private_key_path = File.join(dir,"rsa_key.priv")
    public_key_path = File.join(dir,"rsa_key.pub")
    raise Puppet::ParseError, "Either only the private or only the public key exists" if File.exists?(private_key_path) ^ File.exists?(public_key_path)

    ::FileUtils.mkdir_p(dir) unless File.directory?(dir)
    unless [private_key_path,public_key_path].all?{|path| File.exists?(path) }
      output = Puppet::Util.execute(['/usr/sbin/tincd', '-c', dir, '-n', name, '-K'])
      raise Puppet::ParseError, "Something went wrong during key generation! Output: #{output}" unless output =~ /Generating .* bits keys/
    end
    [File.read(private_key_path),File.read(public_key_path)]
end
