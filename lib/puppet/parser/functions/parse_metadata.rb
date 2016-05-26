module Puppet::Parser::Functions
    newfunction(:parse_metadata, :type => :rvalue) do |args|
        unless args.length == 0
            raise Puppet::ParseError, "parse_userdata(): Requires no arguments"
        end

        begin
            Puppet.warning("1")
            metadata = lookupvar('ec2_metadata')
			hash = metadata
        rescue
            Puppet.warning("parse_metadata(): Unable to parse JSON from ec2_metadata")
            hash = {}
        end

        hash
    end
end
