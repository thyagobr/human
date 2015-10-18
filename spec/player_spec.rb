RSpec.describe Player do

  context "A new Player" do

    let(:player) { Player.new }

    it "has an empty inventory" do
      expect(player.inventory).to be_empty
    end

    it "may add items to the inventory" do
      item = Item.new(:wood)
      player.add_to_inventory item
      expect(player.inventory).to include item
    end

  end

end
