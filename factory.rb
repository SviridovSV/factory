class Factory
  def self.new(*args, &block)

    Class.new do
      args.each { |arg| attr_accessor}
      define_method :initialize do |*params|
        args.each_index do |i|
          instance_variable_set("@#{args[i]}", params[i])
        end
      end

      define_method :[] do |arg|
        get_argument(arg)
      end

      args.each do |arg|
        define_method arg do
          get_argument(arg)
        end
      end

      class_eval(&block) if block_given?

      private

      def get_argument(arg)
        if arg.kind_of?(Integer)
          instance_variable_get(instance_variables[arg])
        else
          instance_variable_get("@#{arg}")
        end
      end
    end
  end
end

Customer = Factory.new(:name, :address, :zip)
joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)

puts joe.name
puts joe['name']
puts joe[:name]
puts joe[0]

Customer1 = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end
puts Customer1.new('Dave', '123 Main').greeting

