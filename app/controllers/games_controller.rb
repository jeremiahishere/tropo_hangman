class GamesController < ApplicationController
  
  def hangman
    text = params["session"]["initialText"]
    from = params["session"]["from"]
    network = from["network"]
    phone_number = from["id"]

    if network == "SMS" && phone_number =~ /^[0-9]+$/ 
      @user = User.find_by_phone_number(phone_number)
      if @user.nil?
        @user = User.create(:phone_number => phone_number)
      end

      Message.create(:user => @user, :message_text => text)
      @game = Game.where(:user => @user, :in_progress => true).first

      # create a new game
      if @game.nil?
        text = ":new"
      else
        # the game exists
        if text == ":help" 
          # return helpful info 
          game_message "Available commands are :help, :new, and :word.  Guess a letter by sending a single letter."
        elsif text == ":new" 
          # end the current game and start a new game
          Game.where(:user => @user, in_progress => true).each do |game|
            game.update_attributes(:in_progress => false)
          end
          @game = Game.new(:user => @user, :word => Word.random_word, :in_progress => true, :guessed_letters => "")
          game_message = "Tropo Hangman: #{@game.partial_word}; Send a letter to guess or :help for help"
        elsif text == ":word" 
          # return the word with blanks filled in 
          game_message = "Partial word: #{@game.partial_word}; Guessed Letters: #{@game.guessed_letters}"
        else
          guess = text[0]
          @game.guess_letter(guess)
          if @game.win?
            game_message = "You have won. Send :new for a new game."
          else
            game_message = "Partial word: #{@game.partial_word}; Guessed Letters: #{@game.guessed_letters}"
          end
        end
      end
      render :json => Tropo::Generator.say(game_message)
    else
      render :json => Tropo::Generator.say("Unsupported operation")
    end
  end

  # GET /games
  # GET /games.xml
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game, :notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end
