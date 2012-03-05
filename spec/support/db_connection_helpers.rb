module DbConnectionHelpers
  def update_table(table)
    have_received(:update).with() {|*args|
      args.first.ast.relation.name == table
    }
  end
end

RSpec.configure do |config|
  config.include DbConnectionHelpers
end
