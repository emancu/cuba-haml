require_relative "helper"

require "cuba/haml"

test "doesn't override the settings if they already exist" do
  Cuba.settings[:haml] = {
    :views => "./test/views",
    :layout => "guest"
  }

  Cuba.plugin Cuba::Haml

  assert_equal "./test/views", Cuba.settings[:haml][:views]
  assert_equal "guest", Cuba.settings[:haml][:layout]
end

scope do
  setup do
    Cuba.plugin Cuba::Haml
    Cuba.settings[:haml][:views] = "./test/views"
    Cuba.settings[:haml][:template_engine] = "haml"

    Cuba.define do
      on "home" do
        haml("home", name: "Agent Smith", title: "Home")
      end

      on "home2" do
        haml("home", 'layout-yield.haml', name: "Agent Smith", title: "Home")
      end

      on "about" do
        res.write partial("about", title: "About Cuba")
      end
    end
  end

  test "partial" do
    _, _, body = Cuba.call({ "PATH_INFO" => "/about", "SCRIPT_NAME" => "/" })

    assert_response body, ["<h1>About Cuba</h1>\n"]
  end

  test "haml" do
    _, _, body = Cuba.call({ "PATH_INFO" => "/home", "SCRIPT_NAME" => "/" })

    assert_response body, ["<title>Cuba: Home</title>\n<h1>Home</h1>\n<p>Hello Agent Smith</p>\n"]
  end

  test "view" do
    _, _, body = Cuba.call({ "PATH_INFO" => "/home2", "SCRIPT_NAME" => "/" })

    assert_response body, ["Header\n<h1>Home</h1>\n<p>Hello Agent Smith</p>\nFooter"]
  end
end

test "caching behavior" do
  Thread.current[:_cache] = nil

  Cuba.plugin Cuba::Haml
  Cuba.settings[:haml][:views] = "./test/views"

  Cuba.define do
    on "foo/:i" do |i|
      partial("test", title: i)
    end
  end

  10.times do |i|
    _, _, resp = Cuba.call({ "PATH_INFO" => "/foo/#{i}", "SCRIPT_NAME" => "" })
  end

  assert_equal 1, Thread.current[:_cache].instance_variable_get(:@cache).size
end

scope do
  setup do
    Cuba.plugin Cuba::Haml
    Cuba.settings[:haml][:views] = "./test/views"

    Cuba.define do
      on 'default_layout' do
        haml('content-yield', title: "Default layout")
      end

      on 'custom_layout' do
        view("layout-yield.haml", "content-yield")
      end
    end

    test "simple layout support" do
      _, _, resp = Cuba.call({ "PATH_INFO" => "/default_layout", "SCRIPT_NAME" => "" })
      assert_response resp, ["Cuba: Default layout\n"]
    end

    test "custom layout support" do
      _, _, resp = Cuba.call({ "PATH_INFO" => "/custom_layout", "SCRIPT_NAME" => "" })
      assert_response resp, ["Header\nThis is the actual content.\nFooter\n"]
    end
  end
end
