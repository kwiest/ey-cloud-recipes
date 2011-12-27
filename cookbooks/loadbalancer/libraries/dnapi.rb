require "dnapi"

class Chef::Node
  def engineyard
    @engineyard ||= DNApi.from(File.read("/etc/chef/dna.json"))
  end
end

module DNApi
  class Environment
    def stunneled?
      self.component?(:stunneled) && self.apps.any? { |app| app.https? }
    end
  end
end

