require 'spec_helper'
require 'board'

RSpec.describe Board do

  before do
    @game = Game.new
  end

  subject { @game.board }

  context "when creating a new Board on a new game" do
    it { is_expected.to be_an_instance_of Board }

    it "is 800x600 with 32px tiles by default" do
      expect(@game.board.tiles_width).to eql (800 / 32)
      expect(@game.board.tiles_height).to eql (600 / 32)
      expect(@game.board.tileset.size).to eql ((800 / 32) * (600 / 32))
    end
  end

  describe "#fetch_by_coords" do
    it "fetches the tileset index representing given map coordinates" do
      @game.board.tileset[54] = Tile.new
      content_by_coords = @game.board.fetch_by_coords(300, 200)
      expect(content_by_coords).to eql @game.board.tileset[(300/32) * (200/32)]
    end
  end

  describe "#add_player" do
    it "may contain players" do
      @game.board.add_player Player.new
      @game.board.players.first.must_be_instance_of Player
    end
  end
end
