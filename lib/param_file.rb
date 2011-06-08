class ParamFile
  def initialize
    @params = YAML.load_file("#{Rails.root}/config/params.yml")
  end

  def method_missing method, *args, &block
    if result = @params[method.to_s]
      return result
    end
    super method, *args, &block
  end
end