require 'spec_helper'
require 'board'

RSpec.describe Board do

  before do
    @game = Game.new(load_screen: false)
  end

  subject { @game.board }

  context "when creating a new Board on a new game" do
    it { is_expected.to be_an_instance_of Board }

    its(:tiles_width) { is_expected.to eql (Game::DEFAULT_WIDTH / Game::DEFAULT_TILE_SIZE) }
    its(:tiles_height) { is_expected.to eql (Game::DEFAULT_HEIGHT / Game::DEFAULT_TILE_SIZE) }
    its("tileset.size") do
      is_expected.to eql ((Game::DEFAULT_WIDTH / Game::DEFAULT_TILE_SIZE) * (Game::DEFAULT_HEIGHT / Game::DEFAULT_TILE_SIZE))
    end

  end

  describe "#fetch_by_coords" do
    it "fetches the tileset index representing given map coordinates" do
      @game.board.tileset[54] = Tile.new
      content_by_coords = @game.board.fetch_by_coords(300, 200)
      expect(content_by_coords).to eql @game.board.tileset[(300 / Game::DEFAULT_TILE_SIZE) * (200 / Game::DEFAULT_TILE_SIZE)]
    end
  end

  describe "#add_player" do
    before do
      @game.board.add_player Player.new
    end

    subject { @game.board.players.first }

    it { is_expected.to be_an_instance_of Player }

    its(:pos) { is_expected.to eql [0, 0] }
  end
end
