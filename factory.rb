class Factory
  def self.new(*args, &block)
    args.each { |arg| raise TypeError, 'Arguments must be symbol' unless arg.kind_of?(Symbol) }

    Class.new do
      args.each { |arg| attr_accessor arg}
      define_method :initialize do |*params|
        args.each_index do |i|
          instance_variable_set("@#{args[i]}", params[i])
        end
      end

      define_method :[] do |arg|
        raise TypeError, 'Arguments can not be blank' if arg
        get_argument(arg)
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

