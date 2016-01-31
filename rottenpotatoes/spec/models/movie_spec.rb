require 'rails_helper'

describe Movie do
  describe 'searching similar directors' do
    it 'should call Movie with director' do
      expect(Movie).to receive(:similar_directors).with('Star Wars')
      Movie.similar_directors('Star Wars')
    end
  end
end