cuba-haml
=========

A Cuba plugin to use Haml

Configure
---------

__Cuba::Haml__ plugin introduces some __keys__ into _Cuba.settings_ to make easy the way to reander layouts

``` ruby
  # Default layouts directory
  app.settings[:haml][:layout_path] ||= app.settings[:haml][:views]
  
  # Default layout file
  app.settings[:haml][:layout] ||= "layout"
```

Feel free to overwrite this variables after install the plugin. Following this example
``` ruby
require "cuba/haml"

Cuba.plugin Cuba::Haml
Cuba.settings[:haml][:layout_path] = "some/other/path"
Cuba.settings[:haml][:layout] = "not_default_layout"
```


Rendering
---------

Cuba ships with a plugin that provides helpers for rendering templates.
But if only want to use haml, you can specify this plugin.

``` ruby
require "cuba/haml"

Cuba.plugin Cuba::Haml

Cuba.define do
  on default do

    # Within the partial, you will have access to the local variable `content`,
    # that will hold the value "hello, world".
    res.write render("home.haml", content: "hello, world")
  end
end
```

Using the method __render__, you need to provide _full path template_ so there are two methods to do it easy
`template_path(template_name)` and `layout_path(layout).`


But you can use the __haml__ helper to get a cleaner code
``` ruby
...
  on default do
    haml("home", content: "hello, world")
  end
...
```

Also if you want to override the _default layout_ you can use the __view__ helper
``` ruby
...
  on default do
    view("home", 'other-layout', content: "hello, world")
  end
...
```

Don't be afraid and read the tests, there are really simple I promisse!

> Note that in order to use this plugin you need to have [Haml](https://github.com/haml/haml) installed.