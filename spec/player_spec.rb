require 'spec_helper'
require 'player'

RSpec.describe Player do

  context "when creating a new Player" do

    let(:player) { Player.new }

    it "is only valid with coords" do
      expect(player.pos).to eql [0,0]
    end

  end

end
