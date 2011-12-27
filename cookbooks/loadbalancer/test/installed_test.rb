module HAProxy
  class InstalledTest < EY::Sommelier::TestCase
    scenario :iota

    def test_installed_on_app_master
      instance = instances(:app_master)
      instance.ssh!("which haproxy")
    end

    def test_installed_on_app
      instance = instances(:app)
      instance.ssh!("which haproxy")
    end

    def test_not_installed_db_master
      instance = instances(:db_master)
      ! instance.ssh!("which haproxy")
    end
  end
end
