module ShiftCommerce
  module <%= app_name.gsub(/^shift-/,'').camelize %>

    def self.gem_root
      File.expand_path("../../", __dir__)
    end

    # Models
    # Require base class first
    require File.join(gem_root, "app", "models", "<%= app_name.gsub(/^shift-/,'') %>", "base.rb")
    Dir.glob(File.join(gem_root, "app", "models", "**", "*.rb")).each { |f| require(f) }
  end
end
