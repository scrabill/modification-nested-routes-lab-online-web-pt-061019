class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      # binding.pry
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    @song = Song.new
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artist_songs_path, alert: "Artist not found"
      else
        # binding.pry
        @artist.songs.create(song_params)

        # @song.update(song_params)
        # @song.save
        # @artist.songs << @song
        redirect_to artist_song_path(@song)
        # redirect_to artist_path(artist)
        # redirect_to artist_song_path(@song)
      end
    end

  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit

    @song = Song.find_by_id(params[:id])
    @artist = Artist.find_by_id(params[:artist_id])
    if @song

      if @artist
        # binding.pry
        if @artist.songs.ids.include?(@song.id)
          redirect_to artist_songs_path(@artist)
        else
          artists_path
        end
      else
        artists_path
      end
    end


    # @artist = Artist.find_by_id(params[:artist_id])



    # if the artist exists, but the song id does not exist for that artist
    # redirect_to artists_path
    # if everything is good
    # redirect_to artist_songs_path(@artist)

    # if params[:artist_id]
    #   @song = Song.find_by(id: params[:id])
    #   @artist = Artist.find_by(id: params[:artist_id])
    #
    #   if @song.artist_id == @artist.id
    #     # everything is valid
    #   else
    #   end
    # end

    # if !@song.nil? && @song.artist_id == @artist.id
    #   # do something
    # else
    #   redirect_to artists_path
    # end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end
