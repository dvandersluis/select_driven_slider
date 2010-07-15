module SelectDrivenSliderHelper
  def select_driven_slider_tag(name, values, default = nil, slider_options = {})
    options = values.is_a?(Array) ? options_for_select(values, default) : values 
    out = ""

    out << javascript_include_tag('slider')
    out << stylesheet_link_tag('slider')
    out << select_tag(name, options)

    id_base = name.gsub(/[\[\]]+/, "_").sub(/_+$/, "")
    
    out << content_tag(:div, :class => "slider", :id => id_base + "_slider", :style => "display: none;") do
      content_tag(:div, :class => "track", :id => id_base + "_track") do
        content_tag(:div, :class => "track-left") do
          content_tag(:div, :class => "handle", :id => id_base + "_handle") do
            image_tag('slider/handle.png', :style => "float: left")
          end
        end
      end <<
      content_tag(:div, :class => "track-label", :id => id_base + "_track-label") do
        default || values.first
      end <<
      tag(:br, :style => "clear: both;")
    end

    slider_options.reverse_merge!({
      "min" => 0,
      "max" => 100,
      "values" => "[" + values.map(&:to_i).join(",") + "]",
      "sliderValue" => default.to_i
    })

    out << javascript_tag do 
    %Q(
      (function() {
        var select = $('#{id_base}');
        var options = {
          range: $R(#{slider_options["rangeMin"] || slider_options["min"]}, #{slider_options["rangeMax"] || slider_options["max"]}),
          minimum: #{slider_options["min"]},
          maximum: #{slider_options["max"]},
          values: #{slider_options["values"]},
          sliderValue: #{slider_options["sliderValue"]},
          onSlide: function(value)
          {
            $('#{id_base + '_track-label'}').innerHTML = #{slider_options["labelValue"] || "value"};
          },
          onChange: function(value)
          {
            for (var i = 0; i < select.options.length; i++)
            {
              if (select.options[i].value == value + "%")
              {
                select.selectedIndex = i;
                break;
              }
            }
          }
        };

        select.hide();
        $('#{id_base + '_slider'}').show();
        new Control.Slider('#{id_base + '_handle'}', '#{id_base + '_track'}', options);
      })();
    )
    end

    out
  end
end
