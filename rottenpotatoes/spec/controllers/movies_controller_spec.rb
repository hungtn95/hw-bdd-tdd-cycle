require 'rails_helper'
require 'spec_helper'

describe MoviesController do
  describe 'add director' do
    before :each do
      @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
      allow(Movie).to receive(:find).with("1").and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      allow(@m).to receive(:update_attributes!).and_return(true)
      put :update, :id => "1", :movie => {:director => @m.director, :title => @m.title}
      expect(response).to redirect_to(movie_path(@m))
    end
  end
  
  describe 'happy path' do
    before :each do
      @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
      allow(Movie).to receive(:find).with("1").and_return(@m)
    end
    
    it 'should generate routing for Similar Movies' do
      expect({ :get => similar_movies_path(1) }).to route_to(:controller => "movies", :action => "similar", :id => "1")
    end
    it 'should call the model method that finds similar movies' do
      fake_results = [double('Movie'), double('Movie')]
      expect(Movie).to receive(:similar_directors).with('director').and_return(fake_results)
      get :similar, :id => "1"
    end
    it 'should select the Similar template for rendering and make results available' do
      allow(Movie).to receive(:similar_directors).with('director').and_return(@m)
      get :similar, :id => "1"
      expect(response).to render_template('similar')
      expect(assigns(:movies)).to eq @m
    end
  end
  
  describe 'sad path' do
    before :each do
      m=double(Movie, :title => "Star Wars", :director => nil, :id => "1")
      allow(Movie).to receive(:find).with("1").and_return(m)
    end
    
    it 'should generate routing for Similar Movies' do
      expect({ :get => similar_movies_path(1) }).to route_to(:controller => "movies", :action => "similar", :id => "1")
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :similar, :id => "1"
      expect(response).to redirect_to(movies_path)
      expect(flash[:notice]).not_to be_blank
    end
  end
  
  describe 'create and destroy' do
    it 'should create a new movie' do
      @m = double(Movie, :id => "10", :title => "blah", :director => "Blah")
      allow(Movie).to receive(:create).and_return(@m)
      post :create, :id => "10", :movie => {:director => @m.director, :title => @m.title}
    end
    it 'should destroy a movie' do
      @m = double(Movie, :id => "10", :title => "blah", :director => nil)
      allow(Movie).to receive(:find).with("10").and_return(@m)
      expect(@m).to receive(:destroy)
      delete :destroy, :id => "10"
    end
  end
end