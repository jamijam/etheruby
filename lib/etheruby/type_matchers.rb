module Etheruby

  module TypeMatchers

    def is_sized_type(param)
      param.to_s.match /^([a-z]+)(\d+)$/
    end

    def is_dualsized_type(param)
      param.to_s.match /^([a-z]+)(\d+)x(\d+)$/
    end

    def is_static_array_type(param)
      param.to_s.match(/^(.+)\[(\d+)\]$/)
    end

    def is_dynamic_array_type(param)
      param.to_s.match(/^(.+)\[\]$/)
    end

    module_function :is_sized_type, :is_dualsized_type,
                    :is_static_array_type, :is_dynamic_array_type
  end

end
